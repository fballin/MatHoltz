function f=nthorderpert(n)
%Georg Mensah, Jonas Moeck 2015 TU Berlin
%
%Automatically generates a Matlab function autoperturbn to perform perturbation theory up
%to order n
f=['function [x_corr,lambda_corr,x_0_adj]=autoperturb' num2str(n) '(L_0,L_prime,x_0,x_0_adj,lambda_0,ord)\n\n'];

for i=1:n
    f=[f pert2mat(i) ';\n'];
    
    f=[f 'Z_A=x_0_adj''*f;\n' ...
        'Z_B=-x_0_adj''*L_0(lambda_0,1)*x_0;\n' ...
        '[ceta,lambda_' num2str(i) ']=eig(Z_A,Z_B);\n' ...
        '[ceta_adj,~]=eig(Z_A'',Z_B'');\n' ...
        'ceta=normcol(ceta);\n' ...
        'ceta_adj=normcol(ceta_adj,ceta);\n' ... %        '\%enfolding use correct subspaces\n' ...
        'x_0=x_0*ceta;\n' ...
        'x_0_adj=x_0_adj*ceta_adj;\n\n' ...
        ];
    for j=1:i-1
        f=[f 'x_' num2str(j) '=x_' num2str(j) '*ceta;\n'];
    end
    f=[f 'f=f*ceta;\n' ...
        'rhs=-f-L_0(lambda_0,1)*x_0*lambda_' num2str(i) ';\n' ...
        'x_' num2str(i) '=L_0(lambda_0,0)\\rhs;\n' ...
        'if ord==' num2str(i) '\n' ...
        'x_corr='];
    for j=0:i
        f=[f '+x_' num2str(j)]; 
    end
        f=[f ';\nlambda_corr='];
    for j=0:i
        f=[f '+diag(lambda_' num2str(j) ').''']; 
    end
        f=[f ';\nreturn\nend\n'];
end
f=[f 'end'];

fid=fopen(['autoperturb' num2str(n) '.m'],'w+');
fprintf(fid,f);
fclose(fid)
end
