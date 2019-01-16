%{
    This Function implements the double S-shaped embership function using 
    vector based operations instead of for loops. It requires two
    parameters:
    - X is the array to be shaped.
    - Limits has to be a four-values array:
        - First value is the lower of the low S-shape.
        - Second value is the higher of the low S-shape.
        - Third value is the lower of the high S-shape.
        - Fourth value is the higher of the high S-shape.

    All X-values lower than the first Limits-value will be brougth to 0.
    All X-values higher than the second Limits-value will be brougth to
    0.5.
    All X-values lower than the third Limits-value will be brougth to 0.5.
    All X-values higher than the fourth Limits-value will be brougth to 1.
    All other X-values will be shaped according to the S-shape membership 
    function.

    Author: Andrea Cristantielli
%}
function s = doubleSigmoid(x, limits)
    
    minimum = 4;
    strErr = ('Error while using ''doubleSigmoid'' function.\nIt requires');
    strErr = strcat(strErr, ' %i parameters: Only %i used.');

    if( size(limits, 2) < minimum)
        error (strErr, minimum, size(limits, 2));
    end
    
    medium = (limits(2) + limits(3)) / 2;

    s(x <= medium) = (smf(x(x <= medium), [ limits(1) limits(2) ]) / 2);
    s(x > medium) = (smf(x(x > medium), [limits(3) limits(4)]) + 1) / 2;

end