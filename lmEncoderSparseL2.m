classdef lmEncoderSparseL2
    %LMENCODERSPARSEL2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mCodebook;
        mNumCode;
        mWeight;
    end
    
    methods
        function OBJ = lmEncoderSparseL2(codebook,lamda)
            OBJ.mCodebook = codebook;
            OBJ.mNumCode = size(OBJ.mCodebook,2);
            
            OBJ.mWeight = (codebook'*codebook+lamda*eye(size(codebook,2)))\codebook';
        end

        function code = encode(OBJ,descriptors)
            code = zeros(OBJ.mNumCode,size(descriptors,2));
            oc = OBJ.mWeight * descriptors;
            
            for i=1:size(oc,2)
                c = oc(:,i);
                index = [c,(1:length(c))'];
                sortrows(index,1);

                for j=1:256
                    code(index(j,2),i) = index(j,1);
                end
                
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

