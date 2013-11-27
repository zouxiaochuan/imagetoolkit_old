classdef lmClassifierCotrainEx < lmAClassifierOffline
    %LMCLASSIFIERCOTRAINEX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mClassifiers;
        mMaxIteration;
    end
    
    methods
        function obj = lmClassifierCotrainEx(cs,maxIter)
            obj.mClassifiers = cs;
            obj.mMaxIteration = maxIter;
        end
        
        function [labelPredict, obj] = classify(obj,dataTest,dataTrain,labelTrain)
            [score,conf,numDisagree] = obj.classifySingle(dataTest,dataTrain,labelTrain);
            numViews = length(obj.mClassifiers);
            iter = 1;
            
            while (iter < obj.mMaxIteration) && (numDisagree>0)
                for i=1:numViews
                    selected = false(numViews,1)';
                    selected(i) = true;
                    myconf = conf(:,selected);
                    [otconf,otlp] = obj.poolConf(conf(:,~selected),score(:,~selected));
                    
                    suggest = (otconf > myconf);
                    
                    t = dataTest{i};
                    test{i} = t;
                    train{i} = [dataTrain{i},t(:,suggest')];
                    label{i} = [labelTrain;otlp(suggest)];
                end
                
                plog(['iter: ' num2str(iter) ', numDisagree: ' num2str(numDisagree)]);
                [score,conf,numDisagree] = obj.classifySingle(test,train,label);
                
                iter = iter+1;
            end
            
            plog('converged');
            
            labelPredict = score(:,end);
%             labelPredict(labelPredict>0.5) = 1;
%             labelPredict(labelPredict<=0.5) = 0;
        end
        
        function [oconf,lp] = poolConf(obj,conf,score)
            ss = score;
            ss(ss>0.5) = 1;
            ss(ss<=0.5) = 0;
            
            [oconf,ind] = max(conf,[],2);
            lp = ss(sub2ind(size(score),(1:length(ind))',ind));
        end
        
        function [scores,conf,numDisagree] = classifySingle(obj,dataTest,dataTrain,labelTrain)
            numViews = length(obj.mClassifiers);
            numTrain = size(dataTrain{1},2);
            numTest = size(dataTest{1},2);
            
            scores = zeros(numTest,numViews);
            for i=1:numViews
                c = obj.mClassifiers{i};
                train = dataTrain{i};
                test = dataTest{i};
                
                if iscell(labelTrain)
                    label = labelTrain{i};
                else
                    label = labelTrain;
                end
                
                scores(:,i) = c.classify(test,train,label);
            end
            
            conf = scores;
            conf = max(conf,1-conf);
            
            lp = scores;
            lp(lp>0.5) = 1;
            lp(lp<=0.5) = 0;
            lp = sum(lp,2);
            
            numDisagree = length(find((lp<numViews)&(lp>0)));
        end
    end
    
end

