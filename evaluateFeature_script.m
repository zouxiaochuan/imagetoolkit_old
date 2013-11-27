clear all;

pathHome = fullfile('..','..','..');
pathCommon = fullfile(pathHome,'common','matlab');
pathDataset = fullfile(pathHome,'work','dataset','caltech_101');

pathWorking = fullfile(pathHome,'work','CBIR','GMPCA');

[~,hostname] = system('hostname');

if hostname(1) == 'b'
    pathVlfeat = '/tmp/zouxc/vlfeat-0.9.16';
    pathLibsvm = '/tmp/zouxc/libsvm-3.12/matlab';
    pathLiblinear = '/tmp/zouxc/liblinear-1.8/matlab';
elseif hostname(1) == 'c'
    pathLibsvm = fullfile(pathHome,'lib','libsvm-3.12','matlab');
    pathLiblinear = fullfile('~','LIB','liblinear-1.8','matlab');
    pathVlfeat = fullfile(pathHome,'lib','vlfeat-0.9.16');
else
    
end

if ~exist('vl_setup','file')
    run(fullfile(pathVlfeat,'toolbox','vl_setup'));
end

pathCodebook = fullfile(pathWorking,'CB1024.mat');

load(pathCodebook);

addpath(pathLiblinear);
addpath(pathCommon);

numTrain = 15;
numTest = 30;

classifier = lmClassifierKNN(7,@kernel_euclid);
classifierLiblinear = lmClassifierLiblinear();
dataset = lmDatasetImage('caltech 101',pathDataset);
%extractorLoc = lmExtractorDHOG(16,4,400,9);
extractorLoc = lmExtractorDSIFT(16,4,300);
encoder = lmEncoderBoFSoft(codebook,3);
extractor = lmExtractorBoF(encoder,extractorLoc);
%extractor = lmExtractorHOG(9,3,3,400);
%extractor = lmExtractorSSIFT(400);

[acc,accMap] = evaluateFeature(dataset,classifierLiblinear,extractor,numTrain,numTest,5,[]);

acc