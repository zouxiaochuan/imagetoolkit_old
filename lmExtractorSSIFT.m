classdef lmExtractorSSIFT < lmAExtractorFeature
    %LMEXTRACTORPHOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mMaxSize;
    end
    
    methods
        function obj = lmExtractorSSIFT(maxsize)
            % information of the method
            name = 'SSIFT';
            description='Single SIFT';
            % construction from base class
            obj = obj@lmAExtractorFeature(name,description);
            
            if nargin==1 && ~isempty(maxsize)
                obj.mMaxSize = maxsize;
            else
                obj.mMaxSize = 0;
            end
        end
        
        function [feaVec,obj]=extractFromMat(obj,img,varargin)
            if size(img,3) > 1
                img = rgb2gray(img);
            end
            
            img = imresize(img,[obj.mMaxSize,obj.mMaxSize]);
            
            [locations,descriptors] = vl_dsift(im2single(img),'size',obj.mMaxSize/3,'step',10,...
                'floatdescriptors');
            descriptors = obj.normDescriptor(descriptors);
            locations = locations(1:2,:);
            
            feaVec = descriptors(:);
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

