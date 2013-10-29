function res = rotationAroundX(ang)
c = cos(ang);
s = sin(ang);
res = [1  0  0;
       0  c -s;
       0  s  c];
