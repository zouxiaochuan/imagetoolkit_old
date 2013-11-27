function [ gfilters ] = gaborFilters( nSize,useBuffer,nStage,nOrientation)
%Generate gabor filter
persistent listGfilters listGfiltersSize;
if nargin<2
    useBuffer = false;
end
if nargin<3
    nStage = 4;
end
if nargin<4
    nOrientation=6;
end
partition = [nStage,nOrientation];
freqInterval = [0.05 0.4];
nX=nSize(1);
nY=nSize(2);
gfilters=[];


if (~isempty(listGfiltersSize))&&(useBuffer)
    iGfilters = (listGfiltersSize(:,1)==nX&listGfiltersSize(:,2)==nY);
    if ~isempty(listGfiltersSize(iGfilters))
        gfilters = listGfilters{iGfilters};
    end
end

if ~isempty(gfilters)
    return;
end

nStage=partition(1);
nOrientation=partition(2);
nGfilters=nStage*nOrientation;

gfilters=zeros(nX,nY,nGfilters);

indGfilters=1;
for indStage = 1:nStage
    for indOrientation = 1:nOrientation
        gfilter=gaborFilter(nSize,[indStage,indOrientation],partition,freqInterval);
        gfilter=fft2(gfilter);
        %gfilter=dct2(gfilter);
        gfilter(1,1)=0;
        gfilters(:,:,indGfilters)=gfilter;
        indGfilters=indGfilters+1;
    end
end

if useBuffer
    listGfiltersSize=[listGfiltersSize;nX,nY];
    listGfilters{length(listGfilters)+1}=gfilters;
end

end

