function reorder = testGui (archetypes, archetypesNames)
%   TESTGUI show archetypes trail and allow to decide the reordering
% Only works ror R2014b and laterer
    
    %%
    %----------SETUP----------%
    %create clump module
    clump = TripleClumping(1,1,1,1,1,1,1,1,1,1,1,1);
    clump.setParams([0.1;0.25;0.45;0.6;0.8;0.95]);
    %create trail module
    trail = Trailing(0.1, 0.1, min(archetypes(:))-0.3, max(archetypes(:))+0.3, 0.01, TrapezoidalMark(0.3, 0.3));
    trail.setParams([0.4; 0.3]);
    
    reorder = 1:size(archetypes, 1);
    
    %----------CALLBACK FUNCTION----------%
    function edit1_Callback(hObject, ~, ~)
        % hObject    handle to edit1 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of edit1 as text
        %        str2double(get(hObject,'String')) returns contents as double
        reorder = get(hObject,'String');
    end

    %%
    %----------CREATE FIGURE----------%
    % Create a figure and axes
    f = figure('Visible','off');
    for i = 1:size(archetypes, 1)
        %archetypes graph
        subplot(size(archetypes, 1), 2, (i*2)-1);
        plot(archetypes(i, :));
        %stairs(archetypes(i, :));
        title(strcat(num2str(i), '-', archetypesNames(i, 1)));
        axis([0 size(archetypes, 2)+1 min(archetypes(:))-0.1 max(archetypes(:))+0.1]);
        
        %archetypes stigmergic space
        subplot(size(archetypes, 1), 2, (i*2));
        clumpedSignal = clump.apply(archetypes(i, :));
        %plot(clumpedSignal);
        trail.reset();
        StigmergicTrail = trail.apply(clumpedSignal);
        plot(trail.domain(end, :), normalize01(StigmergicTrail));
        title(strcat(num2str(i), '-', 'Trail-',archetypesNames(i, 1)));
        axis([min(trail.domain(end, :)) max(trail.domain(end, :)) -0.1 1.1]);
        %axis([0 size(trail.domain, 2) -0.01 1.1]);
    end
      
    %----------CREATE CONTROL----------%
    %reorderSupport = sprintf('%.0f; ' , reorder);
    %reorderSupport = reorderSupport(1:end-2);
    popup = uicontrol('Style', 'edit',...
        'units','pixels',...
        'position',[10 10 101 31],...
        'String', ' ',...
        'foregroundcolor', 'r',...
        'callback', {@edit1_Callback});
    
    % Make figure visble after adding all components
    f.Visible = 'on';
    
    uiwait;
end