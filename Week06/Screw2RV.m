function [ R, V ] = Screw2RV( phi, n, t, s )
% Transfer screw axis to rotation matrix and position vector

% phi: The rotation angles rotate about the axis (radians) [nframes x 1]
% n: Unit vectors of the rotation axis [nframes x 3]
% t: The value of translation along with the rotation axis [nframes x 1]
% s: Radius of gyrationfrom the origin to the screw axis [nframes x 3]
% R: Rotation matrix [3 x 3 x nframes]
% V: Position vector [nframes x 3]
phi = ipermute(phi,[3 1 2]);
n = ipermute(n,[3 1 2]);
t = ipermute(t,[3 1 2]);
s = ipermute(s,[3 1 2]);
V = t.*n + (1-cos(phi)).*(s-dot(s,n).*n) + sin(phi).*cross(s,n);
nf = size(V,3);
R = mtimesx(n,permute(n,[2 1 3])).*(1-cos(phi)) + cos(phi).*repmat(eye(3),1,1,nf)...
    + sin(phi).*[zeros(1,1,nf) -n(3,1,:) n(2,1,:); n(3,1,:) zeros(1,1,nf) -n(1,1,:); -n(2,1,:) n(1,1,:) zeros(1,1,nf)];
V = permute(V, [3 1 2]);

end

