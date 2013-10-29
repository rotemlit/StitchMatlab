function res = DoubleIntegration(t,x)
d = diff(t);
x1 = cumsum(x(2:end).*d);
res = [0 cumsum(x1.*d)];