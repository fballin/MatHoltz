function omega=omegaPow2(omega,k);
%Georg Mensah, Jonas Moeck 2015 TU Berlin
%
%generates the function handle for f(omega,k)=d omega^2/d omega^k
if k>2;
    omega=0*omega;
elseif k==2;
    omega=2;
elseif k==1;
    omega=2*omega;
else
    omega=omega.^2;
end
end
