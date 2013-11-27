function loss = validate(label,feature,classifier,splits,lossFunc)

loss = zeros(size(splits,2),1);
for i=1:size(splits,2)
    split = splits(:,i);
    
    labelTrain = label(split);
    labelTest = label(~split);
    fTrain = feature(:,split);
    fTest = feature(:,~split);
    
    classifier.train(fTrain,labelTrain);
    labelPredict = classifier.predict(fTest);
    
    loss(i) = lossFunc(labelTest,labelPredict);
end

end

