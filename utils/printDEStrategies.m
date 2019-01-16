%% Analyse fitnesses
%% Load fitness results
optimResult = cell(9,8);
strategyNames = {'1. /best/1/exp','2. /rand/1/exp','3. /rand-to-best/1/exp','4 /best/2/ex', ...
    '5. /rand/2/exp ','6. /best/1/bin','7. /rand/1/bin','8. /rand-to-best/1/bin','9. /best/2/bin'};
for j = 1:9
    folder = strcat('Fitness Genetico\Strategia ',int2str(j),'\');
    for i=1:8
        fileName = strcat(folder,'fitness_result_SARA-ZENBOOK_0',int2str(i),'.mat');
        file = load(fileName);
        optimResult{j,i} = file.optimResult.bestValueHistory;
    end
end

%% Plot results
c = distinguishable_colors(9);
for srf = 6%1:8
    figure
    hold on
    for i=1:9
        plot(optimResult{i,srf},'DisplayName',strategyNames{i},'Color',c(i,:));
    end
    legend('show')
    hold off
end

%% Load all the trials and extract average
optimResultFilter1 = cell(9,1);
optimResultFilter8 = cell(9,1);
averageFilter1 = zeros(9,29);
averageFilter8 = zeros(9,29);
strategyNames = {'1. /best/1/exp','2. /rand/1/exp','3. /rand-to-best/1/exp','4 /best/2/ex', ...
    '5. /rand/2/exp ','6. /best/1/bin','7. /rand/1/bin','8. /rand-to-best/1/bin','9. /best/2/bin'};
for j = 1:9
    folder = strcat('Fitness Genetico\Statistics - Filter 1\Strategia ',int2str(j),'\');
    folder8 = strcat('Fitness Genetico\Statistics - Filter 8\Strategia ',int2str(j),'\');
    for i = 1:3
        fileName = strcat(folder,'fitness_result_SARA-ZENBOOK_01',int2str(i),'.mat');
        fileName8 = strcat(folder8,'fitness_result_SARA-ZENBOOK_08',int2str(i),'.mat');
        file = load(fileName);
        optimResultFilter1{j,1}(i,:) = file.optimResult.bestValueHistory;
        file8 = load(fileName8);
        optimResultFilter8{j,1}(i,:) = file8.optimResult.bestValueHistory;
    end
    averageFilter1(j,:) =  mean(optimResultFilter1{j,1},1);
    averageFilter8(j,:) =  mean(optimResultFilter8{j,1},1);    
end


%% Plot average results
c = distinguishable_colors(9);
strategyNames = {'1. /best/1/exp','2. /rand/1/exp','3. /rand-to-best/1/exp','4 /best/2/ex', ...
    '5. /rand/2/exp ','6. /best/1/bin','7. /rand/1/bin','8. /rand-to-best/1/bin','9. /best/2/bin'};

figure
hold on
for i=1:9
    plot(averageFilter1(i,:),'DisplayName',strategyNames{i},'Color',c(i,:));    
end
legend('show')
hold off

figure
hold on
for i=1:9
    plot(averageFilter8(i,:),'DisplayName',strategyNames{i},'Color',c(i,:));
end
legend('show')
hold off



