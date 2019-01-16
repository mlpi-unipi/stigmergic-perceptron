%% Generate archetypes for 3 levels of clumping
signalLength = 30;
numArchetypes = 7;
levelHigh = 1;
levelMed = 0.5;
levelLow = 0;
archetypes = zeros(numArchetypes,signalLength);
archetypesNames = {'low', 'falling','increasing','medium','chill', 'peaking','high' }';

% Asleep
archetypes(1,:)=levelLow;

% Falling
archetypes(2,1:signalLength/2) = levelMed;
archetypes(2,signalLength/2+1:end) = levelLow;

% Awakening
archetypes(3,1:signalLength/2) = levelLow;
archetypes(3,signalLength/2+1:end) = levelMed;

% Flow
archetypes(4,:)=levelMed;

% Chill
archetypes(5,1:signalLength/2) = levelHigh;
archetypes(5,signalLength/2+1:end) = levelMed;

% Rise
archetypes(6,1:signalLength/2) = levelMed;
archetypes(6,signalLength/2+1:end) = levelHigh;

% Rush
archetypes(7,:)=levelHigh;









%% Save generated archetypes
save archetypes3.mat 
save archetypesNames3.mat

%% Plot to check correctness
for i=1:numArchetypes
    plot(archetypes(i,:))
    ylim([-0.1 1.1])
%    pause
end