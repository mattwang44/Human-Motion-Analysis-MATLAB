function [ Fp_local, Mp_local, Fp, Mp ] = JointForceMoment( Rg2s, Ms, segCOMAcc, dH, rCOM2P, rCOM2D, Fd, Md )


% Rg2s: The rotation matrix of each segment from global coordinate to the local coordinate
%       [3 x 3 x nframes x N(segment)]
% Ms: Mass of each segment (unitL kg) [N(segment) x 1]
% segCOMAcc: The acceleration of COM of each segment [nframes x 3 x N(segment)]
% dH: The first derivation of angular momnetum of each limb [nframes x 3 x N(segments)]
% rCOM2P: The vectors pointing from COMs to proxinal points. (unit: m)
%        [nframes x 3 x N(segment)]
% rCOM2D: The vectors pointing from COMs to distal points. (unit: m)
%        [nframes x 3 x N(segment)]
% Fd: The external force applied at the distal point of each segment (unit: N)
%     [nframes x 3 x N(segment)]
% Md: The moment applied at the distal point of each segment (unit: N-m)
%     [nframes x 3 x N(segment)]

% Fp_local: The external force applied at the proximal point (local coord.) (unit: N)
%           [nframes x 3 x N(segment)]
% Mp_local: The moment applied at the proximal point (local coord.) (unit: N)
%           [nframes x 3 x N(segment)]
% Fp: The external force applied at the proximal point of each segment (global coord.) (unit: N)
%     [nframes x 3 x N(segment)]
% Mp: The moment applied at the proximal point of each segment (global coord.) (unit: N-m)
%     [nframes x 3 x N(segment)]
g = 9.81;
g = [0 -g 0];
Msm = permute(Ms,[2 3 1]);  
Fp = permute(Msm .* segCOMAcc - Fd - repmat(Msm .* g, size(Rg2s,3),1,1), [4 2 1 3]); %1x3xnxN
Fp_local = permute( mtimesx(Fp,Rg2s), [3 2 4 1]);% n3N
Fp = ipermute(Fp, [4 2 1 3]);% n3N

% size(permute(mtimesx(permute(Rg2s,[2 1 3 4]),permute(dH,[2 4 1 3])),[3 1 4 2]))
% size(permute(mtimesx(permute(dH,[4 2 1 3]),Rg2s),[3 2 4 1 ] ))
% size(Md)
% size(cross(rCOM2D,Fd))
% size(cross(rCOM2P,Fp))
Md(isnan(Md))=0;
dH(isnan(dH))=0;
Fd(isnan(Fd))=0;
Fp(isnan(Fp))=0;
Fd(repmat(isnan(sum(rCOM2D,2)),1,3,1))=0;
Fp(repmat(isnan(sum(rCOM2P,2)),1,3,1))=0;
rCOM2D(isnan(rCOM2D))=0;
rCOM2P(isnan(rCOM2P))=0;
% permute(dH,[2 4 1 3]))  ->        3 1 n N
% permute(Rg2s,[2 1 3 4]) -> Rg2s.' 3 3 n N                    3 1 n N  ->   n 3 N        
% Mp = permute( permute(mtimesx(permute(Rg2s,[1 2 3 4]),permute(dH,[2 4 1 3])),[3 1 4 2]) , [4 2 1 3]); %1x3xnxN
% Mp = permute( - Md , [4 2 1 3]); %1x3xnxN
% Mp = permute( - cross(rCOM2D,Fd), [4 2 1 3]); %1x3xnxN
% Mp = permute( - cross(rCOM2P,Fp), [4 2 1 3]); %1x3xnxN
% Mp = permute( permute(mtimesx(permute(Rg2s,[1 2 3 4]),permute(dH,[2 4 1 3])),[3 1 4 2])  - cross(rCOM2D,Fd)- cross(rCOM2P,Fp), [4 2 1 3]); %1x3xnxN
% Mp = permute( - cross(rCOM2D,Fd)- cross(rCOM2P,Fp) -Md , [4 2 1 3]); %1x3xnxN
Mp = permute( permute(mtimesx(permute(Rg2s,[2 1 3 4]),permute(dH,[2 4 1 3])),[3 1 4 2]) - Md - cross(rCOM2D,Fd) - cross(rCOM2P,Fp), [4 2 1 3]); %1x3xnxN

% Mp = permute( permute(mtimesx(permute(dH,[4 2 1 3]),Rg2s),[3 2 4 1 ] ) - Md - cross(rCOM2D,Fd) - cross(rCOM2P,Fp), [4 2 1 3]); %1x3xnxN
Mp_local = permute( mtimesx(Mp,Rg2s), [3 2 4 1]);
Mp = ipermute(Mp, [4 2 1 3]); 

end

