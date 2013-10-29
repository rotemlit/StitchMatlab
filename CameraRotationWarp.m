function im2Warped = CameraRotationWarp(im2,R1,R2,f)
fx = 1400.3;
fy = 1395.87;
cX = 349.65;
cY = 628.28;
K = [fx 0  cX;
     0  fy cY;
     0  0  1 ];
H = K*R2*R1'*inv(K);
im2Warped = cv.warpPerspective(im2,H,'WarpInverse',false,'Interpolation','Lanczos4');