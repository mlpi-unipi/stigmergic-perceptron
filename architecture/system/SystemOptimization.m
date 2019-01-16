classdef SystemOptimization < System
    %SystemOptimization derives from System and contains the optimization
    %methods for the delta parameter (global pre-training)

   
   methods (Access = public) 
        function this = SystemOptimization(basePath)
            this = this@System(basePath);
            
            if exist(strcat(basePath,'/optimizationResult/Global')) == 0
                mkdir(strcat(basePath,'/optimizationResult/Global'));
            end    
            this.basePath = strcat(basePath,'/optimizationResult/Global'); 
        end
        function globalTrain(this, basicSignals, numShift, numTrials)

			numFilters = length(this.filters);     
			for i = 1:numFilters
				this.filters{i}.idealSignal = basicSignals(i, :);
			end

			% create a class array of shifted signals
			%numShift = 2;                           % numero dei valori di shift da utilizzare
			numSignalsPerClass = 1 + numShift*2;    % 1 segnale base + numShift*2(1 segnale shiftato a destra e 1 a sinistra) 


			%compute ideal similarity of signals
			idealSimilarity = this.computeIdealSimilarity(numFilters, numSignalsPerClass);
			idealSimMat = cell2mat(idealSimilarity);

			%compute weight of similarity
			weightSimilarity = this.computeWeightOfSimilarity(numFilters, numSignalsPerClass);
			weightSimMat = cell2mat(weightSimilarity);

			% set title
			optimInfo.title = 'Found Optimum Delta Interval';

			% specify objective function
			objFctHandle = @optimizeDeltaInterval; % will be the similarity check fitness

			% define parameter names, ranges and quantization:

			% 1. column: parameter names
			% 2. column: parameter ranges
			% 3. column: parameter quantizations (0 for no quantization)
			% 4. column: initial values (optional)

			bounds = cell([numFilters 1]);
			paramNames = cell([numFilters 1]);
			paramDefCell = cell((size(this.filters{1}.getBounds(), 1)*numFilters), 3);


			for i = 1:numFilters

				bounds{i} = this.filters{i}.getBounds();
				paramNames{i} = this.filters{i}.getParamsNames();

				for j = 1:size(bounds{i},1)
					paramNames{i}(j) = strcat((paramNames{i}(j)), '_fiter', num2str(i));
				end
			end

			k=1;

			while(k<=size(paramDefCell,1))
				for i = 1:numFilters
					for h = 1:size(bounds{i})
						paramDefCell{k,1} = paramNames{i}{h};
						paramDefCell{k,2} = bounds{i}(h,:);
						paramDefCell{k,3} = 0.01;%0.01

						k = k+1;
					end

				end

			end


			% set initial parameter values in struct objFctParams 
			objFctParams = [];

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
			%
			%
			%
			% do not use slave process here
			%{
			DEParams.feedSlaveProc = 1;
			DEParams.slaveFileDir = 'parallel';
			%}
			%
			%
			%


			% set times (stop conditions)
			DEParams.maxiter  = 30; %30
            DEParams.strategy = 3;
            DEParams.CR = 0.8;
            DEParams.F = 0.7;

			DEParams.maxtime  = Inf; % in seconds
			DEParams.maxclock = []; % Time when to finish optimization. Set to empty for no end time.

			% set display options
			DEParams.infoIterations = 10;
			DEParams.infoPeriod     = 10; % in seconds
			DEParams.displayResults = false;
			DEParams.playSound      = false;

			% optimization looks for the minumum (true) or maximum (false)
			DEParams.minimizeValue = true;

			DEParams.validChkHandle = @parametersValidationDelta;
			%DEParams.saveHistory = false;

			% do not send E-mails
			emailParams = [];

			%
			%
			%
			%DEParams CR and F (da commentare se si usano i valori di default)
			%{
			DEParams.CR = 0.9;
			DEParams.F = 1.5;
			%}
			%
			%
			%

			% get random seeds for numTrials trials

			%numTrials = 5;
			randomSeeds = randi(1000, numTrials, 1);
			filenameHistory = cell([numTrials 1]);



			% do numTrials trials with a 'for' loop

			for i = 1:numTrials

				clc;

				filenameHistory{i} = sprintf(strcat(this.basePath,'/trialInfo_%d.txt'), i);
				diary(filenameHistory{i});

				diary on;

				% set random state in order to always use the same population members here
				setrandomseed(randomSeeds(i));

				trialStr = strcat('Trial number: ', num2str(i));
				disp(trialStr);
				randomSeedUsedStr = strcat('Random Seed Used: ', num2str(randomSeeds(i))); 
				disp(randomSeedUsedStr);


				% create shifted signals
				[classSignals, shift] = this.createShiftedSignalsClass(basicSignals, numShift);
				signals = cell2mat(classSignals);

				% set function settings
				objFctSettings = {{this.filters, signals, idealSimMat, weightSimMat}};


				% start differential evolution
				[bestmem, bestval, bestFctParams, nrOfIterations, resultFileName] = differentialevolution(...
					DEParams, paramDefCell, objFctHandle, objFctSettings, objFctParams, emailParams, optimInfo,'',strcat(this.basePath));

				disp(' ');
				disp('Best parameter set returned by function differentialevolution:');
				disp(bestFctParams);

				bestValStr = strcat('Best fitness value: ', num2str(bestval));
				disp(bestValStr);
				numIterStr = strcat('Num of iterations: ', num2str(nrOfIterations));
				disp(numIterStr);

				diary off;

				worksp = strcat(this.basePath,'/workspace_trial_', num2str(i), '.mat');
				save(worksp);
	
			end
    
        end   
        
        
        function idealSimilarity = computeIdealSimilarity(this, numFilters, numSignalsPerClass)
            % create a cell array numFilters*numFilters with 
            % idealSimilarity = 1
            % if signals are of the same class of filter
            % and idealSimilarity = 0
            % if signals are of a different class from filter

                idealSimilarity = cell([numFilters numFilters]);

                for i = 1:numFilters
                    for j = 1:numFilters

                        idealSimilarity{i,j} = zeros(numSignalsPerClass, 1);

                        if(i==j)
                            idealSimilarity{i,j} = ones(numSignalsPerClass, 1);
                        end

                    end
                end


            end

        
            function weightSimilarity = computeWeightOfSimilarity(this, numFilters, numSignalsPerClass)
                    % create a cell array numFilters*numFilters with 
                    % idealSimilarity = 1
                    % if signals are of the same class of filter
                    % and idealSimilarity = 0
                    % if signals are of a different class from filter

                        weightSimilarity = cell([numFilters numFilters]);

                        for i = 1:numFilters
                            for j = 1:numFilters

                                weightSimilarity{i,j} = zeros(numSignalsPerClass, 1) + 1/(numFilters-1);

                                if(i==j)
                                    weightSimilarity{i,j} = ones(numSignalsPerClass, 1);
                                end

                            end
                        end

            end
            
            
            % create cell array with shifted signals of +- 10%-15%

            function [classSignals, shift] = createShiftedSignalsClass(this, baseSignals, numShift)

                len = size(baseSignals, 1);
                classSignals = cell([len 1]);

                signalsLen = size(baseSignals, 2);
                minShiftPercent = floor(signalsLen / 100 * 10);
                maxShiftPercent = ceil(signalsLen / 100 * 15);


                shift = randi([minShiftPercent, maxShiftPercent], numShift, 1);


                for i = 1:len

                    classSignals{i} = baseSignals(i, :);

                    initValue = baseSignals(i,1);
                    endValue = baseSignals(i,end);
                    signalRightShifted = zeros(1, size(baseSignals,2));
                    signalLeftShifted = zeros(1, size(baseSignals,2));

                        for k = 1:length(shift)

                            signalRightShifted(1:shift(k)) = initValue;
                            signalRightShifted(shift(k)+1:end) = baseSignals(i, 1:(end-shift(k)));

                            signalLeftShifted(1:end-shift(k)) = baseSignals(i, shift(k)+1:end);
                            signalLeftShifted(end-shift(k)+1:end) = endValue;


                            classSignals{i} = [
                                classSignals{i};
                                signalRightShifted;
                                signalLeftShifted;
                                ];

                        end

                 end

            end
    



         
    end
    
end

