clear all;
pathCommon = '/home/lamda/Storage_SV51/zouxc/common/matlab';
pathVlfeat = '/tmp/zouxc/vlfeat-0.9.14';
pathData = '/home/lamda/Storage_SV51/zouxc/work/dataset/caltech_101';
pathSift = '/home/lamda/Storage_SV51/zouxc/work/dataset/caltech_101/dsift';

addpath(pathCommon);

run(fullfile(pathVlfeat,'toolbox','vl_setup'));

extractDSIFT(pathVlfeat,pathData,pathSift,400,16,4);

clear all;