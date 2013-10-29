function [stripsValid,strip1,strip2] = ExtractGrayscaleStrips(im1,im2,dim,startLocation,width,offset)
%extract two grayscale strips along the dimenstion dim, starting and
%startLocation, with width 'width', assuming there's an offset 'offset'
%between im1 and im2 along dimension 'dim'.

assert(sum(size(im1)~=size(im2))==0,'im1 and im2 must be the same size');
assert(dim==1 || dim==2,'dim must be 1 or 2');

stripsValid = false;
strip1 = [];
strip2 = [];

imSize = size(im1);

r1 = [startLocation,startLocation+width];
r2 = r1+offset;
low = min(r1(1),r2(1));
if (low < 0)
    r1(1) = r1(1) - low;
    r2(1) = r2(1) - low;
end
high = max(r1(2),r2(2));
if (high > imSize(dim))
    r1(2) = r1(2) + imSize(dim)-high;
    r2(2) = r2(2) + imSize(dim)-high;
end
if (diff(r1) < width*2/3)
    return
end

if (dim==1)
    verticalRedProfile = sum(im1(r1(1):r1(2),:,1)>0,dim);
else
    verticalRedProfile = sum(im1(:,r1(1):r1(2),1)>0,dim);
end
fullRange = find(verticalRedProfile == diff(r1)+1);
if (isempty(fullRange))
    return;
end
x1 = [fullRange(1),fullRange(end)];

if (dim==1)
    verticalRedProfile = sum(im2(r1(1):r1(2),:,1)>0,dim);
else
    verticalRedProfile = sum(im2(:,r1(1):r1(2),1)>0,dim);
end
fullRange = find(verticalRedProfile == diff(r2)+1);
if (isempty(fullRange))
    return;
end
x2 = [fullRange(1)+2,fullRange(end)-2];
xRange = [max(x1(1),x2(1)),min(x1(2),x2(2))];
if (diff(xRange) < imSize(3-dim)* 2/3)
    return;
end 

stripsValid = true;
if (dim==1)
    strip1 = rgb2gray(im1(r1(1):r1(2),xRange(1):xRange(2),:));
    strip2 = rgb2gray(im2(r2(1):r2(2),xRange(1):xRange(2),:));
else
    strip1 = rgb2gray(im1(xRange(1):xRange(2),r1(1):r1(2),:))';
    strip2 = rgb2gray(im2(xRange(1):xRange(2),r2(1):r2(2),:))';
end    
    


