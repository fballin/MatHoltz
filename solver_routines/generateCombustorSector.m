function [x,y,npoint,nelement,e2p,topo]=generateCombustorSector(meshrefine,unstructured,symmetric)
%Georg Mensah,  Philip Buschmann, Jonas Moeck; TU Berlin; 2015
% generates and set up sector mesh for a Combustionchamber with mirror symmetry
display('Generating a feasible mesh for a combustor segment...');
%% Get the triangulation
if nargin == 1
    unstructured = false;
end

if unstructured
    % Mesh-refinement parameter
    meshrefine=0.02
    hdata.hmax = meshrefine;
   
    %Combustor (sector)
    R=1;    %inner radius
    dR=.5;  %outer radius
    N=12;   %degree of rotational symmetry
    a = 2;  %number of helmholtzdamper
    nP=R/meshrefine;
    nP=ceil(sqrt(nP))*12/N;
    
    phi=linspace(0,pi/N,nP);
    phi=phi.';
    
        % Set nodes of the combustor (sector) 
        node_sec    =[(R+dR)*cos(phi) (R+dR)*sin(phi)];
        phi             =flipud(phi);
        node_sec    =[node_sec;[R*cos(phi) R*sin(phi)]];
        % wie bekomme ich jetzt nodes h noch mit hinein?
        % set edges only for combustorsector
        face_s(:,1)     =1:length(node_sec);
        face_s(:,2)     =2:1:length(node_sec)+1;
        face_s(end,2)   =1;


    
%% burner area
    r_b =0.05*R; % radius of burner
    theta = linspace(0,pi,2*nP);
    theta = theta.';
    theta = flipud(theta);
        %position
        xpos_b =R+dR/2;
       
        %Set nodes - burner area
        node_b =[xpos_b+r_b*cos(theta) r_b*sin(theta)];
        
        %set edge only burning area
        face_b(:,1) = face_s(end,1)+1:1:face_s(end,1)+length(node_b);
        face_b(:,2) = face_s(end,1)+2:1:face_s(end,1)+length(node_b)+1;
        face_b(end,2)= face_b(1,1);
%%  Helmholtzdamper are integrated
        % set shape of Helmholtzdamper (cosic bernhard)
        gamma = 10;
        g = R*10^(-3)/2;   % Skalierungsfaktor
        pos = zeros(length(gamma),2);   % initialize position of damper
        a =(sqrt((R+dR)^2-(10.5*g)^2)); % adjusted position of the helmholtzdamper
        [X,Y] = pol2cart((gamma*0.0180/pi),a);
        pos = [X,Y];
        [node_h] = helmholtzdamper(g,gamma, pos);
%         plot(node_h(:,1),node_h(:,2));

%         %% find next face
% [node_sec(:,2),node_sec(:,1)]=cart2pol(node_sec(:,1),node_sec(:,2));
% node_sec(:,2) = node_sec(:,2)*pi/0.018;  
% %%
% [node_h(:,2),node_h(:,1)] = cart2pol(node_h(:,1),node_h(:,2));
% node_h(:,2) = node_h(:,2)*pi/0.018
%%
        face_h(:,1) = face_b(end,1)+1:1:face_b(end,1)+length(node_h);
        face_h(:,2) = face_b(end,1)+2:1:face_b(end,1)+length(node_h)+1;
        face_h(end,2)= face_h(1,1);
     %%  
    %combine sector and burning area
    node    = [node_sec; node_b; node_h];
    edge    = [face_s; face_b; face_h];

    % areas
    face{1} = 1:length(edge);   % combustor
    face{2} = face_b(:,1)';     % burner
    face{3} = face_h(:,1)';     %helmholtzdamper
%%
% Compute Mesh: list of node coordinates (p), list of node indices (e2p)
options.output = true;      %output stats and figure
[p, e2p, fnum]    = meshfaces(node,edge,face,hdata,options); 
% Extract coordinates & information
x = p(:,1);
y = p(:,2);
npoint   = length(p);
nelement = length(e2p);
figure(2)
 patch('vertices',[x,y],'faces',e2p,'edgecolor','green')
 
%%
IC=sqrt(inscribedcircle([x y],e2p));
Ri=[min(IC(:,3)) max(IC(:,3))];
%hist(IC(:,3))

%% B.C. Marker 
 id=[];
 combustor=[];
 idType=[];
%% B.C. Marker 
% definitions
idInterior  = 0;
idSoundSoft     = 1;   % homogeneous NBC
idSoundHard    = 2;   % homogeneous DBC
idCombustor = 3;   % acoustic boundary condition
idBlochImg  = 4.1; % Bloch image
idBlochRef  = 4.2; % Bloch reference
idSymmetry  = 5;   % Symmetry boundary

