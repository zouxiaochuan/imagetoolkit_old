classdef lmADetector < handle
    %LMADETECTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Abstract)
        rects = detect(im);
    end
    
end

