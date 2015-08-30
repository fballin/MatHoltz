function [ node_h ] = helmholtzdamper(R,theta,pos)
%This function creates the the  shape of the damper that are used around
%the combustor segment
%   Detailed explanation goes here
%         R         is the inner radius of combustor
%         alpha     is the angle of the position of the resonator in deg
%         r         is the radius position of the resonator
%%
% create the resonator depending on data of cosic-bernhart
g = R*10^(-3)/2;
p = g*[0,0;
        0,10.5;
        55.5,10.5;
        55.5,40.5;
        165.5,40.5;
        165.5,0];
    % use symmetry of the resonator
node_h = [p; flipud(p(:,1)),flipud(-p(:,2))] ;

%rotate resonator
node_h = rotate(node_h, -theta);

%move nodes of resonator
node_h = move(node_h, pos(1),pos(2));

%%
%         
%         
% % transform node set of the sector in polar coordinates to get the angle
% [node_sec(:,2),node_sec(:,1)]=cart2pol(node_sec(:,1),node_sec(:,2));
% alpha = node_sec(3,2)*pi/0.018;   
% [node_sec(:,1),node_sec(:,2)]=pol2cart(node_sec(:,2),node_sec(:,1));
% %
% % start = node_sec(3,:);      % just an example possible are also x and y coordinates
% % node_h =[start(1),start(2);
% %         start(1),start(2)+0.555;
% %         start(1)+0.31;start(2)+0.555;
% %         start(1)
% %         
% % Die Abmaße für den Resonanzköper stammen von Cosic_bernhard
% a = 0.05*R;      % Skalierungswert abhängig von Innenradius R des Sectors
% alpha = 90-alpha;
% 
% node_h = a*[0.0,0;
%             0.0,0.555;
%             0.31,0.555;
%             0.31,1.655;
%             -0.51,1.655;
%             -0.51,0.555;
%             -0.21,0.555;
%             -0.21,0];  
% % rotate the resonator shape
% if theta>R     % resonator position outer radius
%     node_h = rotate(node_h,alpha);
% else 
%     node_h = rotate(node_h,alpha-180);
% end 
% 
% % umwandlung in polarkoordinaten        
%   node_h = move(node_h,node_sec(3,1),node_sec(3,2));
% % 
% % figure(1)
% % plot(node_h(:,1),node_h(:,2))
% 
% 
% %%
% %         edge(:,1)   =1:length(node_h);
% %         edge(:,2)     =2:1:length(node_h)+1;
% %         edge(end,2)   =1;
% %         [p e2p]    = mesh2d(node_h,edge,hdata); 
% %         
        
end

