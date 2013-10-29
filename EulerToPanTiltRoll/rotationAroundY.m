function res = rotationAroundY(ang)
c = cos(ang);
s = sin(ang);
res = [c  0 s;
       0  1 0;
       -s 0 c];