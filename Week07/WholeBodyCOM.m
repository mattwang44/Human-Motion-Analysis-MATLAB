function [ bodyCOM, segCOM, CoordP, CoordD, LLJC ] = WholeBodyCOM( MKcoord, mklist, shoulderR, SegNum )
% Calculate the COM of each limb and whole body from anthropometric data, the proximal 
% and distal coordinates of each limb and joint centers of lower limbs.

% MKcoord: Position of all markers on human body [nframes x 3 x N(markers)]
% mklist: List of marker names with the sequence of MKcoord {1 x N}
% shoulderR: Radius of left and right shoulders [1 x 2]
% SegNum: Number of limbs for calculation [1 x 1]

% bodyCOM: coordinate of COM of whole body [n x 3]
% segCOM: coordinate of COM of each limb [nframes x 3 x N(limbs)], N = 7, 11, 12, 13
% CoordP: Proximal coordinates of N limbs [nframes x 3 x N(limbs)], N = 7, 11, 12, 13
% CoordD: Distal coordinates of N limbs [nframes x 3 x N(limbs)], N = 7, 11, 12, 13
% LLJC: Joint centers of lower limbs (left to right, hip to knee to ankle) 
%       [nframes x 3 x 2(sides) x 3(joints)]

[ CoordP, CoordD, LLJC ] = SegCOM_PD( MKcoord, mklist, shoulderR, SegNum );
[ bodyCOM, segCOM ] = BodyCOM_Dempster( CoordP, CoordD );
end

