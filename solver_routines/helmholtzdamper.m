function [ nodes_h ] = helmholtzdamper( pos )
%This function creates the the  shape of the damper that are used around
%the combustor segment
%   Detailed explanation goes here

%%
vertices = [0.5,0;
            0.5,0.55;
            0.8,0.55;
            0.8,1.65;
            0,1.65;
            0,0.55;
            0.3,0.55;
            0.3,0;];

    hdata.hmax = 0.2;
    edge(:,1)  = 1:length(vertices);
    edge(:,2)  = 2:1:length(vertices)+1;
    edge(end,2)= 1;
    options.output = false;
    [p e2p]    = mesh2d(vertices,edge,hdata, options);       
    x = p(:,1);
    y = p(:,2);
    npoint   = length(p);
    nelement = length(e2p);
    figure()
    patch('vertices',[x,y],'faces',e2p,'edgecolor','green')
    
end

