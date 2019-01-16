function matrix = createNeighbourMatrix( numArchetypes, number )
%CREATENEIGHBOURMATRIX Given the path create a neighbour matrix
%   From the path take the archetypes.mat and create a square matrix with
%   size the number of the archetypes with the distribution of the training
%   set. Prendo 5 segnali dai prototipi adiacenti e 5 dagli adiacenti agli
%   adiacenti.

    %diag
    matrix = -eye(numArchetypes);
    
    %diag 1
    tmp = [number repmat(floor(number/2), [1 numArchetypes-2])];
    
    %diag -1 others
    tmp1 = [repmat(floor(number/2), [1 numArchetypes-2])];
    
    %diag -1
    tmp2 = [repmat(floor(number/2), [1 numArchetypes-2]) number];
    
    matrix = matrix + diag(tmp,1) + diag(tmp1,-2) + diag(tmp1,2)+diag(tmp2,-1);
    %matrix = matrix + diag(tmp, 1) + diag(tmp2, -1);
end

