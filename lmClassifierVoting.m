classdef lmClassifierVoting < lmAClassifierOffline
    %LMCLASSIFIERVOTING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mClassifiers;
        mMaxIteration;
    end
    
    methods
        function obj = lmClassifierVoting(cs,maxIter)
            obj.mClassifiers = cs;
            obj.mMaxIteration = maxIter;
        end
        
        function [labelPredict, obj] = classify(obj,dataTest,dataTrain,labelTrain)
            if (length(dataTest) ~= length(obj.mClassifiers)) || ...
                    (length(dataTrain) ~= length(obj.mClassifiers))
                return;
            end
            
            numViews = length(obj.mClassifiers);
            numTrain = size(dataTrain{1},2);
            numTest = size(dataTest{1},2);
            
            iter = 1;
            
            [numEqVote,score,lpTest] = obj.singleClassify(dataTest,dataTrain,labelTrain);
            
            while (iter < obj.mMaxIteration) && (numEqVote>0)
                %             lpTrain = zeros(numTrain,numViews);
                %             for i=1:numViews
                %                 c = obj.mClassifiers{i};
                %                 train = dataTrain{i};
                %
                %                 lpTrain(:,i) = c.classify(train,train,labelTrain);
                %             end
                %
                %             param.lambda = 1;
                %             param.mode = 2;
                %
                %             w = mexLasso(labelTrain,lpTrain,param);
                %
                %             w = w / sum(w);
                labelPredict = score;
                return;
                labelPredict(labelPredict>0.5) = 1;
                labelPredict(labelPredict<=0.5) = 0;
                %return;
                for i=1:numViews
                    train{i} = [dataTrain{i},dataTest{i}];
                    test{i} = dataTest{i};
                end
                
                label = [labelTrain;labelPredict];
                
                [numEqVote,score,lpTest] = obj.singleClassify(test,train,label);
                
                plog(['iter: ' num2str(iter) ', numEqVote: ' num2str(numEqVote)]);
                
                iter = iter + 1;
            end
            
            labelPredict = mean(lpTest,2);
%             labelPredict(labelPredict>0.5) = 1;
%             labelPredict(labelPredict<=0.5) = 0;
        end
        
        function [numeq,score,lpTest] = singleClassify(obj,dataTest,dataTrain,label)
            numViews = length(obj.mClassifiers);
            numTrain = size(dataTrain{1},2);
            numTest = size(dataTest{1},2);
            
            lpTest = zeros(numTest,numViews);
            for i=1:numViews
                c = obj.mClassifiers{i};
                train = dataTrain{i};
                test = dataTest{i};
                
                lpTest(:,i) = c.classify(test,train,label);
            end
            
            lppTest = lpTest;
            lppTest(lpTest>0.5) = 1;
            lppTest(lpTest<=0.5) = 0;
            
            %score = lpTest * w;
            vote = sum(lppTest,2);
            numeq = length(find((vote<4)&(vote>0)));
            score = mean(lpTest,2);
        end
    end
    
end

