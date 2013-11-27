classdef lmEncoderFKvgg < lmAEncoderFeature
    %LMENCODERBOF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mCodebook;
        mVGGEncoder;
    end
    
    methods
        function OBJ = lmEncoderFKvgg(codebook)
            OBJ.mCodebook = codebook;
            OBJ.mVGGEncoder = featpipem.encoding.FKEncoder(codebook);
        end
        
        function code = encode(OBJ,descriptors)
            numPoint = size(descriptors,2);
            numDim = OBJ.codeDimension();
            code = zeros(numDim,numPoint);
            
            for i=1:numPoint
                code(:,i) = OBJ.mVGGEncoder.encode(descriptors(:,i));
            end
        end
        
        function encoded = pool(OBJ,code)
            encoded = mean(code,2);
        end
        
        function numDim = codeDimension(OBJ)
            numDim = OBJ.mVGGEncoder.get_output_dim();
        end
    end
    
end

