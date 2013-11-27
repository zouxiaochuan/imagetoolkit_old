classdef lmCodebookBuilderKmeans < lmACodebookBuilder
    %LMCODEBOOKBUILDERGMM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mNumCent;
        mMaxIter;
        mNumRepet;
    end
    
    methods
        function obj = lmCodebookBuilderKmeans(numCent,maxIter,numRepet)
            obj.mNumCent = numCent;
            obj.mMaxIter = maxIter;
            obj.mNumRepet = numRepet;
        end
        
        function [codebook,obj] = build(obj,feats)
            
            [codebook.basis,~] = vl_kmeans(feats,obj.mNumCent,'verbose',...
                'MaxNumIterations',obj.mMaxIter,'Initialization','plusplus',...
                'Numrepetitions',obj.mNumRepet,'Algorithm','LLOYD');            
        end
    end
    
end

