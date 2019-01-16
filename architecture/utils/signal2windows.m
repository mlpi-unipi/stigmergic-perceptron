function [windowedSignal] = signal2windows(completeSignal, windowSize, shiftFactor)
%SIGNAL2WINDOWS Build partially overlapped time windows from the complete signal
%   completeSignal -> a signal as an horizontal array of double
%   windowSize -> size of the output window
%   shift -> set the overlapping factor as a fraction; if set to one no
%   overlapping, if set to 2 half wind is overlapped and so on

    shift = ceil(windowSize/shiftFactor); 
    
    indexes = bsxfun(@plus,(1:windowSize),(0:shift:length(completeSignal)-windowSize)');
    windowedSignal = completeSignal(indexes); % one window per row
end