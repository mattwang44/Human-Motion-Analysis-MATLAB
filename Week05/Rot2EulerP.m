function [ P, phi, n ] = Rot2EulerP( R )
%

% R: rotation matrices [3 x 3 x nframes x N(segments)]
% P: Euler parameters(normalized quaternion) [nframes x 4 x N(segments)]
% phi: the rotation angles rotate about the axis (radians) [nframes x N(segments)]
% n: unit vectors of the rotation axis [nframes x 3 x N(segments)]
nf = size(R, 3);
N = size(R, 4);

e0 = permute((R(1,1,:,:) + R(2,2,:,:) + R(3,3,:,:) +1).^0.5/2, [3 1 4 2]);%n*1*N
phi = 2 * acos(e0);
e1 = permute((R(3,2,:,:) - R(2,3,:,:)) / 4, [3 1 4 2]) ./ e0;
e2 = permute((R(1,3,:,:) - R(3,1,:,:)) / 4, [3 1 4 2]) ./ e0;
e3 = permute((R(2,1,:,:) - R(1,2,:,:)) / 4, [3 1 4 2]) ./ e0;

if ~isempty(union(isfinite(e3),isnan(e3)))
    Ie0z = e0 == 0;
    phi(Ie0z) = pi;
    e1ate0z = permute((-(R(2,2,:,:) + R(3,3,:,:)/ 2).^0.5) , [3 1 4 2]);
    e2ate0z = permute(R(2,1,:,:) , [3 1 4 2])/2./e1ate0z;
    e3ate0z = permute(R(3,1,:,:) , [3 1 4 2])/2./e1ate0z;
    e1(Ie0z) = e1ate0z(Ie0z);
    e2(Ie0z) = e2ate0z(Ie0z);
    e3(Ie0z) = e3ate0z(Ie0z);
    if ~isempty(union(isfinite(e3),isnan(e3)))
        Ie1z = intersect(e1 == 0, Ie0z);
        e2ate1z = permute(((1- R(3,3,:,:)/ 2).^0.5) , [3 1 4 2]);
        e3ate1z = permute(R(3,2,:,:) , [3 1 4 2])/2./e2ate1z;
        e2(Ie1z) = e2ate1z(Ie1z);
        e3(Ie1z) = e3ate1z(Ie1z);
        if ~isempty(union(isfinite(e3),isnan(e3)))
            Ie2z = intersect(e2 == 0, Ie1z);
            e3(Ie2z) = 0;
        end
    end
end
P = cat(2, e0, e1, e2, e3);
n = cat(2, e1./sin(phi/2), e2./sin(phi/2), e3./sin(phi/2));
phi = squeeze(phi);
end

