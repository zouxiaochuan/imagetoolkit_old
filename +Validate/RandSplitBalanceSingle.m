function split = RandSplitBalanceSingle( label,nTest)
ulabel = unique(label);

split = true(length(label),1);

for i=1:length(ulabel)
    l = ulabel(i);
    indices = find(label==l);
    
    if length(indices) <= nTest
        throw 'nTest is bigger than the number of samples'
    end
    
    rperm = randperm(length(indices));
    split((indices(rperm(1:nTest)))) = false;
end

end

