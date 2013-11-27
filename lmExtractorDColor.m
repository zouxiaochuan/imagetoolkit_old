classdef lmExtractorDColor < lmAExtractorLocalDescriptor
    %LMEXTRACTORDCOLOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mExtractor;
    end
    
    methods
        function obj = lmExtractorDColor(extractor)
            % information of the method
            name = 'DColor';
            description='Dense Color';
            % construction from base class
            obj = obj@lmAExtractorLocalDescriptor(name,description);
            
            obj.mExtractor = extractor;
        end
        
        function [descriptors,locations,obj]=extractFromMat(obj,img,varargin)
            if size(img,3) == 1
                img = repmat(img,[1,1,3]);
            end
            
            ds = cell(3,1);
            for i=1:3
                [ds{i},locations] = obj.mExtractor.extractFromMat(img(:,:,i));
            end
            
            descriptors = [ds{1};ds{2};ds{3}];
        end
        
        function [numDim] = featureDimension(obj,im)
            numDim = mExtractor.featureDimension(im)*3;
        end        
    end
    
end

