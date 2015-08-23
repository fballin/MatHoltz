function omega=omegaPow1(omega,k)

%Georg Mensah, Jonas Moeck 2015 TU Berlin
%
%generates the function handle for f(omega,k)=d omega^1/d omega^k
if k>1;
    omega=0;
elseif k==1;
    omega=1;
else
    omega=omega;
end
end