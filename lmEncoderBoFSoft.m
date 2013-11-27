classdef lmEncoderBoFSoft < lmAEncoderFeature
    %LMENCODERBOF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mCodebook;
        mKDTree;
        mNumNonzero;
        
        mNumCode;
    end
    
    methods
        function OBJ = lmEncoderBoFSoft(codebook,numNonzero)
            OBJ.mCodebook = double(codebook.basis);
            OBJ.mKDTree = vl_kdtreebuild(OBJ.mCodebook);
            
            OBJ.mNumCode = size(OBJ.mCodebook,2);
            OBJ.mNumNonzero = numNonzero;
        end
        
        function code = encode(OBJ,descriptors)
            numPoint = size(descriptors,2);
            code = zeros(OBJ.mNumCode,numPoint);
            [index,dist] = vl_kdtreequery(OBJ.mKDTree, OBJ.mCodebook,double(descriptors)...
                ,'NumNeighbors',OBJ.mNumNonzero);
            
            
            for i=1:numPoint
                v = std(dist(:,i));
                for j=1:OBJ.mNumNonzero
                    code(index(j,i),i)=exp(-dist(j,i)/v);
                end
                code(:,i) = code(:,i)/norm(code(:,i));
            end
        end
        
        function encoded = pool(OBJ,code)
            encoded = sum(code,2);
        end
        
        function numDim = codeDimension(OBJ)
            numDim = OBJ.mNumCode;
        end
    end
    
end

