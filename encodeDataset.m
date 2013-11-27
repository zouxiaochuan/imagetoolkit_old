function encodeDataset( dataset,savepath, extractor,encoder)
%ENCODEDATASET Summary of this function goes here
%   Detailed explanation goes here

parfor i=1:dataset.getSize()
    img = dataset.getSample(i);
    [desc,loc] = extractor.extractFromMat(img);
    
    encoded = encoder.encode(desc);
    
    tfilename = fullfile(savepath, dataset.getRawName(i));
    [parent,name,~]=fileparts(tfilename);
    if ~exist(parent,'dir')
        mkdir(parent);
    end
    sfilename = fullfile(parent,[name '.mat']);
    savefile(sfilename,sparse(encoded),loc);
end

end

function savefile(filename, encoded,loc)
save(filename,'encoded','loc');
end
