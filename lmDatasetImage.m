classdef lmDatasetImage < lmADataset
    
    properties
        mDescription = ' ';
        mPathRoot = ' ';
        mPathImage = ' ';
        mPathLabel = ' ';
        
        %mLabels = [];
        mLabelNames = [];
        mFilenames = cell(0);
    end
    properties (Constant)
        exts = {'.jpg','.jpeg','.png'};
    end
    
    methods
        %%
        function o = lmDatasetImage(desc, filepath)
            o.mDescription = desc;
            o.mPathRoot = filepath;
            o.mPathImage = fullfile(o.mPathRoot,'images');
            o.mPathLabel = fullfile(o.mPathRoot,'label');
            
            %addpath('common');
            o.init();
        end
        
        function sample = getSample(obj, idx)
            sample = imread(obj.getfullfilename(idx));
        end
        
        function rawname = getRawName(obj,idx)
            rawname = fullfile(obj.mFilenames{idx,1},obj.mFilenames{idx,2});
        end
        
        function filename = getfullfilename(obj, i)
            filename = fullfile(obj.mPathImage, obj.mFilenames{i,1}, obj.mFilenames{i,2});
        end
        function s = getSize(obj)
            s = size(obj.mFilenames,1);
        end
        %%
        function obj = init(obj)
            if exist([obj.mPathLabel '.mat'],'file')
                data = load(obj.mPathLabel);
                obj.mLabels = data.labels;
                obj.mFilenames = data.filenames;
                if isfield(data,'labelNames')
                    obj.mLabelNames = data.labelNames;
                end
            else
                
                obj.mFilenames = obj.getFilenames( obj.mPathImage, obj.exts);
                [obj.mLabels, obj.mLabelNames] = obj.getLabels(obj.mFilenames);
                
                labels = obj.mLabels;
                filenames = obj.mFilenames;
                labelNames = obj.mLabelNames;
                save(obj.mPathLabel,'labels','labelNames', 'filenames');
            end
        end
        function [filenames, obj] = getFilenames(obj, root, exts)
            filenames = getFilenames(root, exts);
        end
        function [labels, labelNames, obj] = getLabels(obj, filenames)
            labelNames = unique(filenames(:,1));
            [~,labels] = ismember(filenames(:,1),labelNames);
        end
    end
    
end

