classdef lmEncoderBoFSoftThresh < lmAEncoderFeature
    %LMENCODERBOF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mCodebook;
        mThresh;
        mNumCode;
    end
    
    methods
        function OBJ = lmEncoderBoFSoftThresh(codebook,thresh)
            OBJ.mCodebook = codebook;
            
            OBJ.mNumCode = size(OBJ.mCodebook,2);
            OBJ.mThresh = thresh;
        end
        
        function code = encode(OBJ,descriptors)
            numCode = OBJ.mNumCode;
            codebook = OBJ.mCodebook;
            thresh = OBJ.mThresh;
            
            numPoint = size(descriptors,2);
            code = zeros(numCode,numPoint);
            
            for i=1:numPoint
                d = descriptors(:,i);
                mat = repmat(d,1,numCode);
                dists = sum((mat - codebook).^2)';
                v = std(dists);
                c = exp(-dists/v);
                c = c / norm(c);
                c(c<thresh) = 0;
                c = c / norm(c);
                code(:,i) = c;
            end
        end
        
        function encoded = pool(OBJ,code)
            encoded = max(code,[],2);
        end
        
        function numDim = codeDimension(OBJ)
            numDim = OBJ.mNumCode;
        end
    end
    
end

