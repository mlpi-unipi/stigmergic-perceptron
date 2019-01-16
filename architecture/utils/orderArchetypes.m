function newOrder = orderArchetypes( basePath )
%ORDERARCHETYPES Allow to the user to set archtypes' order
%   Loads archetypes from basePath and plots the archetypes and their 
%   respective stigmergic traces to allow the user to order them with 
%   respect to their traces. 
%   The final order should be a sequence of numbers separated by semicolons
    
    %% 
    %----------LOADING----------%%
    archetypes = load([basePath, '/archetypes.mat']);
    archetypes = archetypes.archetypes;

    %load archetypes names
    archetypesNames = load([basePath, '/archetypesNames.mat']);
    archetypesNames = archetypesNames.archetypesNames;

    %%
    %----------INIT----------%
    go = true;
    %%
    %----------GET NEW ORDER----------%
    while go
        newOrder = testGui(archetypes, archetypesNames);
        newOrder = str2num(newOrder);
        disp(newOrder');
        %check validity
        if size(newOrder, 1) == size(archetypes, 1)
            %disp('Dimension matching');
            if size(newOrder, 1) == size(unique(newOrder), 1)
                %disp('No repeated numbers');
                go = false;
            else
                disp('Repeated numbers')
            end
        else
            disp('Wrong dimension')
        end
    end
    
    %%
    %----------REORDER----------%
    archetypes = archetypes(newOrder, :);
    archetypesNames = archetypesNames(newOrder, :);
    
    %%
    %----------SAVING----------%
     
    save([basePath, '/archetypes.mat'], 'archetypes');
    save([basePath, '/archetypesNames.mat'], 'archetypesNames');
end

