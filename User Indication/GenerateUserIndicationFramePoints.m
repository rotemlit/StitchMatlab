function res = GenerateUserIndicationFramePoints(theta, phi, omega, minTheta, minPhi, minOmega, thetaScale, phiScale, omegaScale, aspectRatio, outerMargin, innerMargin, isLandscape)
% The function generates the 4 user indicator points.
% Input:
%   theta - tilt angle (float)
%   phi - roll angle (float)
%   omega - pan angle (float)
%   minTheta, minPhi, minOmeta - minimal angle to start moving the indicator (float, deg)
%   thetaScale, phiScale, omegaScale - scale factor on the angles when needed (float, deg)
%   aspectRatio - screen dimensions ratio - height/width
%  outerMargin, innerMargin, isLandscape
% Output:
%   res - 2x4 array of 2d user indication points, ordered. The span of the
%   points is int the range [0,1] in x and [0,aspectRatio] in y.



doRescale = true;

if (isLandscape)
    s = sign(phi);
    if (s==0)
        s=1;
    end
    phi = s*(90-abs(phi));
end

theta = sign(theta)*max(0,(abs(theta)-minTheta)/thetaScale);
phi = sign(phi)*max(0,(abs(phi)-minPhi)/phiScale);
omega = sign(omega)*max(0,(abs(omega)-minOmega)/omegaScale);

depth = 1;
pIn = [-0.5 -aspectRatio/2 -depth;
        0.5 -aspectRatio/2 -depth;
        0.5  aspectRatio/2 -depth;
       -0.5  aspectRatio/2 -depth]';
R = rotationAroundZ(phi*pi/180) * rotationAroundX(theta*pi/180) * rotationAroundY(omega*pi/180);

if (aspectRatio < 1)
    outerMargin = outerMargin * aspectRatio;
    innerMargin = innerMargin * aspectRatio;
end

marginScale = 1-(outerMargin+innerMargin);

pOut = R * pIn;
closest = max(pOut(3,:)); % protect from points going behind the "camera" - limit the perspective
if (closest > -0.2)
    pOut(3,:) = pOut(3,:) -0.2 - closest;
end
res = zeros(2,4);
for i=1:4
    res(1,i) = pOut(1,i) * depth * marginScale / pOut(3,i);
    yMarginScale = 1-(1-marginScale)/aspectRatio;
    res(2,i) = pOut(2,i) * depth * yMarginScale / pOut(3,i);
end
frameAScales = [1-outerMargin;aspectRatio-outerMargin];
if (doRescale)
    size = max(res,[],2)-min(res,[],2);
    scale = max(size./frameAScales);
    if (scale > 1)
        res = res / scale;
    end
end
newCenter = (max(res,[],2)+min(res,[],2))/2;
for i=1:4
    res(:,i) = res(:,i) - newCenter - pIn(1:2,1);% + [1-frameARatio;1-frameARatio]/2;
end
