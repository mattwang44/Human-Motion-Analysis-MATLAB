function R = EulerP2Rot( P )


% P: Euler parameters(normalized quaternion) [nframes x 4 x N(segments)]
% R: rotation matrices [3 x 3 x nframes x N(segments)]
nf = size(P, 1);
N = size(P, 3);
R = zeros(3,nf,3,N);
e0 = P(:,1,:); e1 = P(:,2,:); e2 = P(:,3,:); e3 = P(:,4,:);
R(1,:,1,:) = shiftdim(e0.^2+e1.^2-0.5,-1);
R(2,:,1,:) = shiftdim(e1.*e2+e0.*e3,-1);
R(3,:,1,:) = shiftdim(e1.*e3-e0.*e2,-1);
R(1,:,2,:) = shiftdim(e1.*e2-e0.*e3,-1);
R(2,:,2,:) = shiftdim(e0.^2+e2.^2-0.5,-1);
R(3,:,2,:) = shiftdim(e2.*e3+e0.*e1,-1);
R(1,:,3,:) = shiftdim(e1.*e3+e0.*e2,-1);
R(2,:,3,:) = shiftdim(e2.*e3-e0.*e1,-1);
R(3,:,3,:) = shiftdim(e0.^2+e3.^2-0.5,-1);
R = permute(2*R, [1 3 2 4]);
end

