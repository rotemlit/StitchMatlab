%[data,im] = LoadData('Gyro and Accelerometer\Cabinet 2\20131005_155923_119.log',2427);
[data,im] = LoadData('Gyro and Accelerometer\Cabinet Close 2 passes\20131005_171445_820.log',2479);
s = size(im{1});
% im2={};
% j=1;
% for i=1:3:length(im)
%     im2{j}=im{i};
%     j=j+1;
% end
% im=im2;
stitch = zeros(s(1)*4,s(2)*1.5,3,'uint8');
stitch(1:s(1),1:s(2),:)=im{1};
T0=eye(3);
for i=2:17;%length(data.images.beginI)
    [T,debug] = EstimateRigidTransform(rgb2gray(im{i-1}),rgb2gray(im{i}),GenerateParams_2());
    T0 = T*T0;
    stitch2 = zeros(s(1)*4,s(2)*1.5,3,'uint8');
    stitch2(1:s(1),1:s(2),:)=im{i};
    c=cv.warpAffine(stitch2,T0(1:2,:));
    mask = c(:,:,1)>0;
    mask = imerode(mask,strel('square',3));
    mask(:,:,2)=mask;
    mask(:,:,3)=mask(:,:,1);
    stitch(mask(:))=c(mask(:));
    %figure;
    imshow(stitch);
    %figure;
    %imshow([im{i-1},im{i},c,im{i-1}-im{i},im{i-1}-c]);
end