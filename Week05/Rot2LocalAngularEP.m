function [ AngVel, AngAcc ] = Rot2LocalAngularEP( R, smprate )


% R: rotation matrices [3 x 3 x nframes x N(segments)]
% smprate: sampling rate [1 x 1]
% AngVel: the xyz-coordinates of angular velocity relative to segment local
%         coordinate system [nframes x 3 x N(segments)]
% AngAcc: the xyz-coordinates of angular acceleration relative to segment local
%         coordinate system [nframes x 3 x N(segments)]

[ P, phi, n ] = Rot2EulerP( R );
[ Pi, ~, ~ ] = unwrapEP( P, phi, n );
[ AngVel, AngAcc ] = EulerP2Angular( Pi, smprate );
end

