function [Transform,debug] = EstimateTransScaleTransform(Image1,Image2,params,initialHomog)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function estimates projective transform between 2 input images using
% RANSAC algorithm for robust estimation.
%
% [Transform,debug] = EstimateProjectiveTransform(Image1,Image2,params);
%
% Inputs:
%   Image1: First input image (GL image)
%   Image2: Second input image (GL image)
%   params: Struct with input parameters
%
% Outputs:
%   Transform: Calculated 3x3 transform
%   debug: debug struct
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Transform = [];
debug = [];

% read parameters
LK_PyramidDepth = params.LK_PyramidDepth;
NumSubWindowsPerAxis = params.NumSubWindowsPerAxis;
NumPointsPerSubWindow = params.NumPointsPerSubWindow;
KeyPointsMinThrFactor = params.KeyPointsMinThrFactor;
KeyPointsThrFactor = params.KeyPointsThrFactor;
MaxShiftLimit = params.MaxShiftLimit;
MaxShiftRefPercentile = params.MaxShiftRefPercentile;
MaxPointsShiftFactor = params.MaxPointsShiftFactor;
RANSAC_MaxIters = params.RANSAC_MaxIters;
RANSAC_NumIters = params.RANSAC_NumIters;
RANSAC_Size0 = params.RANSAC_Size0;
RANSAC_GoodRatio = params.RANSAC_GoodRatio;
RANSAC_StopRatio = params.RANSAC_StopRatio;
RANSAC_MaxValidPointsDist1 = params.RANSAC_MaxValidPointsDist1;
RANSAC_MaxValidPointsDist2 = params.RANSAC_MaxValidPointsDist2;
SelectHighestModality = params.SelectHighestModality;
myeps = params.myeps;
MaxValidPointsDistSqr1 = RANSAC_MaxValidPointsDist1 * RANSAC_MaxValidPointsDist1;
MaxValidPointsDistSqr2 = RANSAC_MaxValidPointsDist2 * RANSAC_MaxValidPointsDist2;

% find key points on Image1 (divide into windows in order to get approximately uniform distribution across frame)
WindowsList = WindowTileSimple(size(Image1,2),size(Image1,1),NumSubWindowsPerAxis,NumSubWindowsPerAxis,0);
Points1 = {};
count = 0;
eig = cv.cornerMinEigenVal(uint8(Image1));
GlobalThreshold = max2(eig) * KeyPointsThrFactor;
for n = 1:length(WindowsList)
    Window = Image1(WindowsList(n,3):WindowsList(n,4),WindowsList(n,1):WindowsList(n,2));
    WindowPoints = cv.goodFeaturesToTrack(Window,'MaxCorners',NumPointsPerSubWindow,'QualityLevel',KeyPointsMinThrFactor);
    for p = 1:length(WindowPoints)
        xx = WindowPoints{p}(1) + WindowsList(n,1) - 1;
        yy = WindowPoints{p}(2) + WindowsList(n,3) - 1;
        if( eig(yy,xx) > GlobalThreshold )
            count = count + 1;
            Points1{count} = [WindowPoints{p}(1) + WindowsList(n,1) - 1, WindowPoints{p}(2) + WindowsList(n,3) - 1];
        end
    end
end


