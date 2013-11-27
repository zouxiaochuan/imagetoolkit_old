classdef lmExtractorDSIFT < lmAExtractorLocalDescriptor
    %LMEXTRACTORPHOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mSize;
        mStep;
        mMaxSize;
        mColor;
    end
    
    methods
        function obj = lmExtractorDSIFT(size,step,maxsize,color)
            % information of the method
            name = 'DSIFT';
            description='Dense SIFT';
            % construction from base class
            obj = obj@lmAExtractorLocalDescriptor(name,description);

            obj.mSize = size;
            obj.mStep = step;
            
            if nargin>=3 && ~isempty(maxsize)
                obj.mMaxSize = maxsize;
            else
                obj.mMaxSize = 0;
            end
            
            if nargin<4
                obj.mColor = 'gray';
            else
                obj.mColor = color;
            end
        end
        
        function [descriptors,locations,obj]=extractFromMat(obj,img,varargin)
            
            if (obj.mMaxSize > 0)
                maxs = max(size(img));
                if ( maxs > obj.mMaxSize)
                    img = imresize(img,obj.mMaxSize / maxs);
                end
            end
            
            [locations,descriptors] = vl_phow(im2single(img),'sizes',obj.mSize/4,'step',obj.mStep,...
                'floatdescriptors',true,'color',obj.mColor);
            descriptors = obj.normDescriptor(descriptors);
            %locations = locations(1:2,:);
        end
        
        function [descriptors,obj] = normDescriptor(obj,descriptors)
            norms = repmat(sqrt(sum(descriptors.^2)),size(descriptors,1),1);
            norms(norms==0)=1;
            descriptors = descriptors ./ norms;
%             descriptors(descriptors>0.2)=0.2;
%             norms = repmat(sqrt(sum(descriptors.^2)),size(descriptors,1),1);
%             norms(norms==0)=1;
%             descriptors = descriptors ./ norms;
        end
        
        function [numDim] = featureDimension(obj,im)
            numDim = 128;
        end
    end
    
end

