classdef lmExtractorHOGVL < lmAExtractorFeature
    %LMEXTRACTORHOG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mNumBin;
        mNumWinX;
        mNumWinY;
        mMaxSize;
    end
    
    methods
        function obj = lmExtractorHOGVL( bins, xwin,ywin, maxsize)
            name = 'HOG';
            description = 'Histogram of Oriented Gradients using vl library';
            
            obj = obj@lmAExtractorFeature(name,description);
            obj.mNumBin = bins;
            obj.mNumWinX = xwin;
            obj.mNumWinY = ywin;
            
            if exist('maxsize','var') && ~isempty(maxsize)
                obj.mMaxSize = maxsize;
            else
                obj.mMaxSize = 0;
            end
        end
        
        function [featureVec,obj] = extractFromMat(obj,img,varargin)
            
            numWinX = obj.mNumWinX;
            numWinY = obj.mNumWinY;
            numBin = obj.mNumBin;
            
            maxs = max(size(img));
            if obj.mMaxSize > 0 && maxs > obj.mMaxSize
                img = imresize(img, obj.mMaxSize / maxs);
            end
            
            rows = size(img,1);
            cols = size(img,2);
            
            cellSizeX = cols / numWinX;
            cellSizeY = rows / numWinY;
            
            if cellSizeX ~= cellSizeY
                throw(MException('','vlfeat only support square cell'));
            end
            
            cellSize = cellSizeX;
            
            hd = vl_hog(im2single(img),cellSize,'NumOrientations',numBin,'Variant','dalaltriggs');
            flen = size(hd,3);
            fflen = flen * size(hd,1) * size(hd,2);
            
            featureVec = zeros(fflen,1);
            
            di = 1;
            for hy=1:size(hd,1)
                for hx=1:size(hd,2)
                    featureVec(di:di+flen-1) = hd(hy,hx,:);
                    di = di + flen;
                end
            end
        end
        function nDim = featureDimension(obj, img)
            nDim = obj.mNumWinX*obj.mNumWinY*(4*obj.mNumBin);
        end
    end
end
        
        
