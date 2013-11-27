classdef lmClassifierLiblinear < lmAClassifierOffline
    
    properties
        mOptions;
        mProbCol;
        mModel;
    end
    
    methods
        function obj = lmClassifierLiblinear(options,probCol)
            if nargin < 1
                obj.mOptions = '-s 1 -c 1 -q -B 1';
            else
                obj.mOptions = options;
            end
            
            if nargin >= 2
                obj.mProbCol = probCol;
            else
                obj.mProbCol = [];
            end
        end
        
        function [labelPredict, obj] = classify(obj,dataTest,dataTrain,labelTrain)
            dataTrain = dataTrain';
            dataTest = dataTest';
            
            if ~issparse(dataTrain)
                dataTrain = sparse(dataTrain);
            end
            if ~issparse(dataTest)
                dataTest = sparse(dataTest);
            end
            
            model = train(labelTrain,dataTrain,obj.mOptions);
            
            if isempty(obj.mProbCol)
                [labelPredict,~,~] =  predict(ones(size(dataTest,1),1),dataTest, model, '-q');
            else
                [~,~,probs] = predict(ones(size(dataTest,1),1),dataTest, model,'-b 1 -q');
                labelPredict = probs(:,(model.Label==obj.mProbCol));
            end
        end
        
        function obj = train(obj,data,label)
            if ~issparse(data)
                data = sparse(data);
            end
            obj.mModel = train(label,data',obj.mOptions);
        end
        
        function pre = predict(obj,data)
            if ~issparse(data)
                data = sparse(data);
            end
            [pre,~,~] = predict(ones(size(data,2),1),data',obj.mModel,'-q');
        end
    end
    
end

