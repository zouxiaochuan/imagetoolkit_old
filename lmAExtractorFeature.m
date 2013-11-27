classdef lmAExtractorFeature < handle
    
    
    %%
    properties
        % Properties and default setting
        mName='NoName';
        mDescription='Detail description of the method goes here';
    end
    
    methods
        %%
        % construction function of base class
        function s = lmAExtractorFeature(name,description)
            s.mName=name;
            s.mDescription=description;
        end
        
        %%
        function [featureVec,obj]=extractFromFile(obj, imfilename,varargin)
            im = imread(imfilename);
            [featureVec,obj] = extractFromMat(obj,im,varargin);
        end
        
        function [features,cost,obj]=extractFromDataset(obj,dataset)
            nDim = obj.featureDimension();
            if ( nDim > 0)
                img = dataset.getSample(1);
                fea = obj.extractFromMat(img);
                feaType = class(fea);
                features = zeros(nDim, length(dataset.mLabels), feaType);
            end
            cost = zeros(1,length(dataset.mLabels));
            parfor i=1:length(dataset.mLabels)
                img = dataset.getSample(i);
                tic;
                features(:,i) = obj.extractFromMat(img);
                cost(i) = toc;
            end
        end
        
        function [features,cost,obj]=extractFromDatasetSparse2(obj,dataset)
            numSample = length(dataset.mLabels);
            
            sizeBuf = 5000;
            nDim = obj.featureDimension();
            if ( nDim > 0)
                img = dataset.getSample(1);
                fea = obj.extractFromMat(img);
                feaType = class(fea);
            end
            
            numBlock = ceil(numSample/sizeBuf);
            rowIndices = cell(1,numBlock);
            colIndices = cell(1,numBlock);
            vals = cell(1,numBlock);
            
            feaIndex = 1;
            blockIndex = 1;
            
            cost = zeros(numSample,1);
            while feaIndex <= numSample
                nextSize = min(sizeBuf,numSample-feaIndex+1);
                
                plog(['extract index: ' num2str(feaIndex)]);
                
                feaBuf = zeros(nDim, nextSize, feaType);
                bcost = zeros(nextSize,1);
                parfor i=1:nextSize
                    img = dataset.getSample(i+feaIndex-1);
                    tic;
                    feaBuf(:,i)= obj.extractFromMat(img);
                    bcost(i) = toc;
                end
                
                cost(feaIndex:feaIndex+nextSize-1) = bcost;
                [brid,bcid,bval] = find(feaBuf);
                bcid = bcid + feaIndex - 1;
                brid = brid(:);
                bcid = bcid(:);
                bval = bval(:);
                
                rowIndices{blockIndex} = brid';
                colIndices{blockIndex} = bcid';
                vals{blockIndex} = bval';
                
                feaIndex = feaIndex + nextSize;
                blockIndex = blockIndex+1;
            end
            
            rowId = MergeMats(rowIndices);
            colId = MergeMats(colIndices);
            values = MergeMats(vals);
            
            clear('rowIndices','colIndices','vals');
            
            features = sparse(double(rowId),double(colId),double(values));
        end
        
        function [features,cost,obj]=extractFromDatasetSparse(obj,dataset)
            numSamples = length(dataset.mLabels);
            label = dataset.mLabels;
            sizeBuffer = 5000;
            i=1;
            [~,filename,~] = fileparts(tempname);
            if exist(filename,'file')
                delete(filename);
            end
            while i < numSamples
                plog(['process : ' num2str(i)]);
                iend = i+sizeBuffer - 1;
                iend = min(iend,numSamples);
                
                buffer = zeros(obj.featureDimension(),iend-i+1);
                bulabel = label(i:iend);
                parfor j=1:(iend-i+1)
                    buffer(:,j) = obj.extractFromMat(dataset.getSample(j+i-1));
                end
                svmwrite(filename,double(bulabel),buffer,'a');
                i=iend+1;
            end
            
            [~,features] = libsvmread(filename);
            features = features';
            delete(filename);
        end
    end
    % interface function to implement
    
    %%
    methods (Abstract)
        [featureVec,obj]=extractFromMat(obj,im,varargin)
        [numDim] = featureDimension(obj,im)
    end
end
