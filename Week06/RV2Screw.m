function [ phi, n, t, s ] = RV2Screw( R, V, unwraplog )
% Transfer rotation matrix and position vector to screw axis 

% R: Rotation matrix [3 x 3 x nframes]
% V: Position vector [nframes x 3]
% unwraplog: Logical value for determining whether to unwrap [1 x 1]
% phi: The rotation angles rotate about the axis (radians) [nframes x 1]
% n: Unit vectors of the rotation axis [nframes x 3]
% t: The value of translation along with the rotation axis [nframes x 1]
% s: Radius of gyrationfrom the origin to the screw axis [nframes x 3]

if nargin == 2
    unwraplog = 1;
end
% if nargin == 2
%     uwl = 1;
% elseif nargin == 3
%     if unwraplog == 1 || unwraplog == 0
%         uwl = unwraplog;
%     else
%         error('A non-logical value is given to unwraplog!')
%     end
% end

V = permute(V, [2 3 1]);%3*1*n

sinphin = 0.5*[R(3,2,:)-R(2,3,:); R(1,3,:)-R(3,1,:); R(2,1,:)-R(1,2,:)];
sinphi = 0.5*((R(3,2,:)-R(2,3,:)).^2 + (R(1,3,:)-R(3,1,:)).^2 + (R(2,1,:)-R(1,2,:)).^2).^0.5;
cosphi = 0.5*(R(3,3,:)+R(2,2,:)+R(1,1,:)-1);
phi = atan2(sinphi, cosphi);
n = sinphin ./ sinphi;
t = mtimesx(permute(n, [2 1 3]), V);
s = 0.5*(V - t.*n) + 0.5*sinphi./(1-cosphi).*bsxfun(@cross, n, V);

% Index of phi=0
Ipz = phi<10^-6;
if ~isempty(phi(Ipz))
    disp('Ipz')
    n(:,:,Ipz) = bsxfun(@rdivide, V, sqrt(sum(abs(V).^2,1)));
    t(Ipz) = sqrt(sum(abs(V).^2,1));
    s(:,:,Ipz) = [0;0;0];
end

% Index of sin(phi) close to zero
Issp = setdiff(abs(sinphi)<0.03, Ipz);
if ~isempty(sinphi(Issp))
    disp('Issp')
    vec = 0.5 * (R + permute(R,[2 1 3])) - cosphi .* repmat(eye(3),1,1,size(R,3));
    n(:,:,Issp) = bsxfun(@rdivide, vec(:,1,Issp), sqrt(sum(abs(vec(:,1,Issp)).^2,1)));
    t(Issp) = mtimesx(permute(n(:,:,Issp), [2 1 3]), V(:,:,Issp));
    s(:,:,Issp) = 0.5*(V(:,:,Issp) - t(Issp).*n(:,:,Issp)) + 0.5*sinphi(Issp)./(1-cosphi(Issp)).*bsxfun(@cross, n(:,:,Issp), V(:,:,Issp));
end
phi = permute(phi,[3 1 2]);
n = permute(n,[3 1 2]);
t = permute(t,[3 1 2]);
s = permute(s,[3 1 2]);
if unwraplog == 1
    phi = unwrap(phi);
elseif unwraplog ~= 0
    error('A non-logical value is given to unwraplog!')
end


end

