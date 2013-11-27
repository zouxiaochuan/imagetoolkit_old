function [ gfilter ] = gaborFilter( nSize,index,partition,freqInterval )
%generate one gabor filter
nX=nSize(1);
nY=nSize(2);

indStage=index(1);
indOrientation=index(2);

nStage=partition(1);
nOrientation=partition(2);

freqLow = freqInterval(1);
freqUp  = freqInterval(2);

% computer ratio a for generating wavelets
base = freqUp/freqLow;
C = zeros(1,nStage);
C(1) = 1;
C(nStage) = -base;
P = abs(roots(C));
a = P(1);
% computer best variance of gaussian envelope
u0 = freqUp/(a^(nStage-indStage));
Uvar = ((a-1)*u0)/((a+1)*sqrt(2*log(2)));
z = -2*log(2)*Uvar^2/u0;
Vvar = tan(pi/(2*nOrientation))*(u0+z)/sqrt(2*log(2)-z*z/(Uvar^2));
%%%%
j = sqrt(-1);
%%%%
t1 = cos(pi/nOrientation*(indOrientation-1));
t2 = sin(pi/nOrientation*(indOrientation-1));
sideX=nX/2 - 0.5;
sideY=nY/2 - 0.5;
Xvar = 1/(2*pi*Uvar);
Yvar = 1/(2*pi*Vvar);
coef = 1/(2*pi*Xvar*Yvar);
part1=a^(nStage-indStage)*coef;
x=(-sideX:1:sideX)';
y=(-sideY:1:sideY);
x2=x*ones(1,length(y));
y2=ones(length(x),1)*y;
XX=x2*t1+y2*t2;
YY=-x2*t2+y2*t1;
part2=exp(-0.5*((XX.^2)/(Xvar^2)+(YY.^2)/(Yvar^2)));
part2=part1*part2;
part3=2*pi*u0*XX;
Gr=part2.*cos(part3);
Gi=part2.*sin(part3);

gfilter = Gr + j*Gi;

end
