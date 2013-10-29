[data,im] = LoadData('Gyro and Accelerometer\Slow Scan To The Right\20131003_211819_551.log',2326);
s = size(im{1});
% im2={};
% j=1;
% for i=1:3:length(im)
%     im2{j}=im{i};
%     j=j+1;
% end
% im=im2;
stitch = zeros(s(1)*2,s(2)*10,3,'uint8');
stitch(1:s(1),1:s(2),:)=im{1};
T0=eye(3);
for i=2:length(data.images.beginI)
    [T,debug] = EstimateRigidTransform(rgb2gray(im{i-1}),rgb2gray(im{i}),GenerateParams_2);
    T0 = T*T0;
    stitch2 = zeros(s(1)*2,s(2)*10,3,'uint8');
    stitch2(1:s(1),1:s(2),:)=im{i};
    c=cv.warpPerspective(stitch2,T0,'WarpInverse',false);
    stitch(c(:)~=0)=c(c(:)~=0);
    imshow(stitch);
    %figure;
    %imshow([im{i-1},im{i},c,im{i-1}-im{i},im{i-1}-c]);
end