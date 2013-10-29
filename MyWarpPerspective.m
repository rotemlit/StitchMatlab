function R = MyWarpPerspective(Image,F,ShiftX,ShiftY,method)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function R = MyWarpPerspective(Image,F,method)
% Warps image using perspective coefficients
% 
% Image = Image to warp
% F = perspective matrix 3x3
% ShiftX, ShiftY = shift between the image used for calculating F and image
%                  used for warping ("Image" input)
% method = interpolation method: 'Nearest' / 'Linear' / 'Cubic' / 'Lanczos4'
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Sy,Sx] = size(Image);
[X,Y] = meshgrid(ShiftX:Sx-1+ShiftX,ShiftY:Sy-1+ShiftY);

IX0 = X.*F(1,1)+Y.*F(1,2)+F(1,3);
IY0 = X.*F(2,1)+Y.*F(2,2)+F(2,3);
T = X.*F(3,1)+Y.*F(3,2)+F(3,3);
IX = IX0 ./ T;
IY = IY0 ./ T;

R = cv.remap(Image,IX-ShiftX,IY-ShiftY,'Interpolation',method);

% R = interp2(X,Y,Image,IX,IY,method);
