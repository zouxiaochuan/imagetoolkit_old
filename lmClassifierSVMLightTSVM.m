classdef lmClassifierSVMLightTSVM < lmAClassifierOffline
    %LMCLASSIFIERSVMLIGHTTSVM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mClassifierSVMLight;
    end
    
    methods
        function obj = lmClassifierSVMLightTSVM(svmlight)
            obj.mClassifierSVMLight = svmlight;
        end
        
        function [labelPredict, obj] = classify(obj,dataTest,dataTrain,labelTrain)
            numTrain = size(dataTrain,2);
            numTest = size(dataTest,2);
            
            label = zeros(numTrain+numTest,1);
            label(1:numTrain) = labelTrain;
            
            train = [dataTrain,dataTest];
            
            labelPredict = obj.mClassifierSVMLight.classify(dataTest,train,label);
        end
    end
    
end

