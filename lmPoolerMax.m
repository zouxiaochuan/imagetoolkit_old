classdef lmPoolerMax < lmAPooler
    %LMPOOLERMAX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function codeOut = pool(obj, codeIn)
            codeOut = max(codeIn,[],2);
        end        
    end
    
end

