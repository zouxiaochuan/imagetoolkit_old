classdef lmEncoderLLC < lmAEncoderFeature
    %LMENCODERLLC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mCodebook;
        mKnn;
    end
    
    methods
        function obj = lmEncoderLLC(cb,knn)
            obj.mCodebook = cb.basis';
            obj.mKnn = knn;
        end
        
        function code = encode(obj,descriptors)
            code = lib.LLC.LLC_coding_appr(obj.mCodebook,descriptors',obj.mKnn)';
        end
        
        function encoded = pool(obj,code)
            encoded = code;
        end
        
        function numDim = codeDimension(obj)
            numDim = size(obj.mCodebook,1);
        end
    end
    
end

