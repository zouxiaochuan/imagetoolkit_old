classdef lmExtractorBoF < lmAExtractorFeature
    %LMEXTRACTORBOF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mExtractorDescriptor;
        mEncoder
    end
    
    methods
        function obj = lmExtractorBoF( encoder, extractor)
            name = 'BoF';
            description = 'Bag of Features';
            
            obj = obj@lmAExtractorFeature(name,description);
            obj.mExtractorDescriptor = extractor;
            obj.mEncoder = encoder;
        end
        
        function [featureVec,obj] = extractFromMat(obj,img,varargin)
            if (size(img,3)>1)
                img = rgb2gray(img);
            end
            [descriptors,~] = obj.mExtractorDescriptor.extractFromMat(img);
            encoded = obj.mEncoder.encode(descriptors);
            featureVec = obj.mEncoder.pool(encoded);
        end
        
        function nDim = featureDimension(obj,~)
            nDim = obj.mEncoder.codeDimension();
        end
    end
    
end

