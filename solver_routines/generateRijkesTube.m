function [x,y,npoint,nelement,e2p,topo]=generateRijkesTube(meshRefine,unstructured,symmetric)
%Georg Mensah, Philip Buschmann, Jonas Moeck 2015 TU Berlin
%generates and sets up the mesh for Rijkes tube
if nargin==1
    unstructured=false;
end

if unstructured
    hdata.hmax = meshRefine;
    vertices=[0    , 0;
        0.5  , 0;
        0.5  , 0.025;
        0    , 0.025];
    % Continuous definition above, thus 'edge' is generic
    edge(:,1)  = 1:length(vertices);
    edge(:,2)  = 2:1:length(vertices)+1;
    edge(end,2)= 1;
    % Compute Mesh: list of node coordinates (p), list of node indices (e2p)
    if symmetric
        [p e2p]    = mesh2d(vertices,edge,hdata);
    else
        vertices(:,2)= vertices(:,2)*2-0.025;
        [p e2p]    = mesh2d(vertices,edge,hdata);
    end
    % Extract coordinates & information
    x = p(:,1);
    y = p(:,2);
    npoint   = length(p);
    nelement = length(e2p);
else
    % regular mesh
    if symmetric
        [x,y,e2p]=rectMesh(0.025,0.5,meshRefine);
        npoint=length(x);
    else
        [x,y,e2p]=rectMesh(0.05,0.5,meshRefine);
        npoint=length(x);
        nelement = length(e2p);
        y=y-0.025;
    end
end


%%
IC=sqrt(inscribedcircle([x y],e2p));
Ri=[min(IC(:,3)) max(IC(:,3))];

%% Topology
topo.Symmetry=find((y<Ri(1)/10)&(y>-Ri(1)/10));
topo.SoundHard=[ find((y<0.025+Ri(1)/10)&(y>0.025-Ri(1)/10)) ; find((x<0+Ri(1)/10)&(x>0-Ri(1)/10)) ];
topo.SoundSoft=[];
topo.Impedance=find((x<0.5+Ri(1)/10)&(x>0.5-Ri(1)/10));
topo.BlochRef=[];
topo.BlochImg=[];
topo.Flame=find((x<0.25+0.005)&(x>0.25-0.005));
topo.Hot=[];
%% sort points on symmetry line to the end of the list...
if symmetric
    %This is why I tell my students to learn indexing ^^
    mask=find((y<Ri(1)/10)&(y>-Ri(1)/10));
    mask2=1:npoint;
    mask2(mask)=[];
    mask2=[mask2'; mask];
    x=x(mask2);
    y=y(mask2);
    mask2(mask2)=1:npoint;
    e2p=mask2(e2p);
    topo.Symmetry=mask2(topo.Symmetry);
    topo.SoundHard=mask2(topo.SoundHard);
    topo.Impedance=mask2(topo.Impedance);
    topo.Flame=mask2(topo.Flame);
    nsym=length(mask);
    
    %% extend symmetric mesh
    x=[x; flipud(x(1:end-nsym))];
    y=[y; -flipud(y(1:end-nsym))];
    %fliplr is to preserve the right hand rule in the traversion of the nodes
    BugFix=fliplr(flipud((2*npoint+1-nsym-e2p).*(e2p<=npoint-nsym)) +(flipud(e2p.*(e2p>npoint-nsym)))); %OMG I discovered a bug in MTLB!!!
    e2p=[e2p ; BugFix];
    
    %extend the boundary markers
    topo.SoundHard=[topo.SoundHard; 2*npoint+1-nsym-topo.SoundHard(~ismember(topo.SoundHard,topo.Symmetry))];
    topo.Impedance=[topo.Impedance; 2*npoint+1-nsym-topo.Impedance(~ismember(topo.Impedance,topo.Symmetry))];
    topo.Flame=[topo.Flame; 2*npoint+1-nsym-topo.Flame(~ismember(topo.Flame,topo.Symmetry))];
    % new statistics
    npoint   = length(x);
    nelement = length(e2p);
end
end

