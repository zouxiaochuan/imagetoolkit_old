function feature = extractFromEncodedPath( extractor,pathsave,dataset )

ndim = extractor.featureDimension();
ndata = dataset.getSize();

feature = zeros(ndim,ndata);

parfor i=1:ndata
    [parent,name,~] = fileparts( fullfile(pathsave,dataset.getRawName(i)));
    filename = fullfile(parent,[name '.mat']);
    [encoded,loc] = loaddata(filename);
    
    feature(:,i) = extractor.extractFromEncoded(encoded,loc,extractor.mEncoder.codeDimension());
end

end


function [encoded,loc] = loaddata(filename)
d = load(filename);
encoded = d.encoded;
loc = d.loc;
end
