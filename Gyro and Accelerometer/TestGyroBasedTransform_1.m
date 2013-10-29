im1 = imread('Archive\NogaShelves\IMG_0354.JPG');
im2 = imread('Archive\NogaShelves\IMG_0357.JPG');
im1 = imrotate(im1,-90);
im2 = imrotate(im2,-90);
im1Big = zeros(size(im1,1)*3,size(im1,2)*3,3,'uint8');
im1Big(size(im1,1)+1:size(im1,1)*2,size(im1,2)+1:size(im1,2)*2,:) = im1;
im2Big = zeros(size(im2,1)*3,size(im2,2)*3,3,'uint8');
im2Big(size(im2,1)+1:size(im2,1)*2,size(im2,2)+1:size(im1,2)*2,:) = im2;

roll = 1.679296 * pi/180;
tilt = 11.407019 * pi/180;
pan = -117.911659 * pi/180;

R0 = RotationAroundZ(roll)*RotationAroundX(0   );%*RotationAroundY(0)*RotationAroundX(-pi/2);
R1 = RotationAroundZ(roll)*RotationAroundX(-tilt);%*RotationAroundY(0)*RotationAroundX(-pi/2);

%R1 = [-0.462787, 0.886004, -0.028726; -0.188413, -0.066646, 0.979826; 0.866215, 0.458863, 0.197777];
%R2 = [-0.478499, 0.877781, -0.023242; -0.464205, -0.230404, 0.855235; 0.745354, 0.420018, 0.517718];
% im2Warped = CameraRotationWarp(im2Big,R1,R2,1760);
% figure;
% imshow([im1Big im2Warped]);

figure
im1Warped = CameraRotationWarp(im1Big,R0,R1,1);
imshow([im1Big,im1Warped]);

% im3 = imread('SmallApp1\IMG_0091.JPG');
% im3 = imrotate(im3,-90);
% im3Big = zeros(size(im3,1)*3,size(im3,2)*3,3,'uint8');
% im3Big(size(im3,1)+1:size(im3,1)*2,size(im3,2)+1:size(im3,2)*2,:) = im3;
% R3 = [0.997080, 0.059451, -0.047935; 0.016130, 0.449580, 0.893094; 0.074646, -0.891259, 0.447308];
% im3Warped = CameraRotationWarp(im3Big,R1,R3,1760);
% figure;
% imshow([im1Big im3Warped]);
imwrite([im1Big,im1Warped],'testMovement.png');
