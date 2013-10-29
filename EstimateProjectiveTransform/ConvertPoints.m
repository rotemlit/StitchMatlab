function Points = ConvertPoints(p)

Points = zeros(length(p),2);

for k = 1:length(p)
    Points(k,1) = p{k}(1);
    Points(k,2) = p{k}(2);
end