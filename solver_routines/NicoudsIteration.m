function [k,vec,vec_adj]=NicoudsIteration(A,B,k,maxiter,tol)
%Georg Mensah, Jonas Moeck 2015 TU Berlin
%
%Performs Nicoud's fix point iteration for nonlinear eigenvalue problems 
%of type A(k) = k^2 B. The Synatx is:
%[k,vec,vec_adj]=NicoudsIteration(A,B,k0,maxiter,tol)
%
%A is a function handle to a matrix A(k) 
%B is a function handle to matrix B(k0)
%maxiter specifies the maximum number of iterations
%tol specifies the tolerance, i.e. the abortion criterion tol<abs(k_n-k_{n-1})
%
%the function returns:
%k the calculated eigenvalue
%vec the corresponding eigenvector(s)
%vec_adj the corresponding adjoint eigenvector(s)

k0=inf;
k_n=k;
iteration=0;

%neig=max(ceil(size(A(0),1)/10),10);
neig=1;

while abs(k0-k)>tol && iteration<maxiter
    k0=k(1);
    k=sqrt(eigs(A(k0),B(k0),neig,k0.^2));
    %k=sqrt(eig(full(A(k0)),full(B(k0))));
    k=k(min(abs(k-k0))==abs(k-k0));
    iteration = iteration +1;
    k_n=[k_n k(1)]; %#ok
end

neig=2;
k0=k(1);
[vec,k]=eigs(A(k0),B(k0),neig,k0.^2);
%[vec,k]=eig(full(A(k0)),full(B(k0)));
k=sqrt(diag(k));
[~,index]=sort(abs(k-k0));


if abs(k(index(1))-k(index(2)))<tol
    vec=vec(:,index(1:2));
else 
    vec=vec(:,index(1));
end


if nargout==3
%compute adjoint eigenvectors
[vec_adj,k_adj]=eigs(A(k0)',B(k0)',neig,(k0.^2)');
%[vec_adj,k_adj]=eig(full(A(k0))',full(B(k0))');
k_adj=sqrt(diag(k_adj));
[~,index]=sort(abs(k_adj-k0'));

if abs(k_adj(index(1))-k_adj(index(2)))<tol
    vec_adj=vec_adj(:,index(1:2));
else 
    vec_adj=vec_adj(:,index(1));
end
end

%k_n=[k_n k(index(1))]; %#ok
% figure
% plot(real(k_n),imag(k_n),'-o')
k=k(index(1));

end