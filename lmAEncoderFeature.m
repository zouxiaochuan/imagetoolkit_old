classdef lmAEncoderFeature < handle
    
    properties
    end
    
    methods(Abstract)
        [codeOut] = encode(obj, codeIn);
        [codeOut] = pool(obj, codeIn);
        [dimension] = codeDimension(obj);
    end
    
end

