function loss = CrossValidate( label,feature,classifier,fold, lossFunc)
if nargin < 5
    lossFunc = @FunctionLoss.Loss01;
end

splits = Validate.CrossSplit(label,fold);

sumLoss = 0;
for i=1:fold
    spl = splits(:,i);
    labelTrain = label(spl);
    featureTrain = feature(:,spl');
    
    labelTest = label(~spl);
    featureTest = feature(:, ~spl');
    
    labelPredict = classifier.classify(featureTest,featureTrain,labelTrain);
    
    tloss = lossFunc(labelTest,labelPredict);
    sumLoss = sumLoss + tloss*length(labelTest);
end

loss = sumLoss / length(label);
end
