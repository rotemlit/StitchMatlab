function TestRollLog(data,a,b)
% for each pair of image indices, opens a gui. you mark two points on a
% line in each of the three images, and the function displays the angle
% difference in the images vs the roll angle difference.
    figure;
    ia = data.images.beginI(a);
    ib = data.images.beginI(b);
    aRoll = data.roll(ia);
    aTilt = -data.tilt(ia);
    aPan = data.pan(ia);
    bRoll = data.roll(ib);
    bTilt = -data.tilt(ib);
    bPan = data.pan(ib);
    Ra = RotationAroundZ(aRoll*pi/180)*RotationAroundX(aTilt*pi/180)*RotationAroundY(aPan*pi/180)*RotationAroundX(-pi/2);
    Rb = RotationAroundZ(bRoll*pi/180)*RotationAroundX(bTilt*pi/180)*RotationAroundY(bPan*pi/180)*RotationAroundX(-pi/2);
    Ra1 = data.R(ia);
    Rb2 = data.R(ib);
    imshow([data.im{a},data.im{b},CameraRotationWarp(data.im{b},Ra,Rb,1760)])
    
    imwrite([data.im{a},CameraRotationWarp(data.im{b},Ra,Rb,1760)],'test.png')
    
%     trueAngles = [data.roll(data.images.beginI(b)),data.roll(data.images.beginI(a))]
%     [x,y] = ginput(2);
%     angleIm1 = atan2(diff(y),diff(x))*180/pi
%     hold on
%     plot(x,y);
%     [x,y] = ginput(2);
%     angleIm2 = atan2(diff(y),diff(x))*180/pi
%     hold on
%     plot(x,y);
%     [x,y] = ginput(2);
%     angleIm1Warped = atan2(diff(y),diff(x))*180/pi
%     hold on
%     plot(x,y);
%     disp(['Log diff = ',num2str(diff(trueAngles)),', Image Diff = ',num2str(angleIm2-angleIm1)]);
    