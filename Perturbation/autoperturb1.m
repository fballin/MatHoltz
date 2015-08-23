function [x_corr,lambda_corr,x_0_adj]=autoperturb1(L_0,L_prime,x_0,x_0_adj,lambda_0,ord)

f=L_prime(lambda_0,0)*x_0;
Z_A=x_0_adj'*f;
Z_B=-x_0_adj'*L_0(lambda_0,1)*x_0;
[ceta,lambda_1]=eig(Z_A,Z_B);
[ceta_adj,~]=eig(Z_A',Z_B');
ceta=normcol(ceta);
ceta_adj=normcol(ceta_adj,ceta);
x_0=x_0*ceta;
x_0_adj=x_0_adj*ceta_adj;

f=f*ceta;
rhs=-f-L_0(lambda_0,1)*x_0*lambda_1;
x_1=pinv(full(L_0(lambda_0,0)))*rhs;
if ord==1
x_corr=+x_0+x_1;
lambda_corr=+diag(lambda_0).'+diag(lambda_1).';
return
end
end