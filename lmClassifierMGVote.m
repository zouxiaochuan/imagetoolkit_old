classdef lmClassifierMGVote < lmAClassifierOffline
    %LMCLASSIFIERKNN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mNumNeighbour;
        mKernel;
    end
    
    methods
        function obj = lmClassifierMGVote(numNeighbour, kernel)
            obj.mNumNeighbour = numNeighbour;
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
%                 sorts = sorts(1:obj.mNumNeighbour,:);
                sorts(:,1) = sorts(:,1) / var(sorts(:,1));
                sorts(:,1) = exp(-sorts(:,1));
                count=zeros(1,numCate);
                for j=1:obj.mNumNeighbour
                    count(sorts(j,2))=count(sorts(j,2))+sorts(j,1);
                end
                [~,C(i)]=max(count);
            end
            labelPredict=C';
            labelPredict = labelPredict + minLabel - 1;
        end
    end
    
end

