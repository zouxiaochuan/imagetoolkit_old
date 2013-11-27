classdef lmEncoderColor
    %LMENCODERCOLOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mEncoders;
    end
    
    methods
        function obj = lmEncoderColor(type, cb,param)
            obj.mEncoders = cell(3,1);
            ndim = size(cb.basis,1);
            ndimsub = ndim/3;
            
            for i=1:3
                scb.basis = cb.basis((i-1)*ndimsub+1:i*ndimsub,:);
                if ~isempty(param)
                    obj.mEncoders{i} = type(scb,param);
                else
                    obj.mEncoders{i} = type(scb);
                end
            end
        end
        
        function code = encode(obj,descriptors)
            cs = cell(3,1);
            ndim = size(descriptors,1);
            ndimsub = ndim/3;
            for i=1:3
                cs{i} = obj.mEncoders{i}.encode(descriptors((i-1)*ndimsub+1:i*ndimsub,:));
            end
            
            code = [cs{1};cs{2};cs{3}];
        end
        
        function numDim = codeDimension(OBJ)
            numDim = OBJ.mEncoders{1}.codeDimension() * 3;
        end
    end
    
end

