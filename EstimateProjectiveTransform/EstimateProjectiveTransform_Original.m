function [Transform,debug] = EstimateProjectiveTransform(Image1,Image2,params)
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


% Deltas = {};
% for (i=1:length(Points1))
%     Deltas{i} = Points1{i}+[-600,0];
% end
% find the corresponding points on Image2
[Points2,status0] = cv.calcOpticalFlowPyrLK(Image1,Image2,Points1,'MaxLevel',2);
%[Points2,status0] = cv.calcOpticalFlowPyrLK(Image1,Image2,Points1,'MaxLevel',5,'InitialFlow',Deltas);
status = RemovePointsBeyondFrame(Points2,status0,size(Image2));
% repack the remained points
Points1org = Points1; Points2org = Points2; countorg = count; % for debugging only
[Points1,Points2,count] = RepackPoints(Points1,Points2,count,status,MaxShiftLimit,MaxShiftRefPercentile,MaxPointsShiftFactor);

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
PointsMat1 = [P1(:,1)'; P1(:,2)'];
PointsMat2 = [P2(:,1)'; P2(:,2)'; ones(1,count)];

%plot(P1(:,1),P1(:,2),'.');
%plot(P2(:,1)+size(Image1,2),P2(:,2),'.');


% RANSAC inits
NumEstimations = 0;
BestGoodCount = 0;

% RANSAC loop
for k = 1:RANSAC_MaxIters
    
    % choose random 4 non-complanar points from Image1 & Image2
    idx = zeros(1,RANSAC_Size0);
    for i = 1:RANSAC_Size0
        for k1 = 1:RANSAC_MaxIters
            idx(i) = randi(count,1);
            ReDrawPoint = false;
            for j = 1:(i-1)
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
            if( i == RANSAC_Size0 )
                % additional check for non-complanar vectors
                a{1} = Points1{idx(1)};
                a{2} = Points1{idx(2)};
                a{3} = Points1{idx(3)};
                a{4} = Points1{idx(4)};
                A = [a{1}(1) a{1}(2); a{2}(1) a{2}(2); a{3}(1) a{3}(2); a{4}(1) a{4}(2)];
                
                b{1} = Points2{idx(1)};
                b{2} = Points2{idx(2)};
                b{3} = Points2{idx(3)};
                b{4} = Points2{idx(4)};
                B = [b{1}(1) b{1}(2); b{2}(1) b{2}(2); b{3}(1) b{3}(2); b{4}(1) b{4}(2)];
                
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
    M = cv.findHomography(B,A);
    
    % find which points obey the transform that was found up to distance MaxValidPointsDist1
    [good_idx,good_count] = FindGoodPoints(M,PointsMat2,PointsMat1,count,MaxValidPointsDistSqr1);
    
    if( good_count >= count*RANSAC_GoodRatio )

        % estimate a new transform using all points that were found obeying the transfrom
        M = cv.findHomography(P2(good_idx,:),P1(good_idx,:));
        
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