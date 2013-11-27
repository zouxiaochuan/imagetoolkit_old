classdef lmExtractorGabor < lmAExtractorFeature
    %LMEXTRACTORGABOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = lmExtractorGabor()
            name = 'Gabor';
            description = 'Gabor Texture';
            
            obj = obj@lmAExtractorFeature(name,description);
        end
        
        function [featureVec,obj] = extractFromMat(obj,img,varargin)
            if size(img,3)>1
                img = rgb2gray(img);
            end
            featureVec = featureGabor(img);
        end
        
        function nDim = featureDimension(obj,img)
            nDim = 48;
        end
    end
    
end

