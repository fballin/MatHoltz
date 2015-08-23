function [Q] = getBoundaryMassOperator(e2p,x,y,Boundary,cfunc)
%  Georg Mensah, Philip Buschmann, Jonas Moeck; TU Berlin, 2015
%   Computes the boundary mass matrix for the acoustic impedance boundary condition

nelement=size(e2p,1);

ii2 = zeros(nelement,(3-1)^2); % sparse i-index
jj2 = zeros(nelement,(3-1)^2); % sparse j-index
qq  = zeros(nelement,(3-1)^2); % entry in boundary mass-matrix 

%Boundary elements are elements with exactly two boundary points
be2p=ismember(e2p,Boundary);
be2p(sum(be2p,2)~=2,:)=false;


for k = find(sum(be2p,2)==2).' % boundary mass matrix
    % build local matrices 
    %[mlocb,k1,k2] = localboundarymass(id,k,e2p0,x,y,idAcousticBC); 
    
    
    p=e2p(k,be2p(k,:));
    mlocb= (1/6).*[2 1; 1 2]*sqrt((x(p(1))-x(p(2))).^2+(y(p(1))-y(p(2))).^2);
    
    % average for speed of sound integration
%     if k1~=0 && k2~=0
%         cloc = cfunc(x(e2p0(k,k1)),y(e2p0(k,k1))) + cfunc(x(e2p0(k,k2)),y(e2p0(k,k2)));
%         cloc = .5*cloc;       
%     else
%         cloc = 1;
%     end
    cloc =.5*( cfunc(x(p(1)),y(p(1))) + cfunc(x(p(2)),y(p(2))) );
    
    % include non-constant speed of sound  
    mlocb = mlocb*cloc;
        
    % compute i,j indices of the global matrix
    ii2( k,: ) = [p(1) p(2) p(1) p(2)]; % local-to-global
    jj2( k,: ) = [p(1) p(1) p(2) p(2)]; % local-to-global
    
    % compute a(i,j) values of the global matrix
    qq( k,: ) = mlocb(:);
end
%This is very bad programming...
ii2(ii2==0)=[];
jj2(jj2==0)=[];
qq(qq==0)=[];
% Create sparse matrices
Q = sparse(ii2(:),jj2(:),qq(:),length(x),length(x)); % Boundary Mass-matrix
end

