function splits = CrossSplit(label, fold)
ulabel = unique(label);

splits = false(length(label),fold);

for i=1:length(ulabel)
    labelSet = (label == ulabel(i));
    labelIdx = find(labelSet);
    
    numElem = length(labelIdx);
    
    if numElem < fold
        throw 'fold is bigger than samples of one label';
    end
    
    inter = ceil(numElem / fold);
    
    for j=1:fold
        selSet = labelSet;
        selSet(labelIdx((j-1)*inter+1:min(j*inter,numElem))) = false;
        
        splits(:,j) = splits(:,j) | selSet;
    end
end
end