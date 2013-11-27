classdef lmAClassifierOffline < handle
    %need libsvm library
    properties
    end
    
    methods
    end
    methods (Abstract)
        [labelPredict] = classify(obj,dataTest,dataTrain,labelTrain)
    end
    
end

