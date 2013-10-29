function im1 = RunBOverAWithMask(im1,im2,blendZone)
mask = im2(:,:,1) > 0;
mask([1 end],:)=0;
mask(:,[1 end])=0;
mask = imerode(mask,strel('square',5));
mask = uint8(bwdist(~mask))*(uint8(255)/blendZone);

floatMask = single(mask)/255;
for i=1:3
    im1(:,:,i) = uint8(single(im1(:,:,i)).*(1-floatMask) + single(im2(:,:,i)).*floatMask);
end
