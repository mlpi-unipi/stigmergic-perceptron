%%  Add paths to source 

clear
addpath(genpath('architecture'));
addpath(genpath('utils'));

basePath = 'chartPattern';
addpath(genpath(basePath));

%% Display and order archetypes
%orderArchetypes(basePath);

%%  Generate training for archetypes
%syntheticSignals(basePath, 1, 10, 0.1, 10);

%%  Optimize delta
%optimizeDeltaBoundaries(basePath, 2, 5);

%%  Normalizes signal and divides it in windows
%raw2windows(basePath, 2);

%%  Train and compute the archeypal behavior assessment
%firstLevelPerceptronDoubleC(basePath, true, false); %just training

%% First level run
%firstLevelPerceptronDoubleC(basePath, false, true); %no training, just compute

%clear