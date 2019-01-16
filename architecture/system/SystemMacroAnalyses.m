classdef SystemMacroAnalyses < System
    %SystemMacroAnalyses deriva da System e contiene i metodi per
    %l'analisi di secondo livello
    
   
       methods (Access = public) 
        function train2level(this, referenceSignal, trainingSignals)
            
            for i = 1:length(this.filters)
                this.filters{i}.idealSignal = referenceSignal(i,:);
                this.trainFilter2level(this.filters{i}, i, trainingSignals);
                this.filters{i}.computePrototype();
                
            end
            
        end
        
        function trainFilter2level(this, filter, nightPeriod, trainingSignals)
           
            prototypeFromStage = filter.getPrototypeFromStage();
            
            % set title
            optimInfo.title = cell2mat(strcat({'2 level: Training filter for period '}, num2str(nightPeriod)));

            % specify objective function
            objFctHandle = @fitness; % will be the similarity check fitness

            % define parameter names, ranges and quantization:

            % 1. column: parameter names
            % 2. column: parameter ranges
            % 3. column: parameter quantizations (0 for no quantization)
            % 4. column: initial values (optional)
            
            bounds = filter.getBounds();
            paramNames = filter.getParamsNames();
            paramDefCell = cell(size(bounds,1), 3);
            for i = 1:size(paramDefCell, 1)
                paramDefCell{i,1} = paramNames{i};
                paramDefCell{i,2} = bounds(i,:);
                paramDefCell{i,3} = 0.001;
            end
            
            % set initial parameter values in struct objFctParams 
            objFctParams = [];

            % set single additional function parameter (empty cell array if not needed)
            inputData = trainingSignals{nightPeriod}{1};
            otherInputData = trainingSignals{nightPeriod}{2};
            objFctSettings = {{filter, prototypeFromStage, inputData, otherInputData}};

            % get default DE parameters
            DEParams = getdefaultparams;
            
            % 0 (false) - generate the initial params in the middle of each
            % parameter bound
            % 1 (true) - use initial values for params taken from
            % objFctParams or paramDefCell (in this order of precedence)
            % 2 - like 1, but add some random noise to the first 20% of the
            % initial population
            DEParams.useInitParams = false;

            % set number of population members (often 10*D is suggested) 
            DEParams.NP = 10 * size(paramDefCell, 1);

            % do not use slave process here
            %DEParams.feedSlaveProc = 1;
            %DEParams.slaveFileDir = 'parallel';

            % set times (stop conditions)
            DEParams.maxiter  = 20;%50;
            DEParams.maxtime  = Inf; % in seconds
            DEParams.maxclock = []; % Time when to finish optimization. Set to empty for no end time.

            % set display options
            DEParams.infoIterations = 10;
            DEParams.infoPeriod     = 10; % in seconds
            DEParams.displayResults = false;
            DEParams.playSound      = false;

            % optimization looks for the minumum (true) or maximum (false)
            DEParams.minimizeValue = true;
            
            DEParams.validChkHandle = @parametersValidation;
            %DEParams.saveHistory = false;

            % do not send E-mails
            emailParams = [];

            
            
            clc;
        
            filenameHistory = strcat('trainingInfoSignalNightPeriod_', num2str(nightPeriod), '.txt');
            diary(filenameHistory);
        
            diary on;
            
            
            % set random state in order to always use the same population members here
            %setrandomseed(204);
            setrandomseed(168);


            % start differential evolution
            [bestmem, bestval, bestFctParams, nrOfIterations, resultFileName] = differentialevolution(...
                DEParams, paramDefCell, objFctHandle, objFctSettings, objFctParams, emailParams, optimInfo); %#ok

            disp(' ');
            disp('Best parameter set returned by function differentialevolution:');
            disp(bestFctParams);
            %{
            disp(' ');
            disp('# of training signals used');
            disp(size(inputData,1));
            %}
            
            diary off;
            
            filter.setParams(bestmem);
            filter.computePrototype();
        end
        
    end
    
end

