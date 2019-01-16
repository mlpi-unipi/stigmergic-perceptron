function [ normalizedData ] = normalizeChunks(data, chunkLength)
    signalEnd = (floor(length(data)/chunkLength)+2)*chunkLength;
    starts = [1,289:289:signalEnd-chunkLength]
    ends = 288:289:signalEnd
    signal = zeros(1,ends(end));
    signal(1,1:length(data)) = data;
    normalizedData = zeros(1,ends(end));
    for i=1:length(ends)
        normalizedData(:, starts(i):ends(i)) = normalize01(signal(:,starts(i):ends(i)));
    end
end