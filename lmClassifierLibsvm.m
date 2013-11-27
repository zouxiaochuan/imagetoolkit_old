classdef lmClassifierLibsvm < lmAClassifierOffline
    
    properties
        mKernelFunc;
        mOption;
    end
    
    methods
        function obj = lmClassifierLibsvm(k,option)
            obj.mKernelFunc = k;
            
            if nargin < 2
                obj.mOption = '-s 0 -q -c 1';
            else
                obj.mOption = option;
            end
        end
        
        function [labelPredict] = classify(obj,dataTest,dataTrain,labelTrain)
            numTrain = size(dataTrain,2);
            numTest = size(dataTest,2);
            
            kmat = zeros(numTrain);
            
            for i=1:numTrain
                point = dataTrain(:,i);
                matPoint = repmat(point,1,numTrain);
                kmat(i,:) = obj.mKernelFunc(matPoint,dataTrain);
            end
            
            tkmat = zeros(numTest,numTrain);
            
            for i=1:numTest
                point = dataTest(:,i);
                matPoint = repmat(point,1,numTrain);
                tkmat(i,:) = obj.mKernelFunc(matPoint,dataTrain);
            end
            
            kmat = [(1:numTrain)',kmat];
            tkmat = [(1:numTest)',tkmat];
            
            option = [obj.mOption '-t 4'];
            
            mm = svmtrain(labelTrain,kmat,option);
            
            [labelPredict,~,~] = svmpredict(ones(numTest,1),tkmat,mm,'-q');
        end
    end
    
end

