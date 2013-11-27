pathHome = fullfile('..','..','..');
pathCommon = fullfile(pathHome,'common','matlab');

pathVlfeat = fullfile(pathHome,'lib','vlfeat-0.9.14');
numCode = 2000;
sizeSample = 10000*1000;
pathDataset = fullfile(pathHome,'work','dataset','caltech_256');
pathData = fullfile(pathDataset,'dsift60');
pathCodebook = fullfile(pathDataset,'codebook','dsift60_vq1000w2000');

run( fullfile(pathVlfeat,'toolbox','vl_setup'));
addpath(pathCommon);

codebook = buildCodebook(pathData,sizeSample,numCode);

save(pathCodebook, 'codebook');

clear all;
