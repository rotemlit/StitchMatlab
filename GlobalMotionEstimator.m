classdef GlobalMotionEstimator
    methods (Static)
        
        function [success,dstOffset] = EstimateInitialHomography2D(im1Gray,im2Gray,initialOffset,maxXOffset,maxYOffset)
            global sParams;
            maxXSize = 200;
            maxYSize = 200;

            assert(size(im1Gray,3)==1 && size(im2Gray,3)==1,'Images must be 1 channel deep');
            success = false;
            dstOffset = [];
            
            xMargin = max(maxXOffset,(size(im1Gray,2)-maxXSize)/2);
            yMargin = max(maxYOffset,(size(im1Gray,1)-maxYSize)/2);
            template = im1Gray(yMargin+1:end-yMargin,xMargin+1:end-xMargin);
            CC = normxcorr2(template,im2Gray);
            [maxCC, imax] = max(CC(:));
            disp(num2str(maxCC,'maxCC = %f'));
            if (maxCC > sParams.minCorr2DThreshold)
                [yPeak, xPeak] = ind2sub(size(CC),imax(1));
                dstOffset = [(xPeak-size(template,2))-xMargin;(yPeak-size(template,1))-yMargin];
                success = true;
            end
        end
        
        function [success,dstOffset] = EstimateInitialHomography1D(im1,im2,initialOffset)
            
            success = false;
            dstOffset = 0;
            
            global sParams;
            maxDiffForConcensus = sParams.maxDiffForConcensus;
            
            yRanges = [0.45 0.2 0.7]*size(im1,1);
            height = 0.1*size(im1,1);
            
            guessResults = [];
            for i=1:length(yRanges)
                [validStrip,s1,s2] = ExtractGrayscaleStrips(im1,im2,1,yRanges(i),height,initialOffset(2));
                if (validStrip)
                    [validOffset,foundOffset] = FindOffsetByCrossCovariance(sum(s1,1),sum(s2,1));
                    if (validOffset)
                        guessResults = [guessResults,foundOffset];
                    end
                end
                if (length(guessResults)==2)
                    if (abs(guessResults(2)-guessResults(1)) < maxDiffForConcensus)
                        break;
                    end
                end
            end
            if (length(guessResults)==2)
                success = true;
                dstOffset = mean(guessResults);
            elseif (length(guessResults)==3)
                [m,I] = min([abs(guessResults(2)-guessResults(1)), abs(guessResults(3)-guessResults(1)), abs(guessResults(2)-guessResults(3))]);
                if (m > maxDiffForConcensus)
                    return;
                end
                success = true;
                if (I==1)
                    dstOffset = mean(guessResults([1,2]));
                elseif (I==2)
                    dstOffset = mean(guessResults([1,3]));
                else
                    dstOffset = mean(guessResults([2,3]));
                end
            end
            
        end
        
        function [validOffset,foundOffset] = FindOffsetByCrossCovariance(f1,f2)
            corrLimit = 200;
            foundOffset = NaN;
            assert(length(f1)==length(f2),'f1 and f2 must be the same size');
            c = xcov(f1,f2,corrLimit);
            [M,I] = max(c);
            peak = I-corrLimit;
            if (I>=0)
                r = corrcoef(f1(peak:end),f2(1:end-peak+1));
            else
                r = corrcoef(f2(peak:end),f1(1:end-peak+1));
            end
            r = r(1,2);
            validOffset = (r>0.9);
            if (validOffset)
                foundOffset = peak;
            end
        end
        
    end
end