classdef lmDetectorUoC < lmADetector
    %LMDETECTORUOC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mModel;
        mThresh;
    end
    
    methods
        function obj = lmDetectorUoC(model,thresh)
            obj.mModel = model;
            obj.mThresh = thresh;
        end
        
        function [rects,scores] = detect(obj,im)
            boxes = process(im,obj.mModel,obj.mThresh);
            numBox = size(boxes,1);
            
            rects = zeros(4,numBox);
            scores = zeros(numBox,1);
            
            for i=1:numBox
                rects(1,i) = ceil(boxes(i,1));
                rects(2,i) = ceil(boxes(i,2));
                rects(3,i) = ceil(boxes(i,3)-boxes(i,1));
                rects(4,i) = ceil(boxes(i,4)-boxes(i,2));
                scores(i) = boxes(i,5);
            end
        end
    end
    
end

