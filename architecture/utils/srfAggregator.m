function [ signalsOut ] = srfAggregator( similarities, strategy )
%SRFAGGREGATOR Summary of this function goes here
%   Detailed explanation goes here

%strategy = 0: weighted mean of all the srf
%strategy = 1: weighted mean of the 2 neighborhood around maximum active srf
%strategy = 2: weighted mean of the 2 neighborhood around minimum active
%              srf ( TO BE USED IN DISTANCE LIKE METRICS)
switch strategy
    case 0
        signalsOut = cell(size(similarities, 1), 1); 
        for i = 1:size(signalsOut, 1)
            % ts{i} contiene la serie trasformata in cui ogni valore corrisponde alla media pesata delle similarities dei filtri su una finestra temporale
            signalsOut{i} = zeros(1, size(similarities{i},1));
            for j = 1:size(signalsOut{i}, 2)
                classSum =  sum(similarities{i}(j, :));
                if classSum == 0
                    signalsOut{i}(j) = 0;
                else
                    % media pesata
                    signalsOut{i}(j) = sum((1:size(similarities{i},2)).*similarities{i}(j,:)) / classSum; 
                end
            end
        end
    case 1 
        signalsOut = cell(size(similarities, 1), 1); 
        for i = 1:size(signalsOut, 1)
            % ts{i} contiene la serie trasformata in cui ogni valore corrisponde alla media pesata delle similarities dei filtri su una finestra temporale
            signalsOut{i} = zeros(1, size(similarities{i},1));
            for j = 1:size(signalsOut{i}, 2)
                
                [maxSim index]= max(similarities{i}(j, :));
                
                if maxSim == 0
                    signalsOut{i}(j) = 0;
                    continue;
                end    
                
                switch index
                    case 1
                        classSum = sum(similarities{i}(j,index:index+1));
                        signalsOut{i}(j) = (similarities{i}(j,index)*index + (index+1)*similarities{i}(j,index+1))/classSum;
                    case size(similarities{i}(j, :),2)
                        classSum = sum(similarities{i}(j,index-1:index)); 
                        signalsOut{i}(j) = (similarities{i}(j,index)*index + (index-1)*similarities{i}(j,index-1))/classSum;
                    otherwise
                        classSum = sum(similarities{i}(j,index-1:index+1));
                        signalsOut{i}(j) = ((index-1)*similarities{i}(j,index-1) + similarities{i}(j,index)*index + (index+1)*similarities{i}(j,index+1))/classSum;
                end        
            end
        end        
end

