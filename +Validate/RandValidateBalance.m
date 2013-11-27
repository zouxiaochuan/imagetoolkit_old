function loss = RandValidateBalance( label,feature,classifier,nTest,nRun,lossFunc)

splits = Validate.RandSplitBalance(label,nTest,nRun);

loss = Validate.validate(label,feature,classifier,splits,lossFunc);

end

