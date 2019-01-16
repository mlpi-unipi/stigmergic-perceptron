function printSuperimposedSignals( basePath, indexlist, type)
%PRINTSUPERIMPOSEDSIGNALS Print as superimposed the signals in the
%indexlist 
% indexlist -> horizzontal array (es. [1 2 3])
% type can be 
%   'raw' -> take from rawSignals.mat
%   'stigmergicOutput' -> take from output.mat
    %%
    %----------LOADING----------%
    if strcmp('raw', type)
        signals = load([basePath, '/rawSignals.mat']);
        signals = signals.result;
    elseif strcmp('stigmergicOutput', type)
        signals = load([basePath, '/output.mat']);
        signals = signals.signals;
    else
        error('wrong parameter');
    end
    
    
    
    %%
    %plot(signals(i, :));
    hold on;
    for i = 1:size(indexlist, 2)
        if strcmp('raw', type)
            plot(normalize01(signals(indexlist(i), :)));
        else
           plot(signals{indexlist(i)}); 
        end
    end
    hold off;

end

