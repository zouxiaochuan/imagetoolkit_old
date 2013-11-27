function [ filenames ] = getFilenames( root, exts )
%GETFILENAMES Summary of this function goes here
%   Detailed explanation goes here

dirCates = dir(root);
filenames = cell(0);

ind = 1;

for i=1:length(dirCates)
    dirCate = dirCates(i);
    if strcmp(dirCate.name,'.') || strcmp(dirCate.name,'..')
        continue;
    end
    pathCate = fullfile(root,dirCate.name);
    dirImages = dir(fullfile(pathCate));
    for j=1:length(dirImages)
        dirImage = dirImages(j);
        if strcmp(dirImage.name,'.') || strcmp(dirImage.name,'..')
            continue;
        end
        [~,~,ext] = fileparts(dirImage.name);
        if isempty(find(strcmpi(exts,ext),1))
            continue;
        end
        
        filenames(ind,:) = { dirCate.name, dirImage.name };
        
        ind = ind+1;
    end
end
end

