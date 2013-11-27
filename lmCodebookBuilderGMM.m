classdef lmCodebookBuilderGMM < lmACodebookBuilder
    
    properties
        mNumGauss;
        mMinGamma;
        mAlpha;
        mMaxIteration;
        mMinVar;
        mThreshTermination;
    end
    
    methods
        function obj = lmCodebookBuilderGMM(nGauss,minGamma,alpha,maxIter,minVar,thrTerminate)
            obj.mNumGauss = nGauss;
            obj.mMinGamma = minGamma;
            obj.mAlpha = alpha;
            obj.mMaxIteration = maxIter;
            obj.mMinVar = minVar;
            obj.mThreshTermination = thrTerminate;
        end
        
        function [codebook,obj] = build(obj,feats)
            param.max_iter = obj.mMaxIteration;
            param.alpha = obj.mAlpha;
            param.llh_diff_thr = obj.mThreshTermination;
            param.min_gamma = obj.mMinGamma;
            param.variance_floor = obj.mMinVar;
            
            [C, A] = vl_kmeans(single(feats),obj.mNumGauss,'verbose',...
                'MaxNumIterations',5,'Initialization','plusplus',...
                'Numrepetitions',1,'Algorithm','LLOYD');
            
            [im,iv,ic] = obj.initFromKmeans(feats,C,A);
            
            codebook = mexGmmTrainSP(single(feats),single(obj.mNumGauss)...
                ,param,single(im),single(iv),single(ic));
        end
        
        function [im,iv,ic] = initFromKmeans(obj,feats, C, A)
            ngauss = size(C,2);
            ndim = size(C,1);
            
            im = C;
            
            ic = zeros(ngauss,1);
            iv = zeros(ndim,ngauss);
            for i=1:ngauss
                belong = (A==i);
                ic(i) = mean(belong);
                pb = feats(:,belong);
                for d = 1:ndim
                    iv(d,i) = var(pb(d,:));
                end
            end
        end
    end
    
end

