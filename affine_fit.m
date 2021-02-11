function [n,V,p] = affine_fit(X)
    % Computes the plane that fits best (lest square of the normal distance
    % to the plane) a set of sample points.
    % INPUTS:
    %
    % X: a N by 3 matrix where each line is a sample point
    %
    % OUTPUTS:
    %
    % n : a unit (column) vector normal to the plane
    % V : a 3 by 2 matrix. The columns of V form an orthonormal basis of the
    % plane
    % p : a point belonging to the plane
    %
    % NB: this code actually works in any dimension (2,3,4,...)
    % Author: Adrien Leygue
    % Date: August 30 2013
    
    % The mean of the samples belonging to the plane
    p = mean(X,1);
    
    % The samples are reduced:
    R = bsxfun(@minus,X,p)
    t = R'*R;
    % Computation of the principal directions of the sample cloud
    [V,D] = eig(t);
    
    % Extract the output from the eigenvectors
    n = V(:,1);
    V = V(:,2:end);

end