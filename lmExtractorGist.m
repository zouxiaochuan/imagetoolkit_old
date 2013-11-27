classdef lmExtractorGist < lmAExtractorFeature
    %LMEXTRACTORGIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = lmExtractorGist()
            name = 'Gist';
            description = 'http://people.csail.mit.edu/torralba/code/spatialenvelope/';
            
            obj = obj@lmAExtractorFeature(name,description);
        end
        
        function [featureVec,obj] = extractFromMat(obj,img,varargin)
            
            param.orientationsPerScale = [8 8 8 8];
            param.numberBlocks = 4;
            param.fc_prefilt = 4;
            
            % Computing gist requires 1) prefilter image, 2) filter image and collect
            % output energies
            [featureVec, param] = LMgist(img, '', param);
            featureVec = featureVec';
        end
        
        function nDim = featureDimension(obj,img)
            nDim = 512;
        end
    end
end


