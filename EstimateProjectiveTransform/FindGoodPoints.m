function [good_idx,good_count] = FindGoodPoints(M,PointsMat1,PointsMat2,count,MaxValidPointsDistSqr)

OutputPointMat0 = M * PointsMat1;
OutputPointMat = zeros(2,count);
OutputPointMat(1,:) = OutputPointMat0(1,:)./OutputPointMat0(3,:);
OutputPointMat(2,:) = OutputPointMat0(2,:)./OutputPointMat0(3,:);

DistXYMatSqr = (OutputPointMat - PointsMat2).^2;

DistVecSqr = DistXYMatSqr(1,:) + DistXYMatSqr(2,:);

good_idx = find(DistVecSqr < MaxValidPointsDistSqr);

good_count = length(good_idx);