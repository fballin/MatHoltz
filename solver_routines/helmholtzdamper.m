function [ nodes_h ] = helmholtzdamper(R, alpha,r)
%This function creates the the  shape of the damper that are used around
%the combustor segment
%   Detailed explanation goes here
%         R         is the inner radius of combustor
%         alpha     is the angle of the position of the resonator in deg
%         r         is the radius position of the resonator
%%
hdata.hmax = 0.02;
R = 1;
alpha = 15;
r = 1;

% Die Abmaße für den Resonanzköper stammen von Cosic_bernhard
a = 0.1*R;      % Skalierungswert abhängig von Innenradius R des Sectors
alpha = 90-alpha;
    nodes_h = a*[0.51,0;
            0.51,0.555;
            0.81,0.555;
            0.81,1.655;
            0,1.655;
            0,0.555;
            0.3,0.555;
            0.3,0];  
% rotate the resonator shape
if r>R     % resonator position is on the outer radius
    nodes_h = rotate(nodes_h,alpha);
else 
    nodes_h = rotate(nodes_h,alpha-180);
end 
        edge(:,1)   =1:length(nodes_h);
        edge(:,2)     =2:1:length(nodes_h)+1;
        edge(end,2)   =1;
        [p e2p]    = mesh2d(nodes_h,edge,hdata); 
        
end

