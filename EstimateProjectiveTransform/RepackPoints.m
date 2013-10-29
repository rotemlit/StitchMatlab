function [Points1,Points2,count_out] = RepackPoints(p1,p2,count,status,MaxShiftLimit,MaxShiftRefPercentile,MaxPointsShiftFactor,SelectHighestModality)

Points1 = {};
Points2 = {};

if( MaxShiftLimit )
    DistSqrVec = zeros(1,count);
    for ii = 1:count
        DistSqrVec(ii) = (p1{ii}(1) - p2{ii}(1))^2 + (p1{ii}(2) - p2{ii}(2))^2;
    end
    DistSqrVecSorted = sort(DistSqrVec);
    RefIndx = max(1,round(MaxShiftRefPercentile * count));
    RefDist = sqrt(min(DistSqrVecSorted(RefIndx)));
    DistSqrThr = (RefDist * MaxPointsShiftFactor)^2;
    status2 = (DistSqrVec <= DistSqrThr);
else
    status2 = ones(1,count);
end

if (SelectHighestModality)
    P1 = zeros(length(p1),2);
    P2 = zeros(length(p2),2);
    for i=1:length(p1)
        P1(i,:) = p1{i};
        P2(i,:) = p2{i};
    end
    D = P2-P1;
    [n,yout] = hist(D(:,2),50);
    [m,nMax] = max(n);
    yMax = yout(nMax);
    Iy = abs(D(:,2)-yMax) < 20;
    [n,xout] = hist(D(Iy,1),50);
    [m,nMax] = max(n);
    xMax = xout(nMax);
    status3 = abs(D(:,1) - xMax) < 20 & Iy; 
else
    status3 = true(1,count);
end

k = 0;
for ii = 1:count
    if( status(ii) && status2(ii) && status3(ii) )
        k = k + 1;
        Points1{k} = p1{ii};
        Points2{k} = p2{ii};
    end
end
count_out = k;
