classdef lmCodebookBuilderSparseL1 < lmACodebookBuilder
    %LMCODEBOOKBUILDERGMM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mLambda;
        mMaxIter;
        mNumCode;
    end
    
    methods
        function obj = lmCodebookBuilderSparseL1(numCode,lambda,maxIter)
            obj.mNumCode = numCode;
            obj.mMaxIter = maxIter;
            obj.mLambda = lambda;
        end
        
        function [codebook,obj] = build(obj,feats)
            
            mfea = mean(feats,2);
            for i=1:size(feats,2)
                feats(:,i) = feats(:,i) - mfea;
            end
            
            param.K=obj.mNumCode;
            param.lambda=obj.mLambda;
            %param.batchsize=400;
            
            param.iter=obj.mMaxIter;
            
            plog('begin training dictionary...');
            tic;
            codebook.basis = mexTrainDL(feats,param);
            t = toc;
            plog(['training ended in ' num2str(t) ' seconds']);
            codebook.mean = mfea;
        end
    end
    
end

