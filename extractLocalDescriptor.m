function extractLocalDescriptor( extractor, pathData,pathSave,maxsize,patchsize,step)

maxSize = maxsize;

dataset = lmDatasetImage('test',pathData);
%extractor = lmExtractorDHOG(patchsize,step,maxSize,9);

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
    [descriptors,locations] = extractor.extractFromMat(img);
    cost = toc;
    
    pathCate = fullfile(pathSave,nameCate);
    
    if ~exist(pathCate,'dir')
        mkdir(pathCate);
        pause(5);
    end
    
    [~,rawname,~] = fileparts(nameImage);
    pathFile = fullfile(pathCate,rawname);
    savefile(pathFile,descriptors,locations,height,width,cost);
end


end

function savefile(pathFile,descriptors,locations,height,width,cost)
save(pathFile,'descriptors','locations','height','width','cost');
end

