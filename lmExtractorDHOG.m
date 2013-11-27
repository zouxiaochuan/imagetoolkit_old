classdef lmExtractorDHOG < lmAExtractorLocalDescriptor
    %LMEXTRACTORPHOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mSize;
        mStep;
        mMaxSize;
        mNumOritBin;
    end
    
    methods
        function obj = lmExtractorDHOG(size,step,maxsize,bins)
            % information of the method
            name = 'DHOG';
            description='Dense HOG';
            % construction from base class
            obj = obj@lmAExtractorLocalDescriptor(name,description);

            obj.mSize = size;
            obj.mStep = step;
            
            obj.mMaxSize = maxsize;
            
            obj.mNumOritBin = bins;
        end
        
        function [descriptors,locations,obj]=extractFromMat(obj,img,varargin)
            if size(img,3) > 1
                img = rgb2gray(img);
            end
            
            if (obj.mMaxSize > 0)
                maxs = max(size(img));
                if ( maxs > obj.mMaxSize)
                    img = imresize(img,obj.mMaxSize / maxs);
                end
            end
            
            numBin = obj.mNumOritBin;
            numSizeWind = obj.mSize;
            numStep = obj.mStep;
            
            img = im2double(img);
            
            img = imfilter(img,fspecial('gaussian',[3,3],0.8));
                        
            fX = [-1,0,1];
            fY = -fX';
            
            lenX = size(img,2);
            lenY = size(img,1);
            
            lenGradX = lenX - length(fX) + 1;
            lenGradY = lenY - length(fY) + 1;
            
            gradX = wkeep(imfilter(img,fX),[lenGradY,lenGradX]);
            gradY = wkeep(imfilter(img,fY),[lenGradY,lenGradX]);
            
            mag = (gradX.^2 + gradY.^2).^0.5;
            ang = atan2(gradY,gradX);
            
            binInd = mod(floor(numBin * ang / (2*pi)),numBin) + 1;
            
            coded = zeros(lenGradY,lenGradX,numBin);
            
            for y=1:lenGradY
                for x=1:lenGradX
                    coded(y,x,binInd(y,x)) = mag(y,x);
                end
            end
            
            numWindX = floor((lenGradX - numSizeWind)/numStep +1);
            numWindY = floor((lenGradY - numSizeWind)/numStep +1);
            
            lenDescriptors = numWindX * numWindY;
            
            descriptors = zeros(numBin,lenDescriptors);
            locations = zeros(2,lenDescriptors);
            
            ind = 0;
            for y=numSizeWind:numStep:lenGradY
                for x=numSizeWind:numStep:lenGradX
                    ind = ind + 1;
                    sub = coded(y-numSizeWind+1:y,x-numSizeWind+1:x,:);
                    descriptors(:,ind) = obj.extractFromSubWind(sub);
                    locations(1,ind) = x - numSizeWind/2;
                    locations(2,ind) = y - numSizeWind/2;
                end
            end
            descriptors = obj.normDescriptors(descriptors);
        end
        
        function [descriptors,obj] = normDescriptors(obj,descriptors)
            norms = repmat(sqrt(sum(descriptors.^2)),size(descriptors,1),1);
            norms(norms==0)=1;
            descriptors = descriptors ./ norms;
            descriptors(descriptors>0.2)=0.2;
            norms = repmat(sqrt(sum(descriptors.^2)),size(descriptors,1),1);
            norms(norms==0)=1;
            descriptors = descriptors ./ norms;
        end
        
        function [descriptor,obj] = extractFromSubWind(obj,sub)
            descriptor = sum(sum(sub,1),2);
            descriptor = descriptor(:);
        end
    end
    
end

