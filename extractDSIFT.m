function extractDSIFT( pathVlfeat,pathData,pathSIFT,maxsize,patchsize,step)

run(fullfile(pathVlfeat,'toolbox','vl_setup'));

maxSize = maxsize;

dataset = lmDatasetImage('test',pathData);
extractorDSIFT = lmExtractorDSIFT(patchsize,step);

parfor i=1:length(dataset.mFilenames)
    nameCate = dataset.mFilenames{i,1};
    nameImage = dataset.mFilenames{i,2};
    
    pathImage = fullfile(dataset.mPathImage,nameCate,nameImage);
    
    img = imread(pathImage);
    if size(img,3) > 1
        img = rgb2gray(img);
    end
    
    height = size(img,1);
    width = size(img,2);
    
    maxS = max(height,width);
    
    if maxS > maxSize
        img = imresize(img,maxSize/maxS);
    end
    
    height = size(img,1);
    width = size(img,2);
    
    tic;
    [descriptors,locations] = extractorDSIFT.extractFromMat(img);
    cost = toc;
    
    pathSIFTCate = fullfile(pathSIFT,nameCate);
    
    if ~exist(pathSIFTCate,'dir')
        mkdir(pathSIFTCate);
        pause(5);
    end
    
    [~,rawname,~] = fileparts(nameImage);
    pathSIFTFile = fullfile(pathSIFTCate,rawname);
    savefile(pathSIFTFile,descriptors,locations,height,width,cost);
end


end

function savefile(pathSIFTFile,descriptors,locations,height,width,cost)
save(pathSIFTFile,'descriptors','locations','height','width','cost');
end

