function quadeigs(S,M,B,omega0)
%Georg Mensah, Jonas Moeck TU Berlin 2015 

%Recasts a quadratic eigenvalue problem to a higer dimensional linear
%eigenvalue problem
%does not work accurate
%dont no why. Anyway Nicouds iteration does 
%the job as well so this function is not necessary anymore 

%X=spalloc(size(S,1)*2,size(S,2)*2,nnz(S)+size(S,1))
%Y=spalloc(size(S,1)*2,size(S,2)*2,nnz(S)+nnz(B)+size(S,1))
X=[sparse(size(S,1),size(S,1),0), S;
   speye(size(S))              , sparse(size(S,1),size(S,1),0)];

Y=[M, B;sparse(size(S,1),size(S,1),0),speye(size(S))];

[vec,lam]=eigs(X,Y,5,omega0);
om=round(sort(diag(lam)/2/pi))



end