function hIm1Im2 = MatchPrev2Curr(im1,offsetDone1,im2,offsetDone2)

im1Gray = rgb2gray(im1);
im2Gray = rgb2gray(im2);

params = GenerateParams_2();

initialOffset = offsetDone2-offsetDone1;

%success = false;
[success,newXOffset] = GlobalMotionEstimator.EstimateInitialHomography2D(im1Gray,im2Gray,initialOffset,200,100);
if (success)
    initialOffset = newXOffset;
else
    params.LK_PyramidDepth = 5;
end

initialOffsetHomog = TranslationHomography(initialOffset);

[hIm1Im2,debug] = EstimateTransScaleTransform(im1Gray,im2Gray,params,initialOffsetHomog); %
if (~isempty(hIm1Im2))
    hIm1Im2 = inv(hIm1Im2);
end

if (success && ~isempty(hIm1Im2)) 
    p0 = fliplr(size(im1Gray))'/2;
    p1 = hIm1Im2(1:2,1:2)*p0 + hIm1Im2(1:2,3);
    offset = p1-p0;
    delta = max(abs(offset-initialOffset)); 
    disp(num2str(delta,'delta = %f'));
end
