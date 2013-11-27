classdef lmDatasetImageMat < lmADataset
    %LMDATASETIMAGEMAT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mFeatures;
        %mLabels;
        mRows;
        mCols;
        mChannels;
    end
    
    methods
        function OBJ = lmDatasetImageMat(labels,features,rows,cols,channels)
            OBJ.mLabels = labels;
            OBJ.mFeatures = features;
            
            OBJ.mRows = rows;
            OBJ.mCols = cols;
            OBJ.mChannels = channels;
        end
        
        function sample = getSample(OBJ,idx)
            sample = OBJ.mFeatures(:,idx);
            sample = reshape(sample,[OBJ.mRows,OBJ.mCols,OBJ.mChannels]);
        end
    end
    
end

