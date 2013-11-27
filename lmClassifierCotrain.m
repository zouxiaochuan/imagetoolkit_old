classdef lmClassifierCotrain < lmAClassifierOffline
    %LMCLASSIFIERCOTRAIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mClassifier1;
        mClassifier2;
        mMaxIteration;
        mThresh;
    end
    
    methods
        function obj = lmClassifierCotrain(c1,c2,maxIter,thresh)
            obj.mClassifier1 = c1;
            obj.mClassifier2 = c2;
            obj.mMaxIteration = maxIter;
            obj.mThresh = thresh;
            
        end
        
        function [labelPredict, obj] = classify(obj,dataTest,dataTrain,labelTrain)
            thrUp = obj.mThresh;
            thrBottom = 1-thrUp;
            
            lp1 = obj.mClassifier1.classify(dataTest{1},dataTrain{1},labelTrain);
            lp2 = obj.mClassifier2.classify(dataTest{2},dataTrain{2},labelTrain);
            
            lpp1 = threshold(lp1,0.5,0,1);
            lpp2 = threshold(lp2,0.5,0,1);
            
            iter = 1;
            minDisagree = length(lp1);
            while (nnz(lpp1~=lpp2) > 0) && (iter < obj.mMaxIteration)
                adPos1 = (lp1>thrUp);
                adNeg1 = (lp1<=thrBottom);
                adPos2 = (lp2>thrUp);
                adNeg2 = (lp2<=thrBottom);
                
                dTest1 = dataTest{1};
                dTest2 = dataTest{2};
                
                train{1} = [dataTrain{1},dTest1(:,(adPos2)),dTest1(:,(adNeg2))];
                train{2} = [dataTrain{2},dTest2(:,(adPos1)),dTest2(:,(adNeg1))];
                ltrain{1} = [labelTrain;ones(length(find(adPos2)),1);zeros(length(find(adNeg2)),1)];
                ltrain{2} = [labelTrain;ones(length(find(adPos1)),1);zeros(length(find(adNeg1)),1)];
                
                lp1 = obj.mClassifier1.classify(dataTest{1},train{1},ltrain{1});
                lp2 = obj.mClassifier2.classify(dataTest{2},train{2},ltrain{2});
                lpp1 = threshold(lp1,0.5,0,1);
                lpp2 = threshold(lp2,0.5,0,1);
                
                numDisagree = nnz(lpp1~=lpp2);
                
%                 if numDisagree <= minDisagree
%                     minDisagree = numDisagree;
%                     labelPredict = lp2;
%                 end
                plog(['iter: ' num2str(iter) ',disagree num: ' num2str(numDisagree)]);
                iter = iter + 1;
            end
            plog('converged');
            labelPredict = lp2;
            
        end
    end
    
end

function lpo = threshold(lpi,thr,mi,ma)
lpo = lpi;
lpo(lpo>thr) = ma;
lpo(lpo<=thr) = mi;
end

