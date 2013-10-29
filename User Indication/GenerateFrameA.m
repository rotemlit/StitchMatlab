function res = GenerateFrameA(aspectRatio, outerBoundaryMargin)
margin = outerBoundaryMargin/2;
if (aspectRatio < 1)
    margin = margin *aspectRatio;
end
res = [ margin, margin;
        1-margin, margin;
        1-margin, aspectRatio-margin;
        margin, aspectRatio-margin]';