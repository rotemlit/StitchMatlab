function res = PointsToCells(points)
res = cell(size(points,1),1);
for i=1:size(points,1)
    res{i} = points(i,:);
end
