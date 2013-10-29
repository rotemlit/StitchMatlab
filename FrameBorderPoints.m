function P = FrameBorderPoints(imgSize)
assert(size(imgSize,1)==1 && size(imgSize,2) >= 2);
P = [ -0.5,            -0.5,         ;
      imgSize(2)+0.5,  -0.5,         ;
      imgSize(2)+0.5,  imgSize(1)+0.5;
      -0.5,            imgSize(1)+0.5]';
