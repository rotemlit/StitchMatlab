function [imWarped,offsetDone,borderPoints] = CorrectImageToFrontoParallel(im,angleSet,omega0)
    Rsrc = GenerateRotationMatFromThetaPhiOmega(angleSet.theta,-angleSet.phi,-angleSet.omega);
    Rdst = GenerateRotationMatFromThetaPhiOmega(0,0,-omega0);
    global sParams;
    H = CameraRotationHomography(Rsrc,Rdst,sParams.K);
    
    borderPoints = H * AddRowOfOnes(FrameBorderPoints(size(im)));
    borderPoints = UnHomog(borderPoints);
    center = (max(borderPoints,[],2)+min(borderPoints,[],2))/2;
    offsetDone  = round([size(im,2)/2-center(1);
        size(im,1)/2-center(2)]);
    hCenterize = [1 0 offsetDone(1);
                  0 1 offsetDone(2);
                  0 0 1];
    hCentered = hCenterize*H;
    
    imWarped = cv.warpPerspective(im,hCentered,'WarpInverse',false,'Interpolation','Linear');

    