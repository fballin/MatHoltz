close all, clear all, clc
hight=1;
width=1;
meshrefine=1;
[x,y,e2p]=rectMesh(hight,width,meshrefine);
[x,y],e2p
%y=y*2;
x=x*2;
e2p=e2p(1,:);
patch('vertices',[x,y],'faces',e2p,'edgecolor','green')
axis equal tight
%[x,y],e2p

cfunc=@(x,y)(1);
%% 2. Get Constant FEM matrices
% stiffness matrix
[S] = getStiffnessOperator(e2p,x,y,cfunc);
full(S)

D=[x(e2p(3))-x(e2p(2)), x(e2p(1))-x(e2p(3)), x(e2p(2))-x(e2p(1)); y(e2p(3))-y(e2p(2)), y(e2p(1))-y(e2p(3)), y(e2p(2))-y(e2p(1))];
D.'*D/4*2

%det(D)
%% mass matrix
[M] = getMassOperator(e2p,x,y);
full(M)
1/24
2/24
%%
ref_el=1;
ref_vec=[1;0];
k=ref_el;
gradP_ref=([-1 1 0;-1 0 1]'*inv( [x(e2p(ref_el,2))-x(e2p(ref_el,1)),x(e2p(ref_el,3))-x(e2p(ref_el,1));...
    y(e2p(ref_el,2))-y(e2p(ref_el,1)),y(e2p(ref_el,3))-y(e2p(ref_el,1))] ))*ref_vec

JacMatrix = [x(e2p(k,2))-x(e2p(k,1)) x(e2p(k,3))-x(e2p(k,1));...
        y(e2p(k,2))-y(e2p(k,1)) y(e2p(k,3))-y(e2p(k,1))];
edet  = det(JacMatrix) 