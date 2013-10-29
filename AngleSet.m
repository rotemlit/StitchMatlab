classdef AngleSet < handle
    properties
        theta
        phi
        omega
    end
    methods
        function angleSet = AngleSet(theta,phi,omega)
            angleSet.theta = theta;
            angleSet.phi = phi;
            angleSet.omega = omega;
        end
    end
end