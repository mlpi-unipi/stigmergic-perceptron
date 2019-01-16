%% Generate archetypes for 3 levels of clumping
signalLength = 24;
numArchetypes = 10;
levelHigh = 1;
levelMed = 0.5;
levelLow = 0;
archetypes = zeros(numArchetypes,signalLength);
archetypesNames = {'asleep', 'flow', 'rush', 'quick', 'awakening', 'rise', 'chill', 'falling', 'peak', 'break'}';

% Asleep
archetypes(1,:)=levelLow;

% Flow
archetypes(2,:)=levelMed;

% Rush
archetypes(3,:)=levelHigh;

% Quick
archetypes(4,1:signalLength/2) = levelLow;
archetypes(4,signalLength/2+1:end) = levelHigh;

% Awakening
archetypes(5,1:signalLength/2) = levelLow;
archetypes(5,signalLength/2+1:end) = levelMed;

% Rise
archetypes(6,1:signalLength/2) = levelMed;
archetypes(6,signalLength/2+1:end) = levelHigh;

% Chill
archetypes(7,1:signalLength/2) = levelHigh;
archetypes(7,signalLength/2+1:end) = levelMed;

% Falling
archetypes(8,1:signalLength/2) = levelMed;
archetypes(8,signalLength/2+1:end) = levelLow;

% Peak
archetypes(9,1:signalLength/3) = levelMed;
archetypes(9,signalLength/3+1:signalLength/3*2) = levelHigh;
archetypes(9,signalLength/3*2+1:end) = levelMed;

% Break
archetypes(10,1:signalLength/3) = levelHigh;
archetypes(10,signalLength/3+1:signalLength/3*2) = levelMed;
archetypes(10,signalLength/3*2+1:end) = levelHigh;

%% Save generated archetypes
save archetypes3.mat 
save archetypesNames3.mat

%% Plot to check correctness
for i=1:numArchetypes
    plot(archetypes(i,:))
    ylim([0 1])
    pause
end