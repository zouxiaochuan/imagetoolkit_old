classdef lmExtractorHSVHist < lmAExtractorFeature
    %LMEXTRACTORHSVHIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mNumBins;
    end
    
    methods
        function obj = lmExtractorHSVHist( bins)
            name = 'HSV Histogram';
            description = 'HSV Color Histogram';
            
            obj = obj@lmAExtractorFeature(name,description);
            obj.mNumBins = bins;
        end
        
        function [featureVec,obj] = extractFromMat(obj,img,varargin)
            if size(img,3)==1
                img = repmat(img,[1,1,3]);
            end
            featureVec = obj.colorfeature_HSV(rgb2hsv(img),obj.mNumBins);
        end
        
        function nDim = featureDimension(obj,img)
            nDim = 3*obj.mNumBins;
        end        
        
        function CF_HSV=colorfeature_HSV(obj,img,num_bin)
            [counts1] = imhist(img(:,:,1),num_bin);
            [counts2] = imhist(img(:,:,2),num_bin);
            [counts3] = imhist(img(:,:,3),num_bin);
            totalpix=sum(counts1);
            CF_HSV=[counts1/totalpix ;counts2/totalpix;counts3/totalpix];
        end
    end
    
end

