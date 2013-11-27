classdef lmExtractorSPM < lmAExtractorFeature
    %LMEXTRACTORSPM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mEncoder;
        mExtractor;
        mPyramid;
        mPooler;
    end
    
    methods
        function obj = lmExtractorSPM( encoder, extractor, pooler, pyramid)
            if ~isempty(extractor)
                name = [extractor.mName '_SPM'];
            else
                name = 'SPM';
            end
            description = 'Spatial Pyramid Matching';
            
            obj = obj@lmAExtractorFeature(name,description);
            
            if nargin < 4
                obj.mPyramid = [1,2,4];
            else
                obj.mPyramid = pyramid;
            end
            
            obj.mExtractor = extractor;
            obj.mEncoder = encoder;
            obj.mPooler = pooler;
        end
        
        function [featureVec,obj] = extractFromMat(obj,img,varargin)
            pym = obj.mPyramid;
            [desc,loc] = obj.mExtractor.extractFromMat(img);
            encoded = obj.mEncoder.encode(desc);
            
            xs = loc(1,:);
            ys = loc(2,:);
            maxX = max(xs);
            minX = min(xs);
            maxY = max(ys);
            minY = min(ys);
            
            featureVec = zeros(obj.featureDimension(),1);
            feaIndex = 1;
            codeDim = obj.mEncoder.codeDimension();
            for i=1:length(pym)
                numSplit = pym(i);
                intX = ceil((maxX-minX) / numSplit) + 1;
                intY = ceil((maxY-minY) / numSplit) + 1;
                
                for x=minX:intX:maxX
                    for y=minY:intY:maxY
                        startX = x;
                        endX = startX + intX - 1;
                        startY = y;
                        endY = startY + intY - 1;
                        
                        codeIndex = (xs>=startX)&(xs<=endX)&(ys>=startY)&(ys<=endY);
                        featureVec(feaIndex:feaIndex+codeDim-1) = obj.mEncoder.pool(encoded(:,codeIndex));
                        feaIndex = feaIndex + codeDim;
                    end
                end
            end
        end
        
        function [featureVec,obj] = extractFromEncoded(obj,encoded, loc, codeDim)
            pym = obj.mPyramid;
            pooler = obj.mPooler;
            xs = loc(1,:);
            ys = loc(2,:);
            maxX = max(xs);
            minX = min(xs);
            maxY = max(ys);
            minY = min(ys);
            
            feaDim = codeDim * sum(obj.mPyramid.*obj.mPyramid);
            featureVec = zeros(feaDim,1);
            feaIndex = 1;
            
            for i=1:length(pym)
                numSplit = pym(i);
                intX = ceil((maxX-minX) / numSplit) + 1;
                intY = ceil((maxY-minY) / numSplit) + 1;
                
                for x=minX:intX:maxX
                    for y=minY:intY:maxY
                        startX = x;
                        endX = startX + intX - 1;
                        startY = y;
                        endY = startY + intY - 1;
                        
                        codeIndex = (xs>=startX)&(xs<=endX)&(ys>=startY)&(ys<=endY);
                        featureVec(feaIndex:feaIndex+codeDim-1) = pooler.pool(encoded(:,codeIndex));
                        feaIndex = feaIndex + codeDim;
                    end
                end
            end            
        end
        
        function nDim = featureDimension(obj,img)
            times = sum(obj.mPyramid.*obj.mPyramid);
            nDim = times * obj.mEncoder.codeDimension();
        end

    end
    
end

