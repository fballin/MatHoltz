function omega=omegaPow0(omega,k)
%Georg Mensah, Jonas Moeck 2015 TU Berlin
%
%generates the function handle for f(omega,k)=d omega^0/d omega^k
if k>0;
    omega=0;
else
    omega=1;
end
end