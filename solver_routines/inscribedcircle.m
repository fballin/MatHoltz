function ic = inscribedcircle(p,t)

% INSCRIBEDCIRCLE: XY centre co-ordinates and radius of triangle 
% circumcircles.
%
% P   : Nx2 array of nodal XY co-ordinates
% T   : Mx3 array of triangles as indices into P
% IC  : Mx3 array of inscribed mcircles CC(:,1:2) = XY, CC(:,3) = R^2

cc = zeros(size(t));

% Corner XY
p1 = p(t(:,1),:); 
p2 = p(t(:,2),:); 
p3 = p(t(:,3),:);

% compute length of the triangle sides

a1 = sqrt(sum((p2-p1).^2,2)); 
a2 = sqrt(sum((p3-p2).^2,2));
a3 = sqrt(sum((p1-p3).^2,2));
s=(a1+a2+a3)/2;
% Radius^2
ic(:,3) = (s-a1).*(s-a2).*(s-a3)./s;
% inscribed centre XY
ic(:,1) = (a1.*p3(:,1)+a2.*p1(:,1)+a3.*p2(:,1))./s*2;
ic(:,2) = (a1.*p3(:,2)+a2.*p1(:,2)+a3.*p2(:,2))./s*2;

end      