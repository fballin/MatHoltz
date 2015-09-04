function [M] = getMassOperator(e2p,x,y)
%  Georg Mensah, Philip Buschmann, Jonas Moeck; TU Berlin; 2015
%   Computes the global mass matrix
%ToDo: avoid ii,jj,ss and use S directly
%ToDo: check wheter ii=jj.'

nelement=size(e2p,1);

% build matrices
ii = zeros(nelement,3^2); % sparse i-index
jj = zeros(nelement,3^2); % sparse j-index
mm = zeros(nelement,3^2); % entry in mass-matrix (to build rhs)

% build global from local
for k = 1:nelement             % loop over elements
    % compute map
    %generate Transformation
    JacMatrix = [x(e2p(k,2))-x(e2p(k,1)) x(e2p(k,3))-x(e2p(k,1));...
    y(e2p(k,2))-y(e2p(k,1)) y(e2p(k,3))-y(e2p(k,1))];

    edet  = det(JacMatrix); 
    
    % build local mass matrix   
    mloc = edet*[2 1 1; 1 2 1; 1 1 2]/24;             % element mass matrix
    
    
    % compute i,j indices of the global matrix
    ii( k,: ) = [e2p(k,1) e2p(k,2) e2p(k,3) ...
                 e2p(k,1) e2p(k,2) e2p(k,3) ...
                 e2p(k,1) e2p(k,2) e2p(k,3)]; % local-to-global
    
    jj( k,: ) = [e2p(k,1) e2p(k,1) e2p(k,1) ...
                 e2p(k,2) e2p(k,2) e2p(k,2) ...
                 e2p(k,3) e2p(k,3) e2p(k,3)]; % local-to-global
    
    % compute a(i,j) values of the global matrix
    mm( k,: ) = mloc(:);
end


% create sparse matrices
M = sparse(ii(:),jj(:),mm(:)); % Mass-matrix

end

