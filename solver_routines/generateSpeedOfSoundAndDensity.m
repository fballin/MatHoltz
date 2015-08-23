function [c,r,cfunc,rfunc] = generateSpeedOfSoundAndDensity(e2p,x,y,npoint,topo)
% Georg Mensah, Philip Buschmann,  Jonas Moeck; TU Berlin; 2015
%   Function to set the field of the speed of sound, necessary for the
%   non-linear elliptic term of the LHS of the equation. Also returns a
%   function handle 'cfunc' later used in the integration of the elliptic
%   term.


% values from CANTERA
%gas = importPhase('gri30.xml');
%setMoleFractions(gas,'CH4:0.095,N2:0.715,O2:0.19'); % stoichiometric methane 
%set(gas,'T',400,'P',oneatm); % atmospheric & a little pre-heat
%c_cold  = 406.6736;%soundspeed(gas);
c_cold = 347;
r_cold  = 0.8419;%specific(gas)
%equilibrate(gas,'HP');
c_hot = 928.9146;%soundspeed(gas);
r_hot = 0.1468;%specific volume(gas)

% set the Speed of sound 
c = ones(npoint,1).*c_cold; % everywhere
c(topo.Hot) = c_hot;    % in flame

% set the density, we need the inverse!
r = ones(npoint,1).*(r_cold^-1); % everywhere
r(topo.Hot) = (r_hot^-1);    % in flame

% handle for the field of the speed of sound (later for integration)
cfunc = TriScatteredInterp(x,y,c);
rfunc = TriScatteredInterp(x,y,r);

end


