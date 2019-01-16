function printFiltersTrainedTrail(basePath, outName ,filters)

    load([basePath,'/archetypes.mat']);
    load([basePath,'/archetypesNames.mat']);
    load([basePath,'/parametersBound.mat']);

    
    %----------VARIABLES----------%
    folderBasePath = ['./', basePath, '/filterTrained'];
    
    %%
    %----------CHECK----------%
    if exist(folderBasePath) == 0
        mkdir(folderBasePath);
    else
        rmdir(folderBasePath,'s');
        mkdir(folderBasePath);
    end

  nfilter = size(filters,2);
  h = figure();
  plots = 1;
  for i = 1:nfilter
      subplot(nfilter,2,plots);
      plot(filters{1,i}.idealSignal);
      title(strcat(num2str(i), '-', archetypesNames{i, 1}));
      ylim([-0.01 1.01]);
      subplot(nfilter,2,plots+1);
      minp = min(filters{1,i}.prototype);
      points = (filters{1,i}.prototype - minp)./(length(filters{1,i}.idealSignal) - minp);
      
      emax = parametersBound(1,i).epsilonMax;
      
      %stigmergicDomain = -0.2:0.001:1.2;
      
      stigmergicDomain = 0 -emax:0.001:1+emax;
      plot(stigmergicDomain,points);
      ylim([-0.01 1.01]);
      %xlim([0-parametersBound(1,i).epsilonMax 1+parametersBound(1,i).epsilonMax]);
      xlim([-0.2 1.2]);
      title(strcat(num2str(i), '-', 'Trail-',archetypesNames{i, 1}));
      plots = plots + 2;
  end
  
  saveas(h,[folderBasePath,'/',outName,'.png']);
  
  
end
