classdef lmClassifierSLF < lmAClassifierOffline
    
    properties
        mClassifier;
        mThresh;
    end
    
    methods
        function obj = lmClassifierSLF( classifier, thresh)
            obj.mClassifier = classifier;
            obj.mThresh = thresh;
        end
        
        function [labelPredict, obj] = classify(obj,dataTest,dataTrain,labelTrain)
            numAdded = 1;
            totalAdded = 0;
            mapo = zeros(size(dataTest,2),1);
            mapc = mapo;
            labelPredict = zeros(size(dataTest,2),1);
            while (numAdded > 0) && ( size(dataTest,2) >0)
                scores = obj.mClassifier.classify(dataTest,dataTrain,labelTrain);
                thrUp = obj.mThresh;
                thrBottom = 1 - thrUp;
                addedPos = (scores>thrUp);
                addedNeg = (scores<thrBottom);
                ci = find(~mapc);
                mapc(ci(addedPos|addedNeg)) = 1;
                labelPredict(ci(addedPos)) = scores(addedPos);
                labelPredict(ci(addedNeg)) = scores(addedNeg);
                numAdPos = length(find(addedPos));
                numAdNeg = length(find(addedNeg));
                numAdded = numAdPos + numAdNeg;
                if numAdded > 0
                    
                    labelTrain = [labelTrain;ones(numAdPos,1);zeros(numAdNeg,1)];
                    dataTrain = [dataTrain,dataTest(:,addedPos|addedNeg)];
                    dataTest = dataTest(:,~(addedPos|addedNeg));
                    totalAdded = totalAdded + numAdded;
                else
                    plog(['converged, total added number:' num2str(totalAdded)]);
                    break;
                end
            end
            if size(dataTest,2) > 0
            labelPredict(~mapc) = scores;
%             labelPredict(labelPredict>0.5) = 1;
%             labelPredict(labelPredict<=0.5) = 0;
            end
        end
    end
    
end

