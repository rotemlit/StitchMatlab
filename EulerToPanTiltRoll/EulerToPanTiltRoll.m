function PTR = EulerToPanTiltRoll(yaw,pitch,roll)
R = RotationMatFromEulerAngs(yaw,pitch,roll)';
R =R*rotationAroundX(pi/2);
[pan,tilt,roll] = DecomposeRotationMatToZXY(R);
PTR = [pan,tilt,roll]*180/pi;