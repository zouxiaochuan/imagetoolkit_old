classdef lmPoolerSum < lmAPooler
    %LMPOOLERAVG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function codeOut = pool(obj, codeIn)
            codeOut = sum(codeIn,2);
        end
    end
    
end