% save definitions ToDo: Some points have more than one property
idType.Value = [0 1 2 3 4.1 4.2 5];
idType.Description = {'idInterior','idSoundSoft','idSoundHard','idCombustor','idBlochImg','idBlochRef', 'idSymmetry'};
idType.MathType = {'idInterior','homogeneous NBC','homogeneous DBC', ...
                'acoustic boundary condition, prescribed impedance', ...
                'Bloch (image)','Bloch (reference)','symmetry line'};

% General
id = idInterior .*ones(length(p),1);   % Interior
id((y<Ri(1)/10)&(y>-Ri(1)/10))            = idSymmetry ; % Symmetrylines 
%sum(atan(y./x)<pi/N+1E8*eps&atan(y./x)>pi/N-1E8*eps)
id(atan(y./x)<pi/N+100*eps&atan(y./x)>pi/N-100*eps)  = idBlochRef; % BlochRef
id(sqrt(x.^2+y.^2)<R+Ri(1)&sqrt(x.^2+y.^2)>R-Ri(1))  = idSoundHard; % inner wall
id(sqrt(x.^2+y.^2)<R+dR+Ri(1)&sqrt(x.^2+y.^2)>R+dR-Ri(1))  = idSoundHard; % outer wall 

topo.Symmetry=find((y<Ri(1)/10)&(y>-Ri(1)/10));
topo.BlochRef=find(atan(y./x)<pi/N+100*eps&atan(y./x)>pi/N-100*eps);
topo.SoundHard=[find(sqrt(x.^2+y.^2)<R+Ri(1)&sqrt(x.^2+y.^2)>R-Ri(1)) ; find(sqrt(x.^2+y.^2)<R+dR+Ri(1)&sqrt(x.^2+y.^2)>R+dR-Ri(1))];

topo.Flame=find((x-R-dR/2).^2+y.^2<=dR/64)

%% sort points on symmetry line to the end of the list...
%This is why I tell my students to learn indexing ^^
mask=find((y<Ri(1)/10)&(y>-Ri(1)/10));
mask2=1:npoint;
mask2(mask)=[];
mask2=[mask2'; mask];
x=x(mask2);
y=y(mask2);
id=id(mask2);
mask2(mask2)=1:npoint;
e2p=mask2(e2p);
topo.Symmetry=mask2(topo.Symmetry);
topo.BlochRef=mask2(topo.BlochRef);
topo.SoundHard=mask2(topo.SoundHard);
topo.Flame=mask2(topo.Flame);
nsym=length(mask);

%% ... and sort Bloch to the beginning

mask=find(atan(y./x)<pi/N+100*eps&atan(y./x)>pi/N-100*eps);
mask2=1:npoint;
mask2(mask)=[];
mask2=[mask; mask2'];
x=x(mask2);
y=y(mask2);
id=id(mask2);
mask2(mask2)=1:npoint;
e2p=mask2(e2p);
topo.Symmetry=mask2(topo.Symmetry);
topo.BlochRef=mask2(topo.BlochRef);
topo.SoundHard=mask2(topo.SoundHard);
topo.SoundHard=mask2(topo.SoundHard);
topo.Flame=mask2(topo.Flame);
%%extend symmetric mesh
x=[x; flipud(x(1:end-nsym))];
y=[y; -flipud(y(1:end-nsym))];


%fliplr is to preserve the right hand rule in the traversion of the nodes
BugFix=fliplr(flipud((2*npoint+1-nsym-e2p).*(e2p<=npoint-nsym)) +(flipud(e2p.*(e2p>npoint-nsym)))); %OMG I discovered a bug in MTLB!!!
e2p=[e2p ; BugFix];
%e2p(e2p>length(x))= e2p(e2p>length(x))-npoint;

%extend the boundary markers
id=[id; flipud(id(1:end-nsym))];
id((1:length(id))'>npoint&id==idBlochRef)=idBlochImg;

topo.BlochImg=2*npoint+1-nsym-topo.BlochRef;
topo.SoundHard=[topo.SoundHard; 2*npoint+1-nsym-topo.SoundHard];
BugFix=(2*npoint+1-nsym-topo.Flame).*(topo.Flame<=npoint-nsym);
topo.Flame=[topo.Flame;BugFix];
topo.Flame(topo.Flame==0)=[];
% 
% %squeeze double points on symmetry line 
% mask=find((y<Ri(1)/10)&(y>-Ri(1)/10));
% mask=mask(1:length(mask)/2);
% 
% while true
%     e2p(e2p==mask(1)+npoint)=mask(1);
%     x(mask(1)+npoint)=[];
%     y(mask(1)+npoint)=[];
%     e2p(e2p>mask(1)+npoint)=e2p(e2p>mask(1)+npoint)-1;
%     mask(1)=[];
%     npoint=npoint-1;
%  if isempty(mask)
%      break
%  end
% end

% ne statistics
npoint   = length(x);
nelement = length(e2p);

end
 