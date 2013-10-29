classdef LowPassFilter < handle
    % Defines a low pass filter of the type y(i) = alpha*y(i-1)+(1-alpha)*x(i)
    % Where: alpha = exp(-beta*dt), beta is a constant and dt the time gap
    % between the last sample and the current one. for the first sample, dt
    % is not used and can be anything.
    properties
        beta %double
        lastRes %double
        started %boolean
    end
    
    methods
        function newFilter = LowPassFilter(beta)
            if (nargin==0)
                Reset(newFilter);
            else
                Reset(newFilter,beta);
            end
        end
        
        function Reset(this,beta)
            if (nargin > 1)
                this.beta = beta;
            else
                this.beta = 0;
            end
            this.lastRes = 0;
            this.started=false;
        end
        
        function newRes = Process(this,dt,newVal) 
            if (~this.started)
                newRes = newVal;
                this.started = true;
            else
                alpha = exp(-this.beta * dt);
                delta = mod(this.lastRes-newVal,360);
                if (delta > 180)
                    delta = delta - 360;
                end
                newRes = newVal + alpha * delta;
            end
            this.lastRes = newRes;
        end
    end
end
