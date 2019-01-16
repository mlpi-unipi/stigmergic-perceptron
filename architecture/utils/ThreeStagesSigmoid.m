%{
    Author: Gianni Pollina
%}
function s = ThreeStagesSigmoid(x, limits)
    
    minimum = 6;
    strErr = ('Error while using ''doubleSigmoid'' function.\nIt requires');
    strErr = strcat(strErr, ' %i parameters: Only %i used.');

    if( size(limits, 2) < minimum)
        error (strErr, minimum, size(limits, 2));
    end
    
    mediumA = (limits(2) + limits(3)) / 2;
    mediumB = (limits(4) + limits(5)) / 2;
    

    s(x <= mediumA) = (smf(x(x <= mediumA), [ limits(1) limits(2) ]) / 3);
    s(x > mediumA & x <= mediumB) = (smf(x(x > mediumA & x <= mediumB), [limits(3) limits(4)]) + 1) / 3;
    s(x > mediumB) =(smf(x(x > mediumB), [limits(5) limits(6)]) + 2) / 3; %(smf(x(x > mediumB), [ limits(5) limits(6)  ]) / 3);

end