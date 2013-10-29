function res = DiffSkip(x,n)
res = x(n+1:end)-x(1:end-n);