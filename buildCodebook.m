function [ codebook ] = buildCodebook( pathSift,sizeSample,numCode )

plog('load data ...');
filenames = dirRecursive(pathSift,'.mat');
plog(['load data complete, file num:' num2str(length(filenames))]);
numFile = length(filenames);

samplePerFile = ceil(sizeSample/numFile);
sizeSample = samplePerFile * numFile;

data =load(filenames{1});
nDim = size(data.descriptors,1);

sampleData = zeros(nDim,sizeSample);

ind = 1;
plog(['sizeSample:' num2str(sizeSample)]);
plog(['samplePerFile:' num2str(samplePerFile)]);
plog(['begin sample ...']);
for i=1:length(filenames)
    if ( mod(i,10000)==0)
        plog(['sample index:' num2str(i)]);
    end
    data = load(filenames{i});
    numPoint = size(data.descriptors,2);
    randseq = randperm(numPoint);
    sizeSeq = min(numPoint,samplePerFile);
    sampleData(:,ind:ind+sizeSeq-1) = data.descriptors(:,randseq(1:sizeSeq));
    ind = ind + sizeSeq;
end
plog(['sample data complete']);

[codebook,~] = vl_kmeans(double(sampleData),numCode,'verbose',...
    'MaxNumIterations',50,'Initialization','plusplus',...
    'Numrepetitions',1,'Algorithm','elkan');

%codebook = codebook';

end

