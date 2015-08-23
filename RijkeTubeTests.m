% Georg Mensah, Philip Buschmann, Jonas Moeck; TU Berlin; 2015
%% 0. Paths
%close all; clear all; clc;
addpath('solver_routines/');          % contains the entire subroutines
addpath('Perturbation/');             % perturbation utilities
addpath('supplement/mesh2d/mesh2d/'); % tool for the triangulation
%addpath('supplement/export_fig/');    % tool for nice plots (not supported anymore)
savepath = 'computations/';           % the results [are saved here
%% 1. Setup: Mesh and thermodynamic data
% mesh 
clear all, close all, clc %clears everything. very mighty use it wisely!

% meshrefine=0.5;
meshrefine=.007;
meshrefine=.004;
unstructured=false; %specify wheter to genrate a structured or unstructured mesh

% meshrefine=.003;
% unstructured=true;

symmetric=true;  %specify wheter to generate a symmetric or asymmetric mesh
[x,y,npoint,nelement,e2p,topo] = generateRijkesTube(meshrefine,unstructured,symmetric);
%

figure(1)
subplot(311)
patch('vertices',[x,y],'faces',e2p,'edgecolor','green')
axis equal tight
hold on
plot(x(topo.SoundHard),y(topo.SoundHard),'bo','markerfacecolor',[0 0 1])
plot(x(topo.Flame),y(topo.Flame),'rd','markerfacecolor',[1 0 0])
plot(x(topo.Impedance),y(topo.Impedance),'yd','markerfacecolor',[1 1 0])
hold off

% initial distribution speed of sound 
[c,r,cfunc,rfunc] = generateSpeedOfSoundAndDensity(e2p,x,y,npoint,topo);
rfunc=1.1878;
%% 2. Get Constant FEM matrices for the passive flame
% stiffness matrix
[S] = -getStiffnessOperator(e2p,x,y,cfunc);
% mass matrix
[M] = getMassOperator(e2p,x,y);

% boundary mass matrix
Z=eps; %Impedance saund hard= inf , sound soft =eps everything in between is also possible.
[B] = 1i/Z*getBoundaryMassOperator(e2p,x,y,unique(topo.Impedance),cfunc);
%% 3. Compute passive flame solution
[omeg0,p_hat,p_hat_adj] = NicoudsIteration(@(k)(S'+k*B),@(k)(-M),120.77*2*pi,30,0.00000002); %Nicouds Iteration is even more accurate than quadeigs
normcol(p_hat);
normcol(p_hat_adj,p_hat);
f0=omeg0/2/pi
figure(1)
subplot(312)
patch('Faces',e2p,'Vertices',[x,y],'FaceVertexCdata',real(p_hat(:,1)),'Facecolor','interp','EdgeColor','interp')
axis equal tight
%% 4.Discretize the Flame operator (n-tau-model)
N2=1773.19; %Value taken from Cerfacs training material
V=getFlameVolume(e2p,x,y,topo.Flame);
if V==0
    warning('No flame volume!!!')
    n=0;
else
    n=N2/V;
end
tau=0/real(f0);
x_ref=0.24;
y_ref=0;
ref_el=mytsearch(x,y,e2p,x_ref,y_ref);
ref_vec=[1;0];
Q = getFlameOperator(e2p,x,y,topo.Flame,ref_el,ref_vec,rfunc,1.4);

%% 5. compute active flame solution using Nicoud's fix point iteration 
tic 
[omeg,p_hat_flame,p_hat_flame_adj] = NicoudsIteration(@(k)(S+k*B-n*exp(1i*k*tau)*Q),@(k)(-M),120*2*pi,30,0.00000002); %Nicouds Iteration is even more accurate than quadeigs
normcol(p_hat_flame);
normcol(p_hat_flame_adj,p_hat_flame);
toc
f_flame=omeg/2/pi


figure(1)
subplot(313)
patch('Faces',e2p,'Vertices',[x,y],'FaceVertexCdata',real(p_hat_flame(:,1)),'Facecolor','interp','EdgeColor','interp')
axis equal tight
%% 6. Setup the function handles for the perturbation theory

FTF=ntau(n,tau);

L=@(omega,k)(omegaPow0(omega,k)*S+omegaPow1(omega,k)*B+omegaPow2(omega,k)*M);
L_pert=@(omega,k)(-FTF(omega,k)*Q);
%% 7. %compute the active flame solution starting from the passive flame solution using 12th order perturbation theory
tic
[p_pert,omega_pert,p_adj]=autoperturb12(L,L_pert,p_hat,p_hat_adj,omeg0,12); %change the 12 into a lower integer if you want to perform lower order perturbation
toc
p_pert=normcol(p_pert);

f_pert=omega_pert/2/pi
%% Junk
%norm((L(omega_pert,0)+L_pert(omega_pert,0))*p_pert)
%norm(full(L(omeg0,0)))
%norm(full(L_pert(omeg0,0)))

%%
% norm(L(omeg0,0)*p_hat)
%norm((L(omeg,0)+L_pert(omeg,0))*p_hat_flame)