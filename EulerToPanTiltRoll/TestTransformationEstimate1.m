imagesPath = '..\CamTrax - Movies\Images\original\';
filenameTemplate = 'd.jpg';
inputRange = 1:22;

im1 = imread([imagesPath,'1.jpg']);
im2 = imread([imagesPath,'2.jpg']);
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);

transformationParams = GenerateParams();
[Transform,debug] = EstimateProjectiveTransform(im2,im1,transformationParams);