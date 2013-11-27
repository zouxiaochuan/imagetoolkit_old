classdef lmClassifierKNN < lmAClassifierOffline
    %LMCLASSIFIERKNN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mK;
        mKernel;
    end
    
    methods
        function obj = lmClassifierKNN( k,kernel)
            obj.mK = k;
            obj.mKernel = kernel;
        end
        
        function [labelPredict] = classify(obj,dataTest,dataTrain,labelTrain)
            labelTrain = labelTrain';
            
            numPointTest = size(dataTest,2);
            numPointTrain = size(dataTrain,2);
            
            minLabel = min(labelTrain);
            labelTrain = labelTrain - minLabel + 1;
            
            numCate = max(labelTrain);
            
            parfor i=1:numPointTest
                qPoint = dataTest(:,i);
                matPoint = repmat(qPoint,1,numPointTrain);
                matCorelation = -obj.mKernel(matPoint,dataTrain);
                sorts = [ matCorelation',labelTrain'];
                sorts = sortrows(sorts,1);
                count=zeros(1,numCate);
                for j=1:obj.mK
                    count(sorts(j,2))=count(sorts(j,2))+1;
                end
                [~,C(i)]=max(count);
            end
            labelPredict=C';
            labelPredict = labelPredict + minLabel - 1;
        end
    end
    
end

