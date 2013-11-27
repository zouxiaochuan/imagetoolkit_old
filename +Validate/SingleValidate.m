function loss = SingleValidate( label,feature,classifier,fold, lossFunc)
if nargin < 5
    lossFunc = @FunctionLoss.Loss01;
end

splits = Validate.CrossSplit(label,fold);

spl = splits(:,1);
labelTrain = label(spl);
featureTrain = feature(:,spl');

labelTest = label(~spl);
featureTest = feature(:, ~spl');

labelPredict = classifier.classify(featureTest,featureTrain,labelTrain);

loss = lossFunc(labelTest,labelPredict);
end
