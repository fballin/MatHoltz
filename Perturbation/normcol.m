function A=normcol(A,B)
% normalize each column of A
%if optional parameter B is given normalize each column of A such that
%A(:,n)'*B(:,n)=1 for each n
if nargin ==1
A=A*diag(1./sqrt(sum(A.*conj(A),1)));
else
A=A*diag(1./(sum(A.*conj(B),1)));    
end

%A=A*diag(exp(-phase(A(1,:)*1i)));
end