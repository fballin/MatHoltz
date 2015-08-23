function mu=abac2mu(abac)
%Georg Mensah, Jonas Moeck TU Berlin
%
%casts a multiindex into its abcaus representation
n=length(abac);
for i=1:n
    mu(i)=sum(abac==i);
end