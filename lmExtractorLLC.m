classdef lmExtractorLLC < lmAExtractorFeature
    %LMEXTRACTORLLC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mCodebook;
        mExtractorDescriptor;
    end
    
    methods
        function obj = lmExtractorLLC( codebook, extractor)
            codebook = double(codebook);
            name = 'LLC';
            description = 'Locality-constrained Linear Coding';
            
            obj = obj@lmAExtractorFeature(name,description);
            obj.mCodebook = codebook;
            obj.mExtractorDescriptor = extractor;
        end
        
        function [featureVec,obj] = extractFromMat(obj,img,varargin)
            if (size(img,3)>1)
                img = rgb2gray(img);
            end
            [descriptors,locations] = obj.mExtractorDescriptor.extractFromMat(img);
            featureVec = single(obj.LLC(descriptors,locations,size(img,1),size(img,2)));
        end
        
        function nDim = featureDimension(obj,img)
            nDim = size(obj.mCodebook,2)*21;
        end
        
        function [ fea ] = LLC( obj, descriptors,locations,height,width )
            pyramid=[1,2,4];
            knn=5;
            feaSet.feaArr = descriptors;
            feaSet.width = width;
            feaSet.height = height;
            feaSet.x = locations(1,:)';
            feaSet.y = locations(2,:)';
            fea = LLC_pooling(feaSet, obj.mCodebook, pyramid, knn);
        end
        
    end
    
end

