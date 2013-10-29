function res = rotationAroundZ(ang)
c = cos(ang);
s = sin(ang);
res = [c -s 0;
       s  c 0;
       0  0 1];
