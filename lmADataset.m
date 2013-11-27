classdef lmADataset < handle
    
    properties
        mLabels
    end
    
    methods
        function num = numSamples(obj)
            num = length(obj.mLabels);
        end
    end
    
    methods(Abstract)
        sample = getSample(obj,idx)
        
        rawname = getRawName(obj,idx)
    end
    
end

