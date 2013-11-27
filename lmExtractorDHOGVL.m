classdef lmExtractorDHOGVL < lmAExtractorLocalDescriptor
    %LMEXTRACTORHOG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mCellSize;
        mNumBin;
        mWinSize;
        mMaxSize;
    end
    
    methods
        function obj = lmExtractorDHOGVL(windowSize,cellSize,bins,maxsize)
            name = 'HOG';
            description = 'Histogram of Oriented Gradients using vl library';
            
            obj = obj@lmAExtractorLocalDescriptor(name,description);
            obj.mNumBin = bins;
            obj.mCellSize = cellSize;
            obj.mWinSize = windowSize;
            
            if exist('maxsize','var') && ~isempty(maxsize)
                obj.mMaxSize = maxsize;
            else
                obj.mMaxSize = 0;
            end
        end
        
        function [descriptors,locations,obj] = extractFromMat(obj,img,varargin)
            
            maxs = max(size(img));
            if obj.mMaxSize > 0 && maxs > obj.mMaxSize
                img = imresize(img, obj.mMaxSize / maxs);
            end
            
            hd = vl_hog(im2single(img),obj.mCellSize,'NumOrientations',obj.mNumBin);
            flen = size(hd,3);
            fflen = flen * obj.mWinSize * obj.mWinSize;
            
            descriptors = zeros(fflen,size(hd,1)*size(hd,2));
            locations = zeros(2,size(hd,1)*size(hd,2));
            
            cellLen = floor(obj.mCellSize/2);
            winLen = floor(obj.mWinSize/2);
            cellSize = obj.mCellSize;
            
            di = 1;
            for hy=1:size(hd,1)
                for hx=1:size(hd,2)
                    fvec = zeros(fflen,1);
                    fi = 1;
                    for yy=hy-winLen:hy+winLen
                        for xx=hx-winLen:hx+winLen
                            
                            if (xx < 1) || (xx>size(hd,2)) || (yy<1) || (yy>size(hd,1))
                                tmp = 0 * ones(flen,1);
                            else
                                tmp = hd(yy,xx,:);
                            end
                            %tmp = hd(iy,ix,:);
                            fvec(fi:fi+flen-1) = tmp(:);
                            fi = fi + flen;
                        end
                    end
                    py=min(size(img,1),(hy-1)*cellSize + 1 + cellLen);
                    px=min(size(img,2),(hx-1)*cellSize + 1 + cellLen);
                    descriptors(:,di) = fvec;
                    locations(:,di) = [px;py];
                    di = di + 1;
                end
            end
        end
    end
end
        
        
