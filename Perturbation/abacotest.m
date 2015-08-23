clear, clc
mult=[8 0 0 0]

num=1;
m=sum(mult);
while mult(end)~=m
    mult=abacalgo(mult)
    num=num+1;
end
num

%%
clear, clc
mult=[2 0 0]

num=1;
m=sum(mult);
while mult(end)~=m
    mult=abacalgo(mult)
    num=num+1;
end
num

%%
clear, clc
k=2;
f=['f_' num2str(k) '=L'' (\lambda_0)x_{' num2str(k-1) '}'];
for m=1:k
    mu=zeros(1,k);
    mu(1)=m
    
    
    if mu == [zeros(1,k-1),1]
        'nö'
    else
        %factorial(m)/prod(factorial(mu))
        k-sum((1:k).*mu)
        if k-sum((1:k).*mu)>=0
            f=[f '+' '{' num2str(prod(factorial(mu))) '}'];
            for n=1:k
                if mu(n)
                    f=[f '\lambda_{' num2str(n) '}^' num2str(mu(n))];
                end
            end
        end
        
        if k-sum((1:k).*mu)>=1
            f=[f '\left[']    ;
            f=[f 'L_0^{(' num2str(m) ')}(\lambda_0)x_{' num2str(k-sum((1:k).*mu)) '} + L ''^{(' num2str(m) ')}(\lambda_0)x_{' num2str(k-1-sum((1:k).*mu)) '}'] ;
            f=[f '\right]'];
            
        elseif k-sum((1:k).*mu)==0
            f=[f 'L_0^{(' num2str(m) ')}(\lambda_0)x_{' num2str(k-sum((1:k).*mu)) '}'];
        end
    end
    
    
    
    %factorial(m)/prod(factorial(mu))
    while mu(end)~=m
        mu=abacalgo(mu)
        if mu == [zeros(1,k-1),1]
            'nö'
        else
            %factorial(m)/prod(factorial(mu))
            k-sum((1:k).*mu)
            if k-sum((1:k).*mu)>=0
                f=[f '+' '{' num2str(prod(factorial(mu))) '}'];
                for n=1:k
                    if mu(n)
                        f=[f '\lambda_{' num2str(n) '}^' num2str(mu(n))];
                    end
                end
            end
            
            if k-sum((1:k).*mu)>=1
                f=[f '\left[']    ;
                f=[f 'L_0^{(' num2str(m) ')}(\lambda_0)x_{' num2str(k-sum((1:k).*mu)) '} + L ''^{(' num2str(m) ')}(\lambda_0)x_{' num2str(k-1-sum((1:k).*mu)) '}'] ;
                f=[f '\right]'];
                
            elseif k-sum((1:k).*mu)==0
                f=[f 'L_0^{(' num2str(m) ')}(\lambda_0)x_{' num2str(k-sum((1:k).*mu)) '}'];
            end
        end
    end
end
f
%%
'} + L ''^{('
