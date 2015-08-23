function f=pert2mat(k)
%Georg Mensah, Jonas Moeck 2015 TU Berlin
%
%Genrates the right hand side for the perturbation correction linear
%problem
%TODO: document this 
%k=2;
%f=['f_' num2str(k) '=L_prime(lambda_0,0)*x_' num2str(k-1) ''];
f=['f=L_prime(lambda_0,0)*x_' num2str(k-1) ''];

for m=1:k
    mu=zeros(1,k);
    mu(1)=m;
    
    
    if mu == [zeros(1,k-1),1]
        'nö';
    else
        %factorial(m)/prod(factorial(mu))
        if k-sum((1:k).*mu)>=0
            f=[f '+' fracfac(mu) ];
            %for n=1:k
            %    if mu(n)
            %        f=[f 'lambda_' num2str(n) '^' multip(mu(n))];
            %    end
            %end
        %end
        
        if k-sum((1:k).*mu)>=1
            f=[f '(']    ;
            f=[f 'L_0(lambda_0,' num2str(m) ')*x_' num2str(k-sum((1:k).*mu)) '+L_prime(lambda_0,' num2str(m) ')*x_' num2str(k-1-sum((1:k).*mu)) ] ;
            f=[f ')'];
            
        elseif k-sum((1:k).*mu)==0
            f=[f 'L_0(lambda_0,' num2str(m) ')*x_' num2str(k-sum((1:k).*mu)) ];
        end
        
         %   if k-sum((1:k).*mu)>=0           
            for n=1:k
                if mu(n)
                    f=[f '*lambda_' num2str(n)  multip(mu(n))];
                end
            end
        end
        
    end
    
    
    
    %factorial(m)/prod(factorial(mu))
    while mu(end)~=m
        mu=abacalgo(mu);
        if mu == [zeros(1,k-1),1]
            'nö';
        else
            %factorial(m)/prod(factorial(mu))
            if k-sum((1:k).*mu)>=0
                f=[f '+' fracfac(mu)];

            
            if k-sum((1:k).*mu)>=1
                f=[f '(']    ;
                f=[f 'L_0(lambda_0,' num2str(m) ')*x_' num2str(k-sum((1:k).*mu)) '+L_prime(lambda_0,' num2str(m) ')*x_' num2str(k-1-sum((1:k).*mu)) ] ;
                f=[f ')'];
                
            elseif k-sum((1:k).*mu)==0
                f=[f 'L_0(lambda_0,' num2str(m) ')*x_' num2str(k-sum((1:k).*mu))];
            end
                for n=1:k
                    if mu(n)
                        f=[f '*lambda_' num2str(n)  multip(mu(n))];
                    end
                end
            end            
end
    end
end
end

function tex=fracfac(mu)

if prod(factorial(mu))==1
    tex=[];
else
    tex=['(1/' num2str(prod(factorial(mu))) ')*'];
end
end

function tex=multip(n)
if n==1
    tex=[];
else
    tex=['.^' num2str(n) ]; 
end
end

