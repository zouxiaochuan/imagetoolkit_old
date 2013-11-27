classdef lmExtractorHOGSPM < lmAExtractorFeature
    %LMEXTRACTORHOG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mNumBins;
        mNumWinXs;
        mNumWinYs;
        mMaxSize;
        
        mExtractors;
        mNumDimension;
    end
    
    methods
        function obj = lmExtractorHOGSPM( bins, xwin,ywin, maxsize)
            name = 'HOG';
            description = 'Histogram of Oriented Gradients using Spatial Pyramid Matching';
            
            obj = obj@lmAExtractorFeature(name,description);
            obj.mNumBins = bins;
            obj.mNumWinXs = xwin;
            obj.mNumWinYs = ywin;
            
            if exist('maxsize','var') && ~isempty(maxsize)
                obj.mMaxSize = maxsize;
            else
                obj.mMaxSize = 0;
            end
            
            obj.mNumDimension = 0;
            for i=1:length(bins)
                ext = lmExtractorHOGVL(bins(i),xwin(i),ywin(i),obj.mMaxSize);
                obj.mExtractors{i} = ext;
                obj.mNumDimension = obj.mNumDimension + ext.featureDimension();
            end
        end
        
        function [featureVec,obj] = extractFromMat(obj,img,varargin)
            featureVec = zeros(obj.mNumDimension,1);
            
            fi = 1;
            for i=1:length(obj.mExtractors)
                ext = obj.mExtractors{i};
                fvec = ext.extractFromMat(img);
                featureVec(fi:fi+length(fvec)-1) = fvec;
                fi = fi + length(fvec);
            end
        end
        function nDim = featureDimension(obj, img)
            nDim = obj.mNumDimension;
        end
    end
end
        
        
