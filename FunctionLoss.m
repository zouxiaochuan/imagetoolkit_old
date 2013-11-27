classdef FunctionLoss
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function loss = Loss01(gt,pr)
            %0/1 loss
            loss = mean(gt~=pr);
        end
        
        function loss = LossLog(gt,pr)
            %log loss
            loss = -mean(gt.*log(pr) + (1-gt).*log(1-pr));
        end
        
        function loss = thresh01(gt,pr)
            thrUp = 0.70;
            thrBottom = 1-thrUp;
            
            t = gt(pr>thrUp);
            numTotal = length(t);
            numWrong = length(find(t==0));
            
            t = gt(pr<=thrBottom);
            numTotal = numTotal + length(t);
            numWrong = numWrong + length(find(t==1));
            
            if numTotal == 0
                loss = 0;
            else
                loss = numWrong / numTotal;  
            end
        end
    end
    
end