initialPoints = cell(1,length(Points1));
for i=1:length(Points1)
    p = initialHomog * [Points1{i}';1];
    initialPoints{i} = p(1:2)'/p(3);
end
% find the corresponding points on Image2
[Points2,status0] = cv.calcOpticalFlowPyrLK(Image1,Image2,Points1,'MaxLevel',LK_PyramidDepth,'InitialFlow',initialPoints);
status = RemovePointsBeyondFrame(Points2,status0,size(Image2));
% repack the remained points
Points1org = Points1; Points2org = Points2; countorg = count; % for debugging only
[Points1,Points2,count] = RepackPoints(Points1,Points2,count,status,MaxShiftLimit,MaxShiftRefPercentile,MaxPointsShiftFactor,SelectHighestModality);

% debug:
% myim(Image1); colormap gray; for n = 1:length(Points1), hold on; p = Points1{n}; plot(p(1),p(2),'xr'); end; myim(Image2); colormap gray; for n = 1:length(Points2), hold on; p = Points2{n}; plot(p(1),p(2),'xr'); end;
% myim(Image1); colormap gray; for n = 1:length(Points1org), hold on; p = Points1org{n}; plot(p(1),p(2),'xr'); end; myim(Image2); colormap gray; for n = 1:length(Points2org), hold on; p = Points2org{n}; plot(p(1),p(2),'xr'); end;

debug.count = count;

if( count < RANSAC_Size0 )
    return;
end

% switch to different format for faster Matlab runtime
P1 = ConvertPoints(Points1);
P2 = ConvertPoints(Points2);
% figure
% imshow([Image1,Image2]);
% hold on
% plot(P1(:,1),P1(:,2),'.');
% for (i=1:size(P1,1))
% plot([P1(i,1),P2(i,1)],[P1(i,2),P2(i,2)])
% end
% plot(P2(:,1)+size(Image1,2),P2(:,2),'.');

PointsMat1 = [P1(:,1)'; P1(:,2)'];
PointsMat2 = [P2(:,1)'; P2(:,2)'; ones(1,count)];

%plot(P1(:,1),P1(:,2),'.');
%plot(P2(:,1)+size(Image1,2),P2(:,2),'.');


% RANSAC inits
NumEstimations = 0;
BestGoodCount = 0;

% RANSAC loop
for k = 1:RANSAC_MaxIters
    % choose random RANSAC_Size0 non-complanar points from Image1 & Image2
    for k1 = 1:RANSAC_MaxIters
        idx = DrawKNumbersOfN(count,RANSAC_Size0);
        ReDrawPoint = false;
        for i = 1:RANSAC_Size0;
            for j = i+1:RANSAC_Size0
                if( idx(j) == idx(i) )
                    ReDrawPoint = true;
                    break;
                end
                % check that the points are not very close one each other
                if( abs(Points1{idx(i)}(1) - Points1{idx(j)}(1)) + abs(Points1{idx(i)}(2) - Points1{idx(j)}(2)) < eps )
                    ReDrawPoint = true;
                    break;
                end
                if( abs(Points2{idx(i)}(1) - Points2{idx(j)}(1)) + abs(Points2{idx(i)}(2) - Points2{idx(j)}(2)) < eps )
                    ReDrawPoint = true;
                    break;
                end
            end
            if( ReDrawPoint ) % reached "break" - meaning, point is too close to another point
                continue;
            end
        end
        A = zeros(RANSAC_Size0,2);
        B = zeros(RANSAC_Size0,2);
        a=cell(0); b=cell(0);
        for l=1:RANSAC_Size0
            a{l} = Points1{idx(l)};
            A(l,:) = [a{l}(1) a{l}(2)];
            
            b{l} = Points2{idx(l)};
            B(l,:) = [b{l}(1) b{l}(2)];
        end
        if( RANSAC_Size0 > 2 && i == RANSAC_Size0 ) % additional check for non-complanar vectors
            dax1 = a{2}(1) - a{1}(1); day1 = a{2}(2) - a{1}(2);
            dax2 = a{3}(1) - a{1}(1); day2 = a{3}(2) - a{1}(2);
            dbx1 = b{2}(1) - b{1}(1); dby1 = b{2}(2) - b{1}(2);
            dbx2 = b{3}(1) - b{1}(1); dby2 = b{3}(2) - b{1}(2);
            
            if( abs(dax1*day2 - day1*dax2) < myeps * sqrt(dax1*dax1+day1*day1) * sqrt(dax2*dax2+day2*day2) || ...
                    abs(dbx1*dby2 - dby1*dbx2) < myeps * sqrt(dbx1*dbx1+dby1*dby1) * sqrt(dbx2*dbx2+dby2*dby2) )
                continue;
            end
        end
    break;
    end
    if( k1 >= RANSAC_MaxIters )
        break;
    end
    
    if( i < RANSAC_Size0 )
        continue;
    end
    
%     figure
%     imshow([Image1,Image2]);
%     hold on
%     for (ii=1:4)
%         plot([Points1{idx(ii)}(1),Points2{idx(ii)}(1)+size(Image1,2)],[Points1{idx(ii)}(2),Points2{idx(ii)}(2)],'o-');
%     end
    
    % if reached RANSAC_NumIters - return best transform found
    NumEstimations = NumEstimations + 1;
    if( NumEstimations > RANSAC_NumIters )
        debug.BestGoodCount = BestGoodCount;
        return;
    end
    
    % estimate the transform using 4 points
    %M = cv.findHomography(B,A);
    M = SolveTranslationScale(B',A');
    %M= cv.estimateRigidTransform(PointsToCells(B),PointsToCells(A));
    if(~isempty(M))
        %M = [M;[0 0 1]];
    
    % find which points obey the transform that was found up to distance MaxValidPointsDist1
    
        [good_idx,good_count] = FindGoodPoints(M,PointsMat2,PointsMat1,count,MaxValidPointsDistSqr1);
    else
        good_count = 0;
    end
    
    if( good_count >= count*RANSAC_GoodRatio )

        % estimate a new transform using all points that were found obeying the transfrom
        M = SolveTranslationScale(P2(good_idx,:)',P1(good_idx,:)');
        %M = cv.estimateRigidTransform(PointsToCells(P2(good_idx,:)),PointsToCells(P1(good_idx,:)));
        %M = [M;[0 0 1]];
        
        % find how many points obey the new transform that was found up to distance MaxValidPointsDist2
        [~,good_count] = FindGoodPoints(M,PointsMat2,PointsMat1,count,MaxValidPointsDistSqr2);
        
        % if enough points obey the transform: return this transform
        if( good_count >= count*RANSAC_StopRatio )
            Transform = M;
            debug.BestGoodCount = BestGoodCount;
            return;
        end
        
        % save best transform so far
        if( good_count > BestGoodCount )
            BestGoodCount = good_count;
            Transform = M;
        end
        
    end
    
end

debug.BestGoodCount = BestGoodCount;