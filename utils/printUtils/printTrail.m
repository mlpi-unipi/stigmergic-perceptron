function printTrail ( basePath )

    %%
    %----------LOADING----------%
    archetypes = load([basePath, '/archetypes.mat']);
    archetypes = archetypes.archetypes;
    
    archetypesNames = load([basePath, '/archetypesNames.mat']);
    archetypesNames = archetypesNames.archetypesNames;

    parameters = load([basePath, '/parametersBound.mat']);
    parameters = parameters.parametersBound;
        
    for i = 1:size(archetypes, 1)
        %
        %trail = Trailing(0.1, 0.1, min(archetypes(:))-0.3, max(archetypes(:))+0.3, 0.01, TrapezoidalMark(0.3, 0.3));
        %trail.setParams([0.4; 0.3]);
        
        trail = Trailing(parameters(i).deltaMin, ...
                parameters(i).deltaMax, ...
                parameters(i).domainMin, ...
                parameters(i).domainMax, ...
                parameters(i).domainResolution, ...
                TrapezoidalMark(parameters(i).epsilonMin, parameters(i).epsilonMax));
        trail.setParams([parameters(i).delta; parameters(i).epsilon]);
    
        %archetypes graph
        subplot(size(archetypes, 1), 2, (i*2)-1);
        stairs(archetypes(i, :));
        title(strcat(num2str(i), '-', archetypesNames(i, 1)));
        axis([0 size(archetypes, 2)+1 min(archetypes(:))-0.1 max(archetypes(:))+0.1]);
        
        %archetypes stigmergic space
        subplot(size(archetypes, 1), 2, (i*2));
        trail.reset();
        StigmergicTrail = trail.apply(archetypes(i, :));
        plot(normalize01(StigmergicTrail));
        title(strcat(num2str(i), '-', 'Trail-',archetypesNames(i, 1)));
        %axis([min(trail.domain(end, :)) max(trail.domain(end, :)) -0.1 1.1]);
        axis([0 size(trail.domain, 2) -0.01 1.1]);
    end
end