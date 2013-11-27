classdef lmClassifierNaiveBayes < lmAClassifierOffline
    %LMCLASSIFIERKNN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = lmClassifierNaiveBayes()
        end
        
        function [labelPredict] = classify(obj,dataTest,dataTrain,labelTrain)
            dataTrain = dataTrain';
            ulabel = unique(labelTrain);
            for i=1:length(ulabel)
                lindex = find(labelTrain==ulabel(i));
                ptable(i,:)=sum(dataTrain(lindex,:));
            end
            ptable = ptabel / sum(sum(ptable));
            ptableW = sum(ptable);
            
            ps = zeros(length(ulabel,size(dataTest,2)));
            for i=1:size(dataTest,2)
                point = dataTest(:,i);
                [indices,~,values] = find(point);
                for j=1:length(ulabel)
                    ps(j,i) = (ptable(j,indices)./ptableW(indices)).^values;
                end
            end
            [~,labelPredict] = max(ps);
            labelPredict = labelPredict';
        end
    end
    
end

