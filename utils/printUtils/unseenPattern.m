function unseenPattern(basePath)
%UNSEENPATTERN Summary of this function goes here
%   Detailed explanation goes here

load([basePath,'/output.mat']);

parfor i=1:size(signalsOut,1)
    zeroOutputWindowIndex = find(~signalsOut{i,1}(1,:));
    for w=1:length(zeroOutputWindowIndex)
        inspectSignalWindow(basePath,i,zeroOutputWindowIndex(w),true);
    end
end

