function [ outFeature ] = featureGabor( inImg )
%GABORFEATURE Summary of this function goes here
%   Detailed explanation goes here

[nX,nY]=size(inImg);
imgFft=fft2(inImg);
%imgFft=dct2(inImg);
gfilters=gaborFilters([nX,nY],false);

nGfilters = size(gfilters,3);
outFeature = zeros(1,nGfilters*2);

indF=1;
for i=1:nGfilters
    
    filterImg=abs(ifft2(imgFft.*gfilters(:,:,i)));
    %filterImg=abs(idct2(imgFft.*gfilters(:,:,i)));
    filterImg=filterImg(:);
    outFeature(indF)=mean(filterImg);
    indF=indF+1;
    outFeature(indF)=std(filterImg);
    indF=indF+1;
end

end

