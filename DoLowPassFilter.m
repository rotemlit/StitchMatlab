function res = DoLowPassFilter(x,dt,beta)
res = zeros(size(x));
lp = LowPassFilter(beta);
for i=1:numel(x)
    res(i) = lp.Process(dt,x(i));
end