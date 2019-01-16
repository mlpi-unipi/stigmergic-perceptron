function syntheticSignals( basePath, correctionFactor, temporalShiftFactor, spatialShift, signalsPerClass )
%SYNTHETICSIGNALS Load the archetype in the basePath folder and generates 
%   training set and relative classification, storing them in the basePath folder
%   correctionFactor -> correction factor depending on the maximum normalized value the signal can assume (default = 1) 
%   temporalShiftFactor -> percentage of maximum temporal shift of base signals
%   spatialShift -> base signal spatial noise
%   signalsPerClass -> number of signals per class to generate

    %%
    %----------LOADING----------%
    %load archetypes
    archetypes = load([basePath, '/archetypes.mat']);
    archetypes = archetypes.archetypes;

    %load archetypes names
    archetypesNames = load([basePath, '/archetypesNames.mat']);
    archetypesNames = archetypesNames.archetypesNames;
    %%
    %----------FIXED SETTING----------%
    % number of samples per signal
    signalsLength = size(archetypes, 2);
    
    % computer the actual temporal shift from input percentage
    temporalShift = round(signalsLength/100*temporalShiftFactor);
    
    % PNG image resolution
    resolution = '-r150';

    % Set image format
    format = '-dpng';

    %%
    %----------CORE----------%
    %----------GENERATE TRAINING SIGNAL BASE----------%

    % Init empty (vertical) cell array considering also mirrored signals (*2)
    trainingSignals = cell(size(archetypes, 1), 1); %multiply by two if mirrored archetypes are needed
    % For each signal prepare its training signals
    for k = 1:size(archetypes, 1)
        trainingSignals{k} = zeros(signalsPerClass, signalsLength);
        for j = 1:signalsPerClass
            signal = prepareSignal(archetypes(k, :), signalsLength, correctionFactor, spatialShift, temporalShift);
            trainingSignals{k}(j,:) = signal;
        end
        
        % create mirrored signals
        %trainingSignals{ k + size(archetypes, 1)} = 1 - [trainingSignals{k}];
        
        % Generate and save plots
        for j = 1:size(trainingSignals{k}, 1) % equal to for j = 1:signalsPerClass
            set(gcf, 'name', [archetypesNames{k} num2str(j)]);
            plot(trainingSignals{k}(j,:));
            title([archetypesNames{k} num2str(j)]);
            ylim([0 1]);
            folder = strcat(basePath, '/archetypesGraph/',archetypesNames{k}, '/');
            if ~exist(folder, 'dir')
                mkdir(folder);
            end
            print(strcat(folder, archetypesNames{k}, '_', num2str(j)), format, resolution);
        end
        
        shiftedSignal = trainingSignals{k};
        save(strcat(folder, archetypesNames{k}, 'trainingSignals.mat'), 'shiftedSignal');

    end

    save([basePath '/training.mat'], 'trainingSignals');
    close(1);

    %----------GENERATE CLASSIFICATION----------%
    trainingClassification = zeros(size(trainingSignals, 1), signalsPerClass);
    for i = 1:size(trainingClassification, 1)
        trainingClassification(i, :) = i;
    end
    save([basePath '/trainingClassification.mat'], 'trainingClassification');

    clear;
    clc;
end