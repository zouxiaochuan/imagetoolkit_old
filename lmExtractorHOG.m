classdef lmExtractorHOG < lmAExtractorFeature
    %LMEXTRACTORHOG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mNumBins;
        mNumWinX;
        mNumWinY;
        mMaxSize;
    end
    
    methods
        function obj = lmExtractorHOG( bins, xwin,ywin, maxsize)
            name = 'HOG';
            description = 'Histogram of Oriented Gradients';
            
            obj = obj@lmAExtractorFeature(name,description);
            obj.mNumBins = bins;
            obj.mNumWinX = xwin;
            obj.mNumWinY = ywin;
            
            if nargin==4 && ~isempty(maxsize)
                obj.mMaxSize = maxsize;
            else
                obj.mMaxSize = 0;
            end
        end
        
        function nDim = featureDimension(obj, img)
            nDim = obj.mNumWinX*obj.mNumWinY*obj.mNumBins;
        end
        function [featureVec,obj] = extractFromMat(obj,img,varargin)
            if size(img,3) > 1
                img = rgb2gray(img);
            end
            
            maxs = max(size(img));
            if obj.mMaxSize > 0 && maxs > obj.mMaxSize
                img = imresize(img, obj.mMaxSize / maxs);
            end
            
            featureVec = obj.HOG(img);
        end
        
        function H=HOG(obj, Im)
            B = obj.mNumBins;
            nwin_x = obj.mNumWinX;
            nwin_y = obj.mNumWinY;
            
            [L,C]=size(Im); % L num of lines ; C num of columns
            %%%
            %             L=L-2;
            %             C=C-2;
            %%%
            H=zeros(nwin_x*nwin_y*B,1); % column vector with zeros
            
            Im=double(Im);
            step_x=floor(C/(nwin_x+1));
            step_y=floor(L/(nwin_y+1));
            cont=0;
            hx = [-1,0,1];
            %hx = [-1,1];
            hy = -hx';
            grad_xr = imfilter(double(Im),hx);
            grad_yu = imfilter(double(Im),hy);
            
            %%%
            %             grad_xr = grad_xr(2:L+1,2:C+1);
            %             grad_yu = grad_yu(2:L+1,2:C+1);
            %%%
            
            angles=atan2(grad_yu,grad_xr);
            magnit=((grad_yu.^2)+(grad_xr.^2)).^.5;
            for n=0:nwin_y-1
                for m=0:nwin_x-1
                    cont=cont+1;
                    angles2=angles(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x);
                    magnit2=magnit(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x);
                    v_angles=angles2(:);
                    v_magnit=magnit2(:);
                    K=max(size(v_angles));
                    %assembling the histogram with 9 bins (range of 20 degrees per bin)
                    bin=0;
                    H2=zeros(B,1);
                    for ang_lim=-pi+2*pi/B:2*pi/B:pi
                        bin=bin+1;
                        for k=1:K
                            if v_angles(k)<ang_lim
                                v_angles(k)=100;
                                H2(bin)=H2(bin)+v_magnit(k);
                            end
                        end
                    end
                    
                    H2=H2/(norm(H2)+0.01);
                    H((cont-1)*B+1:cont*B,1)=H2;
                end
            end
        end
    end
end


