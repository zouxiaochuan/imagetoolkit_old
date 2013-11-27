classdef lmEncoderBoFTri < lmAEncoderFeature
    
    properties
        mCodebook;
        
        mNumCode;
    end
    
    methods
        function OBJ = lmEncoderBoFTri(codebook)
            OBJ.mCodebook = codebook;
            OBJ.mNumCode = size(codebook,2);
        end
        
        function code = encode(OBJ,descriptors)
            numPoint = size(descriptors,2);
            numCode = OBJ.mNumCode;
            
            code = zeros(numCode,numPoint);
            
            for i=1:numPoint
                p = descriptors(:,i);
                matp = repmat(p,[1,numCode]);
                
                dist = sum((OBJ.mCodebook - matp).^2);
                dist = dist(:);
                dist = mean(dist) - dist;
                
                dist(dist<0) = 0;
                code(:,i) = dist/norm(dist);
            end
        end
        
        function encoded = pool( OBJ,code)
            encoded = sum(code,2);
        end
        
        function numDim = codeDimension(OBJ)
            numDim = OBJ.mNumCode;
        end
    end
    
end

