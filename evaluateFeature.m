function [ acc,accMap ] = evaluateFeature( dataset,classifier,extractor, numTrain, numTest, numRun...
    ,pathFeature)
if nargin == 7 && ~isempty(pathFeature)
    usePathFeature = true;
else
    usePathFeature =false;
end
if usePathFeature && exist(pathFeature,'file')
    useSavedFeature = true;
else
    useSavedFeature = false;
end

if useSavedFeature
    data = load(pathFeature);
    feature = data.feature;
    clear('data');
else
    feature = extractor.extractFromDataset(dataset);
    if usePathFeature
        save(pathFeature,'feature');
    end
end

numClass = max(dataset.mLabels);

acc = zeros(1, numRun);
accMap = zeros( numClass, numRun);

for i=1:numRun
    [setTrain, setTest] = splitData(dataset.mLabels,numTrain,numTest);
    feaTrain = double(feature(:,setTrain));
    feaTest = double(feature(:,setTest));
    labelTrain = dataset.mLabels(setTrain);
    labelTest = dataset.mLabels(setTest);
    
    predict = classifier.classify(feaTest,feaTrain,labelTrain);
    
    acc(i) = mean(predict==labelTest);
    for j=1:numClass
        labelTmp = labelTest;
        labelTmp(labelTmp~=j) = 0;
        accMap(j,i) = length(find(predict==labelTmp))/length(find(labelTmp==j));
    end
end

end

