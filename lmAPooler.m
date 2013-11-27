classdef lmAPooler < handle
    %LMAPOOLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Abstract)
        [codeOut] = pool(obj, codeIn, locations);
    end
    
end

