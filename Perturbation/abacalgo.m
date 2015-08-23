function mult=abacalgo(mult)
%Georg Mensah, Jonas Moeck  TU Berlin 2015
%
%An implementation of my abacus algorithm to traverse all multiindices of
%dimension n and absolute value m
%
%Necessary to generate higher oder perturbation equations
%
%n: length multi index equals possible number of positions for each bead in
%the abacus
%m: absolute value of multiindex eqals number of bead used in the abacus

n=length(mult);
m=sum(mult);
abac=mult2abac(mult);

ball=find(abac==abac(m),1,'first');
abac(ball)=abac(ball)+1;
abac(ball+1:end)=1;
mult=abac2mult(abac,n);
end


function mult=abac2mult(abac,n)
%casts the abacus state back to the multiindex
mult=zeros(1,n);
for i=1:n
    mult(i)=sum(abac==i);
end
end


function abac=mult2abac(mult)
%casts the multiindex to the abacus representation
n=length(mult);
m=sum(mult);
ball=1;
for i=n:-1:1
    for g=1:mult(i)
        abac(ball)=i;
        ball=ball+1;
    end
end

end