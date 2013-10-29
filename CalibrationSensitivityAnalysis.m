s = [1280 720];
f0 = 1400;
K0 = [f0 0  s(2)/2;
     0  f0 s(1)/2;
     0  0  1];
 
P0 = FrameBorderPoints(s);

R = GenerateRotationMatFromThetaPhiOmega(0,0,30);
R0 = GenerateRotationMatFromThetaPhiOmega(0,0,0);

H0 = CameraRotationHomography(R0,R,K0);

f = 1390;
cx = s(2)/2-50;
cy = s(1)/2-50;
K1 = [f  0  cx;
      0  f  cy;
      0  0  1];

H1 = CameraRotationHomography(R,R0,K1);

P1 = UnHomog(H0 * AddRowOfOnes(P0));

P2 = UnHomog(H1 * AddRowOfOnes(P1));

figure
plot(P0(1,[1 2 3 4 1]),P0(2,[1 2 3 4 1]),'b')
hold on
plot(P2(1,[1 2 3 4 1]),P2(2,[1 2 3 4 1]),'r')
axis equal
grid on
legend('Ideal','Corrected');