function [mseOut classification] = computeMSE( handClassifiedWindow, perceptronClassified )
%VALIDATIONFIRSTLEVEL Summary of this function goes here
%   Detailed explanation goes here

%handClassifiedWindow is a cell of vectors in which
%handClassiefiedWindow{a,s} = [w1 w2 w...]
% where a: stand for archetype
%       s: stand signal
%       w: are the windows from the signal s belongs to the archetype a

% the cell handClassiefiedWindow is compared to the perceptron singnals
% output in order to obtain the perceptron performances aka MSE

% output is an array in which each row r is the mse for the archetype r

mseIndex =1;
id = 1;
pc = [];
 

for a = 1: size(handClassifiedWindow,1)
    totalPerArchetype = 0;
    correctClassification = 0;
    wrongClassification = 0;
    
    disp(['analazing archetype: ',num2str(a)]);
    for s =1:size(handClassifiedWindow,2)
        windows = handClassifiedWindow{a,s};
        if ~isempty(windows)
            for w = 1:size(windows,2)
              
              perceptronOutput = perceptronClassified{s,1}(1,windows(1,w)); 
              pc(id,1) = perceptronOutput;
              id = id+1;
              disp(['-: signal',num2str(s) , ' window: ', num2str(windows(1,w)), ' perceptron output: ',num2str(perceptronOutput),' diff ', num2str(abs(perceptronOutput - a))]);
              mse(a,mseIndex) = (perceptronOutput - a)^2; 
              totalPerArchetype = totalPerArchetype +1;
              if round(perceptronOutput) == a
                  correctClassification = correctClassification+1;
              else
                  wrongClassification = wrongClassification +1;
              end    
              mseIndex = mseIndex +1;
            end
        end
    end
    
    mseOut(1,a) = mean(mse(a,:));
    classification(1:4,a)=[totalPerArchetype; correctClassification; wrongClassification; correctClassification/totalPerArchetype*100];
    disp(['MSE: ', num2str(mean(mse(a,:)))]);
    mseIndex = 1;
end    

disp('ok');

