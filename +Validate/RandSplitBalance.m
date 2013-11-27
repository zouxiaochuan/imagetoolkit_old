function splits = RandSplitBalance( label,nTest,nRun)

splits = true(length(label),nRun);

for i=1:nRun
    splits(:,i) = Validate.RandSplitBalanceSingle(label,nTest);
end

end

