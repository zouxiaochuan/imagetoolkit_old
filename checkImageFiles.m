function no = checkImageFiles( pathData )
%CHECKIMAGEFILES Summary of this function goes here
%   Detailed explanation goes here
dataset = lmDatasetImage('test',pathData);

no = 0;
parfor i=1:length(dataset.filenames)
    nameCate = dataset.filenames{i,1};
    nameImage = dataset.filenames{i,2};
    
    pathImage = fullfile(dataset.pathImage,nameCate,nameImage);
    
    try
        img = imread(pathImage);
    catch e
        delete(pathImage);
        no=no+1;
    end
end

fprintf(['delete file num: ' num2str(no)]);

delete([dataset.pathLabel '.mat']);
end

