clear all;

pathHome = fullfile('..','..','..');
pathCommon = fullfile(pathHome,'common','matlab');
pathVlfeat = fullfile(pathHome,'lib','vlfeat-0.9.14');

addpath(pathCommon);
addpath('common');
addpath(genpath('lib'));
run(fullfile(pathVlfeat,'toolbox','vl_setup'));

pathData = fullfile('..','..','dataset','imagenet_c');
descData = 'imagenet_c';
pathCodebook = fullfile(pathData,'codebook','codebook_vq1000w500.mat');
%pathSaveBoF = fullfile(pathData,'feature','fea_Gabor_4x6');
%pathSaveGabor = fullfile(pathData,'feature','fea_Gabor_4x6');
%pathSaveHOG = fullfile(pathData,'feature','fea_HOG_3x3');
%pathSaveHSV = fullfile(pathData,'feature','fea_HSVHist_8');
pathLLC = fullfile(pathData,'feature','fea_HOG_3x3');

data = load(pathCodebook);
codebook = data.codebook;
clear('data');

dataset = lmDatasetImage(descData, pathData);

extractorDSIFT = lmExtractorDSIFT(16,4,400);
%extractorBoF = lmExtractorBoF(codebook,extractorDSIFT);
%extractor = lmExtractorBoF(codebook,extractorDSIFT);
extractor = lmExtractorHOG(9,3,3,400);
[feature,cost] = extractor.extractFromDataset(dataset);

save(pathLLC, 'feature','cost','-v7.3');
