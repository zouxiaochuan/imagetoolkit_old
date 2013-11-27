classdef lmExtractorRaw < lmAExtractorFeature
    %LMEXTRACTORGABOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mSize;
    end
    
    methods
        function obj = lmExtractorRaw(size)
            name = 'Raw';
            description = 'Raw Pixel';
            
            obj = obj@lmAExtractorFeature(name,description);
            
            obj.mSize = size;
        end
        
        function [featureVec,obj] = extractFromMat(obj,img,varargin)
            if size(img,3) > 1
                img = rgb2gray(img);
            end
            
            img = imresize(img, obj.mSize);
            
            h = fspecial('gaussian',[10,10],1);
            img = imfilter(img,h);
            featureVec = double(img(:));
        end
        
        function nDim = featureDimension(obj,img)
            nDim = obj.mSize(1) * obj.mSize(2);
        end
    end
    
end

