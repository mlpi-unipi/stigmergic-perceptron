%% Generate archetypes for 3 levels of clumping
signalLength = 36;
numArchetypes = 7;
levelHigh = 1;
levelMed = 0.5;
levelLow = 0;
archetypes = zeros(numArchetypes,signalLength);
archetypesNames = {'asleep', 'flow', 'rush', 'quick', 'awakening', 'rise', 'chill', 'falling', 'peak', 'break'}';

% Asleep
archetypes(1,:)=levelLow;

% Quick
archetypes(2,1:15) = levelLow;
archetypes(2,16:21) = levelMed;
archetypes(2,22:36) = levelLow;

%reccurrent low
archetypes(3,1:4) = levelLow;
archetypes(3,5:8) = levelMed;
archetypes(3,9:12) = levelLow;
archetypes(3,13:16) = levelMed;
archetypes(3,17:20) = levelLow;
archetypes(3,21:24) = levelMed;
archetypes(3,25:28) = levelLow;
archetypes(3,29:32) = levelMed;
archetypes(3,33:36) = levelLow;

% Flow
archetypes(4,:)=levelMed;

% Quick
archetypes(5,1:15) = levelLow;
archetypes(5,16:21) = levelHigh;
archetypes(5,22:36) = levelLow;

%reccurrent low
archetypes(6,1:4) = levelMed;
archetypes(6,5:8) = levelHigh;
archetypes(6,9:12) = levelMed;
archetypes(6,13:16) = levelHigh;
archetypes(6,17:20) = levelMed;
archetypes(6,21:24) = levelHigh;
archetypes(6,25:28) = levelMed;
archetypes(6,29:32) = levelHigh;
archetypes(6,33:36) = levelMed;

% Rush
archetypes(7,:)=levelHigh;











%% Save generated archetypes
%save archetypes3.mat 
%save archetypesNames3.mat

%% Plot to check correctness
for i=1:numArchetypes
    plot(archetypes(i,:))
    ylim([-0.1 1.1])
    pause
end