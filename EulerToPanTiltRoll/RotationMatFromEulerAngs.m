function res = RotationMatFromEulerAngs(yaw, pitch, roll)
res = rotationAroundZ(yaw)*rotationAroundX(pitch)*rotationAroundY(roll);
