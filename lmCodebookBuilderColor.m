classdef lmCodebookBuilderColor < lmACodebookBuilder
    
    properties
        mCodebookBuilder;
    end
    
    methods
        function obj = lmCodebookBuilderColor(cbbuilder)
            obj.mCodebookBuilder = cbbuilder;
        end
        
        function [codebook,obj] = build(obj,feats)
            cbs = cell(3,1);
            ndim = size(feats,1);
            ndimsub = ndim/3;
            
            for i=1:3
                cbs{i} = obj.mCodebookBuilder.build(feats((i-1)*ndimsub+1:i*ndimsub,:));
            end
            
            codebook.basis = [cbs{1}.basis;cbs{2}.basis;cbs{3}.basis];
        end
    end
    
end

