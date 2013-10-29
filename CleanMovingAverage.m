function res = CleanMovingAverage(x,window,numOfStds)
m = filter(ones(1,window)/window,1,x);
M = filter(ones(1,window)/window,1,x.^2);

s = sqrt(M-m.^2);

top = m+numOfStds*s;
bottom = m-numOfStds*s;

y = min(x,top);
y = max(y,bottom);

res = filter(ones(1,window)/window,1,y);