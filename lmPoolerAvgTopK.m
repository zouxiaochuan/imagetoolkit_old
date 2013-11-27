classdef lmPoolerAvgTopK < lmAPooler
    %LMPOOLERAVGTOPK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mK = 0;
    end
    
    methods
        function obj = lmPoolerAvgTopK( k)
            obj.mK = k;
        end
        
        function codeOut = pool(obj, codeIn)
            k = obj.mK;
            
            codeOut = zeros(size(codeIn,1),1);
            for i=1:size(codeIn,1)
                v = sort(codeIn(i,:),'descend');
                codeOut(i) = mean(v(1:min(k,length(v))));
            end
        end
    end
    
end

