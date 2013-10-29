function R = GenerateRotationMatFromThetaPhiOmega(theta,phi,omega)
R = RotationAroundZ(phi*pi/180)*RotationAroundX(theta*pi/180)*RotationAroundY(omega*pi/180)*RotationAroundX(-pi/2);