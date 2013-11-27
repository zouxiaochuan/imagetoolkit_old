classdef lmExtractorBinary < lmAExtractorFeature
    %LMEXTRACTORGABOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = lmExtractorBinary()
            name = 'Binary';
            description = 'Binary feature';
            
            obj = obj@lmAExtractorFeature(name,description);
        end
        
        function [featureVec,obj] = extractFromMat(obj,img,varargin)
            if size(img,3)>1
                img = rgb2gray(img);
            end
            map = double(img);
            map(map<128) = 0;
            map(map>=128) = 1;
            
            hist1 = hist(reshape(map,[],1),[0,1]);

            xf = [-1,1];
            yf = [-1;1];
            mapx = imfilter(map,xf);
            mapy = imfilter(map,yf);
            
            diff1 = [-1,0,1];
            cent = obj.generateCent(diff1);
            
            temp1 = reshape(mapx,1,[]);
            temp2 = reshape(mapy,1,[]);
            temp = [temp1;temp2];
            hist2 = hist(temp,cent);
            featureVec = [hist1(:);hist2(:)];
        end
        
        function nDim = featureDimension(obj,img)
            nDim = 2;
        end
        
        function histo = computeHistogram(preMap, level)
            xf = [-1,1];
            yf = [-1;1];
            
            mapx = imfilter(preMap,xf);
            
        end
        function cent = generateCent(obj,diff)
            cent = zeros(2,length(diff)^2);
            index = 1;
            for i=1:length(diff)
                for j=1:length(diff)
                    cent(:,index) = [diff(i);diff(j)];
                    index = index + 1;
                end
            end
        end
    end
    
end

