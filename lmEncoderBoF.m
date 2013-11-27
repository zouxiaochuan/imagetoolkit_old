classdef lmEncoderBoF < lmAEncoderFeature
    %LMENCODERBOF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mCodebook;
        mKDTree;
        
        mNumCode;
    end
    
    methods
        function OBJ = lmEncoderBoF(codebook)
            OBJ.mCodebook = double(codebook.basis);
            OBJ.mKDTree = vl_kdtreebuild(OBJ.mCodebook);
            
            OBJ.mNumCode = size(OBJ.mCodebook,2);
        end
        
        function code = encode(OBJ,descriptors)
            numPoint = size(descriptors,2);
            code = zeros(OBJ.mNumCode,numPoint);
            indices = vl_kdtreequery(OBJ.mKDTree, OBJ.mCodebook,double(descriptors));
            
            for i=1:numPoint
                code(indices(i),i)=1;
            end
        end
        
        function encoded = pool(OBJ,code)
            encoded = mean(code,2);
        end
        
        function numDim = codeDimension(OBJ)
            numDim = OBJ.mNumCode;
        end
    end
    
end

