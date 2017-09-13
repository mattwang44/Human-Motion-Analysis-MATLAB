function [ H, dH ] = AngularMomentum( I, AngVel, AngAcc )
% Calculate the angular momentum and 1st derivative of angular momentum.

% I: Mass moment of Inertia of each limb [3 x 3 x N(segments)]
% AngVel: Angular velocity of limb [nframes x 3 x N(segments)]
% AngAcc: Angular velocity of limb [nframes x 3 x N(segments)]

% H: Angular momentum of each limb [nframes x 3 x N(segments)]
% dH: The first derivation of angular momnetum of each limb [nframes x 3 x N(segments)]

nf = size(AngVel,1);
AngVel = permute(AngVel, [2 4 3 1]);%3 x 1 x N x nf
AngAcc = permute(AngAcc, [2 4 3 1]);%3 x 1 x N x nf
I = repmat(I, 1,1,1,nf);%3 x 3 x N x nf
H = mtimesx(I, AngVel);%3 x 1 x N x nf
dH = mtimesx(I, AngAcc) + cross(AngVel, H);
H = ipermute(H, [2 4 3 1]);
dH = ipermute(dH, [2 4 3 1]);
end

