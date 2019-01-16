function printPerceptronOutput( basePath, showUser, save )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    %%
    if ~isa(showUser, 'logical')
        error('showUser must be a logical value');
    end
    if ~isa(save, 'logical')
        error('save must be a logical value');
    end
    
    %%
    if save
        folderBasePath = ['./', basePath, '/outputSignals'];
        if exist(folderBasePath) == 0
            mkdir(folderBasePath);
        else
            rmdir(folderBasePath,'s');
            mkdir(folderBasePath);
        end
    end
    
    %%
    %----------LOADING----------%
    inputSignals = load([basePath, '/outputTest.mat']);
    inputSignals = inputSignals.signals;
    
    signalsName = load([basePath, '/rawSignals.mat']);
    signalsName = signalsName.textfile;
    
    archetypes = load([basePath, '/archetypes.mat']);
    archetypes = archetypes.archetypes;

    %%
    for i = 1:size(inputSignals, 1)
        plot(inputSignals{i, 1});
        
        ylim([0 size(archetypes, 1)]);
        xlim([1 size(archetypes, 2)]);
        if iscell(signalsName)
            title(signalsName{i, 1});
        else
            title(num2str(i));
        end
        
        if save
            if iscell(signalsName)
                print([folderBasePath, '/', num2str(i), '-', signalsName{i, 1}], '-djpeg', '-r0');
            else
                print([folderBasePath, '/', num2str(i)], '-djpeg', '-r0');
            end
        end
        
        if showUser
            waitforbuttonpress
        end
    end
end

