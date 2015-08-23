function FTF=ntau(n,tau)
% Georg Mensah, Jonas Moeck, TU Berlin 
%generate the differentiable flame transfer function handle based on an
%n-taumodel

FTF=@(omega,k)(n.*(1i*tau).^k.*exp(1i*omega*tau));



end