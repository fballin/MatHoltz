function p = rotate(p,A)

% Rotate a node set p by A degrees.

A = A*pi/180;
T = [ cos(A), sin(A)
   -sin(A), cos(A)];
p = (T*p')';

end      % rotate()