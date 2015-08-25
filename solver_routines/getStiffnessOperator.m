function [S] = getStiffnessOperator(e2p,x,y,cfunc)
%  Georg Mensah, Philip Buschmann, Jonas Moeck; TU Berlin; 2015
%   Computes the global stiffness matrix

%ToDo: avoid ii,jj,ss and use S directly
%ToDo: check wheter ii=jj.'
nelement=size(e2p,1);

% preallocate matrices
ii = zeros(nelement,3^2); % sparse i-index
jj = zeros(nelement,3^2); % sparse j-index
ss = zeros(nelement,3^2); % entry of Galerkin matrix

% build global from local
for k = 1:nelement             % loop over elements
    % compute map
    %generate Transformation
    JacMatrix = [x(e2p(k,2))-x(e2p(k,1)) x(e2p(k,3))-x(e2p(k,1));...
    y(e2p(k,2))-y(e2p(k,1)) y(e2p(k,3))-y(e2p(k,1))];

    edet  = det(JacMatrix);
    dFinv = inv(JacMatrix);
    % build local stiffness matrix    
    sloc=.5*edet*([-1 1 0;-1 0 1]'*dFinv)*([-1 1 0;-1 0 1]'*dFinv).';

    % adjust for non-constant speed of sound
    cloc   = cubepol(k,e2p,x,y,cfunc);
    sloc = cloc*sloc; 
    
    
    % compute i,j indices of the global matrix
    ii( k,: ) = [e2p(k,1) e2p(k,2) e2p(k,3) ...
                 e2p(k,1) e2p(k,2) e2p(k,3) ...
                 e2p(k,1) e2p(k,2) e2p(k,3)]; % local-to-global
    
    jj( k,: ) = [e2p(k,1) e2p(k,1) e2p(k,1) ...
                 e2p(k,2) e2p(k,2) e2p(k,2) ...
                 e2p(k,3) e2p(k,3) e2p(k,3)]; % local-to-global
    
    % compute a(i,j) values of the global matrix
    ss( k,: ) = sloc(:);
end

% create sparse matrix
S = sparse(ii(:),jj(:),ss(:)); % Stiffness-matrix
end

