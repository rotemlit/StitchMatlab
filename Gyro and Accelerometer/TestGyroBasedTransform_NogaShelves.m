im1 = imread('Archive\SmallApp1\IMG_0097.JPG');
im2 = imread('Archive\SmallApp1\IMG_0102.JPG');
im1 = imrotate(im1,-90);
im2 = imrotate(im2,-90);
im1Big = zeros(size(im1,1)*3,size(im1,2)*3,3,'uint8');
im1Big(size(im1,1)+1:size(im1,1)*2,size(im1,2)+1:size(im1,2)*2,:) = im1;
im2Big = zeros(size(im2,1)*3,size(im2,2)*3,3,'uint8');
im2Big(size(im2,1)+1:size(im2,1)*2,size(im2,2)+1:size(im1,2)*2,:) = im2;

R2 = [0.927594, -0.370804, -0.045541; 0.211078, 0.419602, 0.882825; -0.308246, -0.828516, 0.467489]';
R1 = [0.716583, -0.696738, -0.032640; 0.336987, 0.304855, 0.890788; -0.610695, -0.649323, 0.453246]';
im2Warped = CameraRotationWarp(im2Big,R1,R2,1760);
figure;
imshow([im1Big im2Warped]);

% im3 = imread('SmallApp1\IMG_0091.JPG');
% im3 = imrotate(im3,-90);
% im3Big = zeros(size(im3,1)*3,size(im3,2)*3,3,'uint8');
% im3Big(size(im3,1)+1:size(im3,1)*2,size(im3,2)+1:size(im3,2)*2,:) = im3;
% R3 = [0.997080, 0.059451, -0.047935; 0.016130, 0.449580, 0.893094; 0.074646, -0.891259, 0.447308];
% im3Warped = CameraRotationWarp(im3Big,R1,R3,1760);
% figure;
% imshow([im1Big im3Warped]);
