function inspectSignalWindow( basePath ,perceptronInput,perceptronOutput,signal_,window_, save , varargin)
%INSPECTSIGNALWINDOW Summary of this function goes here
%   Detailed explanation goes here


% this script is usefull to inspect the behavior of a window for a given
% signal. it print the clumping stage for all the archetypes against the
% original windows and also the signal trail against the prototype off all
% the srf.

%varargin{1} = a vector contains horizontal refercence line to be plotted
%in reference signal

load([basePath,'/',perceptronInput]);
load([basePath,'/',perceptronOutput]);
load([basePath,'/archetypes.mat']);
load([basePath,'/archetypesNames.mat']);
load([basePath,'/parametersBound.mat']);

h = figure

plotIndex = 1;
for i=1:size(archetypes,1)  

subplot(size(archetypes,1),5,plotIndex);
plot(signals{signal_,1}(window_,:));

if nargin == 7
        for l = 1:size(varargin{1},1)
          line(get(gca,'XLim'), [varargin{1}(l,1) varargin{1}(l,1)], 'Color',[0 0 0], ...
                'LineStyle', '-.', ...
                'LineWidth', 0.2);
         end

        
        line(get(gca,'XLim'), [parametersBound(i).betaC parametersBound(i).betaC], 'Color',[1 0 0], ...
                'LineStyle', ':', ...
                'LineWidth', 0.2);   
        
        line(get(gca,'XLim'), [parametersBound(i).gammaC parametersBound(i).gammaC], 'Color',[1 0 0], ...
                'LineStyle', ':', ...
                'LineWidth', 0.2);     
end

ylim([0 1]);
xlim([0 size(archetypes,2)]);
title(['REFERENCE signal']);    
    
subplot(size(archetypes,1),5,plotIndex+1);
plot(sigmoidedSignals{signal_,1}{window_,1}{i,1}(1,:));
ylim([0 1]);
xlim([0 size(archetypes,2)]);
title(['CLUMPED signal from SRF ', archetypesNames{i,1}]);

subplot(size(archetypes,1),5,plotIndex+2);
plot(system.filters{1,i}.idealSignal(1,:));
ylim([0 1]);
xlim([0 size(archetypes,2)]);
title(['IDEAL signal from SRF ', archetypesNames{i,1}]);

    
subplot(size(archetypes,1),5,plotIndex+3);
plot(parametersBound(i).domainMin:0.001:parametersBound(i).domainMax,stigmergicTrailSignals{signal_,1}{window_,1}{i,1}(1,:));
hold on;
%plot(parametersBound(i).domainMin:0.001:parametersBound(i).domainMax,system.filters{1,i}.prototype(1,:));
hold off;
xlim([parametersBound(i).domainMin parametersBound(i).domainMax])
ylim([0 size(archetypes,2)]);
if i == 1
    legend('REAL','IDEAL');
end    
title(['SIGNAL trail from SRF ', archetypesNames{i,1}]);

subplot(size(archetypes,1),5,plotIndex+4);
bar([rawSimilarities{signal_,1}(window_,i) similarities{signal_,1}(window_,i)])
ylim([0 1])
title(['RawSimimilaryty - Similarity SRF', archetypesNames{i,1}]);

plotIndex = plotIndex+5;
end
  if save
   savefig(h,[basePath,'/inspectedWindow/',num2str(signal_),'-',num2str(window_),'.fig'])
   close(h);
  end
end

