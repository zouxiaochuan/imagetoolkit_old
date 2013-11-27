classdef lmACodebookBuilder < handle
    %LMACODEBOOKBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function [codebook,obj] = buildFromFileMat(obj, path)
        end
        function [codebook,obj] = buildFromFileRaw(obj, path,extractor)
        end
        function [codebook,obj] = buildFromDataset(obj, dataset, extractor, sampleSize)
            numSamples = dataset.numSamples();
            numPerSample = ceil(sampleSize / numSamples);
            
            mats = cell(numSamples,1);
            parfor i=1:numSamples
                sample = dataset.getSample(i);
                
                if isempty(sample) || size(sample,1) < 10 || size(sample,2) < 10
                    continue;
                end
                
                [descriptors,~] = extractor.extractFromMat(sample);
                %numDesc = size(descriptors,2);
                
                idxnz = sum(descriptors~=0)~=0;
                
                descriptors = descriptors(:,idxnz);
                numDesc = size(descriptors,2);
                
                if numDesc > numPerSample
                    rperm = randperm(numDesc);
                    descriptors = descriptors(:,rperm(1:numPerSample));
                end
                mats{i} = descriptors;
            end
            feats = MergeMats(mats);
            
            codebook = obj.build(feats);
        end
    end
    
    methods(Abstract)
        [codebook,obj] = build(obj, data);
    end
    
end

