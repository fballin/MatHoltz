function Q=getFlameOperator(e2p,x,y,flame,ref_el,ref_vec,rho,gamma)
%  Georg Mensah, Philip Buschmann, Jonas Moeck; TU Berlin, 2015
%Computes the global flame operator
nelement=size(e2p,1);
ii = zeros(nelement,3^2); % sparse i-index
jj = zeros(nelement,3^2); % sparse j-index
qq  = zeros(nelement,3^2); % entry in flame operator matrix

%compute gradient on reference element
gradP_ref=([-1 1 0;-1 0 1]'*inv( [x(e2p(ref_el,2))-x(e2p(ref_el,1)),x(e2p(ref_el,3))-x(e2p(ref_el,1));...
    y(e2p(ref_el,2))-y(e2p(ref_el,1)),y(e2p(ref_el,3))-y(e2p(ref_el,1))] ))*ref_vec;


% gradP_ref=[gradP_ref gradP_ref gradP_ref];
gradP_ref=[gradP_ref.' gradP_ref.' gradP_ref.'];
%Loop over all flame elements to generate the global flame operator
%Flame elements are elements where all three corners belong to the flame
%TODO: check wheter this is a good definition

for k=find(sum(ismember(e2p,flame),2)==3).'
    % compute map
    %generate Transformation to current element and compute local flame
    %operator
    JacMatrix = [x(e2p(k,2))-x(e2p(k,1)) x(e2p(k,3))-x(e2p(k,1));...
        y(e2p(k,2))-y(e2p(k,1)) y(e2p(k,3))-y(e2p(k,1))];
    
    edet  = det(JacMatrix); 

    ii( k,: ) = [e2p(k,1) e2p(k,1) e2p(k,1) ...
                 e2p(k,2) e2p(k,2) e2p(k,2) ...
                 e2p(k,3) e2p(k,3) e2p(k,3)];
    jj(k,:)   = [e2p(ref_el,1) e2p(ref_el,2) e2p(ref_el,3) ...
                 e2p(ref_el,1) e2p(ref_el,2) e2p(ref_el,3) ...
                 e2p(ref_el,1) e2p(ref_el,2) e2p(ref_el,3)];
    
%              [e2p(ref_el,1) e2p(ref_el,1) e2p(ref_el,1) ...
%                  e2p(ref_el,2) e2p(ref_el,2) e2p(ref_el,2) ...
%                  e2p(ref_el,3) e2p(ref_el,3) e2p(ref_el,3)];
%     
    %rho   =cubepol(k,e2p,x,y,rfunc);
    qq(k,:)   = (gamma-1)/rho*edet/6*gradP_ref;
    %edet
    %(gamma-1)/rho*edet/6%*gradP_ref(1:3);

end



qq(sum(ismember(e2p,flame),2)~=3,:)=[];
ii(ii==0)=[];
jj(jj==0)=[];

% Create sparse matrices
Q = sparse(ii(:),jj(:),qq(:),length(x),length(x)); % Flame-Operator
end