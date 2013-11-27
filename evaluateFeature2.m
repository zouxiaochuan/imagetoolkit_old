function [ acc,accMap ] = evaluateFeature2( dataset,classifier,extractor, fold, pathFeature, useSparse)
if nargin >= 5 && ~isempty(pathFeature)
    usePathFeature = true;
else
    usePathFeature =false;
end
if usePathFeature && exist(pathFeature,'file')
    useSavedFeature = true;
else
    useSavedFeature = false;
end
if nargin < 6
    useSparse = false;
end

if useSavedFeature
    data = load(pathFeature);
    feature = data.feature;
    clear('data');
else
    if useSparse
        feature = extractor.extractFromDatasetSparse(dataset);
    else
        feature = extractor.extractFromDataset(dataset);
    end
    if usePathFeature
        save(pathFeature,'feature');
    end
end

numClass = max(dataset.mLabels);

accMap = zeros( numClass);

acc = Validate.CrossValidate(dataset.mLabels,feature,classifier,fold);

end

