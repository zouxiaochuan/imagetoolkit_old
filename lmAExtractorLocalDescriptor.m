classdef lmAExtractorLocalDescriptor < handle


%%
   properties
       % Properties and default setting
       mName='NoName'; 
       mDescription='No Description';
   end

   methods
       %%
       % construction function of base class
       function obj = lmAExtractorLocalDescriptor(name,description)
            obj.mName=name;
            obj.mDescription=description;
       end
       
      %%
       function [featureVec,obj]=extractFromFile(obj, imfilename,varargin)
           im = imread(imfilename);
           [featureVec,obj] = obj.extractFromMat(obj,im,varargin);
       end
   end
   % interface function to implement
   
   %%
   methods (Abstract)
       [descriptors,locations]=extractFromMat(obj,im,varargin)
       [numDim] = featureDimension(obj,im)
   end
end 
