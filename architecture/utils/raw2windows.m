function raw2windows( basePath, overlappingFactor,varargin)
%RAW2WINDOWS Normalizes the signal and generates overlapping windows
%   overlappingFactor -> denominator of the fraction with which the windows
%   should be overlapped.
    
%%
    %----------LOADING----------%
    %load archetypes
    archetypes = load([basePath, '/archetypes.mat']);
    archetypes = archetypes.archetypes;
    
    rawSignals = load([basePath, '/rawSignals.mat']);
    rawSignals = rawSignals.result;
    
    %%
    %----------CORE----------%
    for i = 1:size(rawSignals, 1)
        rawSignals(i, :) = normalize01(rawSignals(i, :));
    end
    
    
%    if isempty(cell2mat(varargin{1}))        
        winLength = size(archetypes, 2);
%    else
%        winLength = varargin{1};
%    end    
    
    signals = cell(size(rawSignals, 1), 1);
    for i = 1:size(signals, 1)
        %signals{i, 1} = signal2windows(result(i, :), windowsLength, overlappingFactor);
        signals{i, 1} = signal2windows(rawSignals(i, :), winLength, overlappingFactor);
    end
    
    save([basePath, '/signals.mat'], 'signals');

    clear;
    clc;
end