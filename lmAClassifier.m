classdef lmAClassifier < handle
    %LMACLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Abstract)
        obj = train(obj,data,label);
        labelPredict = predict( obj, data);
    end
    
end

