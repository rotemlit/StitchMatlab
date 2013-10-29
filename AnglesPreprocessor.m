% Preprocesses raw sensor angles for use in attitude indicator module.
classdef AnglesPreprocessor < handle
    properties
        mThetaFilter % low pass filter for theta of the type LowPassFilter
        mPhiFilter   % low pass filter for phi of the type LowPassFilter
        mOmegaFilter % low pass filter for omega of the type LowPassFilter
    end
    methods
        function this = AnglesPreprocessor(thetaLPF_Beta,phiLPF_Beta,omegaLPF_Beta)
            % thetaLPF_Beta, phiLPF_Beta, omegaLPF_Beta are decay constants
            % of low pass filters for the three angles.
            this.mThetaFilter = LowPassFilter(thetaLPF_Beta);
            this.mPhiFilter   = LowPassFilter(phiLPF_Beta);
            this.mOmegaFilter = LowPassFilter(omegaLPF_Beta);
        end
        
        function Reset(this) 
            % Resets the filter with the beta set it was constructed with
            this.mThetaFilter.Reset(this.mThetaFilter.beta);
            this.mPhiFilter.Reset(this.mPhiFilter.beta);
            this.mOmegaFilter.Reset(this.mOmegaFilter.beta);
        end
        
        function [anglesOut,omega0] = Process(this,dt,anglesIn)
            % Gets 3 input angles, and returns the curent filtering result.
            % input:
            %   dt - time delta between the previous sample and the
            %      current one (for the first sample, dt can be anything)
            %   anglesIn - an AngleSet struct with the 3 input angles [deg]
            % output:
            %   anglesOut - an AnglesSet struct with the output theta and
            %   phi. anglesOut.omega returns the input omega.
            %   omega0 - the filtered omega. This is the omega baseline
            %   estimation.
            % 
            % For the attitude indicator, use this three angles:
            % theta = anglesOut.theta,
            % phi = anglesOut.phi,
            % omega = (anglesOut.omega-omega0)
            
            theta = this.mThetaFilter.Process(dt,anglesIn.theta);
            phi   = this.mPhiFilter.Process(dt,anglesIn.phi);
            omega0 = this.mOmegaFilter.Process(dt,anglesIn.omega);
            anglesOut = AngleSet(theta,phi,anglesIn.omega);
        end
    end
end