function mode = signalsMode( basePath )
%SIGNALSMODE Show histogram of all normalized raw signals under the given
%folder
    
    %%
    %----------LOADING----------%
    rawSignals = load([basePath, '/rawSignals.mat']);
    rawSignals = rawSignals.result;
    
    %rawSignalsNames = load([basePath, '/rawSignals.mat']);
    %rawSignalsNames = rawSignalsNames.textfile;
    
    %%
    %----------CORE----------%
    mode = zeros(size(rawSignals, 1), 1);
    for i = 1:size(rawSignals, 1)
        %cycle over signals
        sup = normalize01(rawSignals(i, :));
        
        mode(i, 1) = histogram(sup, 10);
        waitforbuttonpress;
    end 
end