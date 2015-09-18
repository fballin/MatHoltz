function [Ik] = cubepol(k,e2p,x,y,cfunc)
% (C) Georg Mensah, Philip Buschmann, Jonas Moeck; TU Berlin
% Cubic interpolation is used (n=3), the general element, defined by e2p, x
% & y is mapped onto the reference triangle

%ToDo: This functions seems to be not necessary as interpolation is a 
%feature already integrated into FEM  

% Initialisation
N  = 3; % degree
Ng = 4; % number of quadrature points

% Coordinates
x1 = x(e2p(k,1));
x2 = x(e2p(k,2));
x3 = x(e2p(k,3));
y1 = y(e2p(k,1));
y2 = y(e2p(k,2));
y3 = y(e2p(k,3));

% Generate handle for the field of the speed of sound
%cfunc = TriScatteredInterp(x,y,c);
%cfunc = @(x,y) 2-x-2*y;
%Aana  = 1/3;

% Nodal shape functions
N1 = @(xsi,eta) 1-xsi-eta;
N2 = @(xsi,eta) xsi;
N3 = @(xsi,eta) eta;

% Linear mapping
P = @(xsi,eta) x1*N1(xsi,eta) + x2*N2(xsi,eta) + x3*N3(xsi,eta);
Q = @(xsi,eta) y1*N1(xsi,eta) + y2*N2(xsi,eta) + y3*N3(xsi,eta);



% weightening points
xw = [1/3 1/3; 1/5 3/5; 1/5 1/5; 3/5 1/5];
wi = [-27/48 25/48 25/48 25/48];

% Compute Integral
Ik = 0;
for i = 1:Ng
    Ik = Ik + wi(i)*(cfunc(P(xw(i,1),xw(i,2)),Q(xw(i,1),xw(i,2)))).^2; 
end


end

