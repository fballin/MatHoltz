function [x,y,e2p]=rectMesh(hight,width,meshrefine)
n=ceil(width/meshrefine)+1;
m=ceil(hight/meshrefine)+1;
X=linspace(0,width,n);
Y=linspace(0,hight,m);

x=zeros(m*n,1);
y=x;
e2p=zeros(2*(m-1)*(n-1),3);
%this is very slow but Im not focused en0ugh right now
for i=1:m
    for j=1:n;
        x((i-1)*n+j)=X(j);
        y((i-1)*n+j)=Y(i);
        
    end
end

for i=1:(m-1)
    for j=1:(n-1)
        e2p((i-1)*(n-1)+j,:)=[(i-1)*n+j,(i-1)*n+j+1,i*n+j];
        e2p(((i-1)*(n-1)+j+(m-1)*(n-1)),:)=[(i-1)*n+j+1,i*n+j+1,i*n+j];
        
    end
end
end