function [ node_h ] = helmholtzdamper(g,theta,pos)
%This function creates the the  shape of the damper that are used around
%the combustor segment
%   Detailed explanation goes here
%         R         is the inner radius of combustor
%         alpha     is the angle of the position of the resonator in deg
%         r         is the radius position of the resonator
%%
% create the resonator depending on data of cosic-bernhart
p = g*[0,0;
        0,10.5;
        55.5,10.5;
        55.5,40.5;
        165.5,40.5;
        165.5,0];
    % use symmetry of the resonator
node_h = [p; flipud(p(:,1)),flipud(-p(:,2))] ;
node_h([1 6 7 12],:) =[];   % delete useless nodes
%move nodes of resonator
node_h = move(node_h, pos(1),pos(2));
% [node_h(:,2),node_h(:,1)] = cart2pol(node_h(:,1),node_h(:,2));
% node_h(:,2) = node_h(:,2)*pi/0.018
% rotate resonator
% node_h = rotate(node_h, -theta);


end

