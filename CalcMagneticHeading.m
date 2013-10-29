function heading = CalcMagneticHeading(magnetometer,gravity,tilt,roll)
gravNorm = gravity/norm(gravity);
magneticOnGravity = magnetometer * gravNorm';
magnetHorizon = magnetometer - magneticOnGravity * gravNorm;
X = [1 0 0];
R = rotationAroundZ(roll*pi/180)*rotationAroundX(tilt*pi/180)*rotationAroundX(-pi/2);
xInPhoneCoor = R * X';
heading = acos((magnetHorizon * xInPhoneCoor) / (norm(xInPhoneCoor)*norm(magnetHorizon)))*180/pi;