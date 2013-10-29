function hIm1Im2 = MatchPrev2Curr(im1,offsetDone1,im2,offsetDone2)

params = GenerateParams_2();

initialOffset = offsetDone2-offsetDone1;

success = false;
%[success,newXOffset] = EstimateInitialHomography(im1,im2,initialOffset);
if (success)
    initialOffset(1) = newXOffset;
else
    params.LK_PyramidDepth = 5;
end

initialOffsetHomog = TranslationHomography(initialOffset);

[hIm1Im2,debug] = EstimateTransScaleTransform(rgb2gray(im1),rgb2gray(im2),params,initialOffsetHomog);
hIm1Im2 = inv(hIm1Im2); % TEMP