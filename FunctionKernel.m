classdef FunctionKernel
    %FUNCTIONKERNEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function [ cor ] = KernelLinear( x,y )
            cor = sum(x.*y);
        end
        function [ cor ] = KernelEuclid( x,y )
            cor = -sum((x-y).^2);
        end
        function [ cor ] = KernelX2( x,y )
            z = x+y;
            z(z==0)=1;
            cor = -sum((x-y).^2./z);
        end
        function [ cor ] = KernelMin( x,y )
            cor = sum(min(x,y));
        end
    end
    
end

