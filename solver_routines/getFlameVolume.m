function V = getFlameVolume(e2p,x,y,flame)
%  Georg Mensah, Philip Buschmann, Jonas Moeck; TU Berlin, 2015
%Computes the volume of the domain of heat release i.e. the flame 
V=0;
%Loop over all flame elements
%Flame elements are elements where all three corners belong to the flame
%TODO: check wheter this is a good definition




for k=find(sum(ismember(e2p,flame),2)==3).'
    % compute map
    %generate Transformation
    JacMatrix = [x(e2p(k,2))-x(e2p(k,1)) x(e2p(k,3))-x(e2p(k,1));...
        y(e2p(k,2))-y(e2p(k,1)) y(e2p(k,3))-y(e2p(k,1))];
    
    edet  = det(JacMatrix);
    
    V=V+.5*edet;
end
end

