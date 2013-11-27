classdef lmAEncoder
    %LMAENCODER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Abstract)
        [codeOut] = encode( codeIn);
        [codeOut] = pool( codeIn);
    end
    
end

