function stitch = AddImageToStitch(stitch,im,hCurr2Stitch,onlyCenterStrip)
global sParams;

im2Stitch = im;
if (onlyCenterStrip)
    im2Stitch(:,1:end*(0.5-sParams.centralStripeRatio/2),:) = 0;
end

borderPoints = hCurr2Stitch * AddRowOfOnes(FrameBorderPoints(size(im2Stitch)));
borderPoints = UnHomog(borderPoints);
center = (max(borderPoints,[],2)+min(borderPoints,[],2))/2;
offsetDone = round([size(im2Stitch,2)/2-center(1);size(im2Stitch,1)/2-center(2)]);
hCenterize = [1 0 offsetDone(1);
              0 1 offsetDone(2);
              0 0 1];
hCentered = hCenterize*hCurr2Stitch;
warped = cv.warpPerspective(im2Stitch,hCentered,'WarpInverse',false,'Interpolation','Linear');
margins1 = [1 size(im2Stitch,2) ; 1 size(im2Stitch,1)]; % x0 x1 ; y0 y1
margins2 = margins1 - offsetDone*[1 1];
correct = zeros(2,2);
if (margins2(1,1) < 1)
    correct(1,1) = -margins2(1,1)+1;
end
if (margins2(2,1) < 1)
    correct(2,1) = -margins2(2,1)+1;
end
if (margins2(1,2) > size(stitch,2))
    correct(1,2) = size(stitch,2) - margins2(1,2);
end
if (margins2(2,2) > size(stitch,1))
    correct(2,2) = size(stitch,1) - margins2(2,2);
end
margins1 = int32(margins1 + correct);
margins2 = int32(margins2 + correct);
if (min(diff(margins1,1,2)) > 1 && min(diff(margins2,1,2)) > 1)
    stitch(margins2(2,1):margins2(2,2),margins2(1,1):margins2(1,2),:) = ...
        RunBOverAWithMask(stitch(margins2(2,1):margins2(2,2),margins2(1,1):margins2(1,2),:), ...
        warped(margins1(2,1):margins1(2,2),margins1(1,1):margins1(1,2),:),sParams.blendZone);
end
