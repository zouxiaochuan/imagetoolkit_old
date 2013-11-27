clear all;
%pathCommon = '/home/lamda/Storage_SV51/zouxc/common/matlab';
%pathVlfeat = '/tmp/zouxc/vlfeat-0.9.14';
%pathData = '/home/lamda/Storage_SV51/zouxc/work/dataset/caltech_101';
%pathSift = '/home/lamda/Storage_SV51/zouxc/work/dataset/caltech_101/dsift';

pathHome = fullfile('..','..','..');
pathCommon = fullfile(pathHome,'common','matlab');
pathData = fullfile(pathHome,'work','dataset','caltech_256');
pathSave = fullfile(pathHome,'work','dataset','caltech_256','dsift60');

addpath(pathCommon);

%run(fullfile(pathVlfeat,'toolbox','vl_setup'));

patchsize = 80;
step = 15;
maxsize = 400;

extractor = lmExtractorDSIFT(patchsize,step,maxsize);
extractLocalDescriptor(extractor, pathData,pathSave,maxsize,patchsize,step);

clear all;