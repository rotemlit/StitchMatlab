angleTestSets = [   0 0 0;
                    5 0 0;
                    0 5 0;
                    0 0 5;
                    -10 0 0;
                    0 -10 0;
                    0 0 -10;
                    10 3 7;
                    5 2 18;
                    6 8 28];
                
close all

aspectRatio = 3/2;
isLandscape = false;
outerBoundaryMargin = 0.05;
innerBoundaryMargin = 0.05;
minTheta = 2;
minPhi = 2;
minOmega = 2;
thetaScale = 1;
phiScale = 1;
omegaScale = 1;


pScreen = [0 0;
       1 0;
       1 aspectRatio;
       0 aspectRatio;
       0 0 ]';

for i=1:size(angleTestSets,1)
    subplot(2,5,i);
    P = GenerateUserIndicationFramePoints(angleTestSets(i,1),angleTestSets(i,2),angleTestSets(i,3),minTheta, minPhi, minOmega,thetaScale,phiScale,omegaScale,aspectRatio,outerBoundaryMargin,innerBoundaryMargin,isLandscape);
    plot(pScreen(1,:),pScreen(2,:),'b');
    hold on
    pFrame1 = GenerateFrameA(aspectRatio,outerBoundaryMargin);
    plot(pFrame1(1,[1 2 3 4 1]),pFrame1(2,[1 2 3 4 1]),'g');
    plot([P(1,:),P(1,1)],[P(2,:),P(2,1)],'ro');
    plot([P(1,:),P(1,1)],[P(2,:),P(2,1)],'r');
    set(gca,'YDir','Reverse')
    title(['\theta=',num2str(angleTestSets(i,1)),', \phi=',num2str(angleTestSets(i,2)),', \omega=',num2str(angleTestSets(i,3))]);
    axis equal
    grid on
end
