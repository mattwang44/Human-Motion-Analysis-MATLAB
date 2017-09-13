function [ o, E, v ] = HelicalAxesCenter( u, p )
% Derive the principal axis and least-square intersection point from
% multiple helical axes (vector and one point on the helical axes)

% u: Vectors of helical axes [nframes x 3]
% p: Points on helical axe s[nframes x 3]
% o: Least-square intersection point[1 x 3]
% E: Error from the least-square process [1 x 1]
% v: The direction of principal axis [1 x 3]

% Calculation of the position of intersection point
u = u./ sqrt(sum(abs(u).^2,2));
A = size(u,1)*eye(3) - u.'*u;%3*3
B = sum(p,1) - sum(sum(u.*p, 2).*u,1);%1*3
o = reshape(A\reshape(B,[],1),1,[]);%1*3

% Calculation of the vector of the principal axis
U = cat(1, u, -u);
M = U.'*U;
[V,D]=eig(M);

D = sum(D,1);
[~,I]=max(D);
v = V(:,I).';

d = p-repmat(o,size(u,1),1);
vec = d - sum(d.* u, 2).*u;
E = sum(sqrt(sum(abs(vec).^2,2)),1)/size(u,1);

end

