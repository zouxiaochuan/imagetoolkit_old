classdef lmExtractorDRaw < lmAExtractorLocalDescriptor
    %LMEXTRACTORPHOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mSize;
        mStep;
        mMaxSize;
    end
    
    methods
        function obj = lmExtractorDRaw(size,step,maxsize)
            % information of the method
            name = 'DRaw';
            description='Dense Raw';
            % construction from base class
            obj = obj@lmAExtractorLocalDescriptor(name,description);

            obj.mSize = size;
            obj.mStep = step;
            
            if nargin==3 && ~isempty(maxsize)
                obj.mMaxSize = maxsize;
            else
                obj.mMaxSize = 0;
            end
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
            
            numSizeWind = obj.mSize;
            numStep = obj.mStep;
            
            %img = im2double(img);
            img = double(img);
            img = img/255;
            
            img = imfilter(img,fspecial('gaussian',[10,10],1.0));
            
            lenX = size(img,2);
            lenY = size(img,1);
                        
            numWindX = floor((lenX - numSizeWind)/numStep +1);
            numWindY = floor((lenY - numSizeWind)/numStep +1);
            
            lenDescriptors = numWindX * numWindY;
            
            descriptors = zeros(numSizeWind^2,lenDescriptors);
            locations = zeros(2,lenDescriptors);
            
            ind = 0;
            for y=numSizeWind:numStep:lenY
                for x=numSizeWind:numStep:lenX
                    ind = ind + 1;
                    sub = img(y-numSizeWind+1:y,x-numSizeWind+1:x);
                    descriptors(:,ind) = obj.extractFromSubWind(sub);
                    locations(1,ind) = x - numSizeWind/2;
                    locations(2,ind) = y - numSizeWind/2;
                end
            end
            %descriptors = obj.normDescriptors(descriptors);
            descriptors = single(descriptors);
        end
        
        function [descriptors,obj] = normDescriptors(obj,descriptors)
            norms = repmat(sqrt(sum(descriptors.^2)),size(descriptors,1),1);
            norms(norms==0)=1;
            descriptors = descriptors ./ norms;
%             descriptors(descriptors>0.2)=0.2;
%             norms = repmat(sqrt(sum(descriptors.^2)),size(descriptors,1),1);
%             norms(norms==0)=1;
%             descriptors = descriptors ./ norms;
        end
        
        function [descriptor,obj] = extractFromSubWind(obj,sub)
            descriptor = sub(:);
        end
        
        function [numDim] = featureDimension(obj,im)
            numDim = obj.mSize^2;
        end
    end
    
end

