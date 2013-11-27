classdef lmDatasetImagenetBigCate < lmDatasetImage
    
    properties
    end
    
    methods
        function obj = lmDatasetImagenetBigCate( filepath)
            desc = 'Imagenet Big Category';
            obj@lmDatasetImage(desc,filepath);
        end
        
        function [labels, labelNames, obj] = getLabels(obj, filenames)
            namesNew = filenames(:,1);
            for i=1:length(namesNew)
                str = namesNew{i};
                namesNew{i} = str(1:4);
            end
            labelNames = unique(namesNew);
            [~,labels] = ismember(namesNew,labelNames);
        end       
    end
    
end

