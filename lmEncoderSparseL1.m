classdef lmEncoderSparseL1
    %LMENCODERSPARSEL2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mCodebook;
        mNumCode;
        mLamda;
    end
    
    methods
        function OBJ = lmEncoderSparseL1(codebook,lamda)
            OBJ.mCodebook = codebook;
            OBJ.mNumCode = size(OBJ.mCodebook.basis,2);
            OBJ.mLamda = lamda;
        end

        function code = encode(OBJ,descriptors)
            param.lambda = OBJ.mLamda;
            param.numThreads = -1;
            param.mode = 2;
            %param.L = 256;
            descriptors = descriptors - repmat(OBJ.mCodebook.mean,[1,size(descriptors,2)]);
            code = mexLasso(double(descriptors),double(OBJ.mCodebook.basis),param);
        end
        
        function encoded = pool(OBJ,code)
            encoded = max(code,[],2);
        end
        
        function numDim = codeDimension(OBJ)
            numDim = OBJ.mNumCode;
        end        
    end
    
end

