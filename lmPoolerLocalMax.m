classdef lmPoolerLocalMax < lmAPooler
    %LMPOOLERLOCALMAX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mWnd = 0;
    end
    
    methods
        function obj = lmPoolerLocalMax(wnd)
            obj.mWnd = wnd;
        end
        
        function codeOut = pool(obj, codeIn, locations)
            [d,l] = localmaxpool(codeIn,locations,obj.mWnd);
            
            avgPooler = lmPoolerAvg();
            codeOut = avgPooler.pool(d);
        end
    end
    
end

