function [pan,tilt,roll] = DecomposeRotationMatToZXY(mat)
roll = atan2(-mat(1,2),mat(2,2));
c = cos(roll);
s = sin(roll);
tilt = atan2(mat(3,2),-mat(1,2)*s+mat(2,2)*c);
pan = atan2(mat(1,3)*c+mat(2,3)*s,mat(1,1)*c+mat(2,1)*s);