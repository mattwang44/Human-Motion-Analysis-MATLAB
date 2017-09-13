function [ AngVel, AngAcc ] = EulerP2Angular( P, smprate )


% P: Euler parameters(normalized quaternion) [nframes x 4 x N(segments)]
% smprate: sampling rate [1 x 1]
% AngVel: the xyz-coordinates of angular velocity relative to segment local
%         coordinate system [nframes x 3 x N(segments)]
% AngAcc: the xyz-coordinates of angular acceleration relative to segment local
%         coordinate system [nframes x 3 x N(segments)]

N = size(P, 3); nf = size(P, 1);
TimeSeq = reshape(1/smprate:1/smprate:nf/smprate,[],1);%nx1
AngVel = zeros(nf,3,N); AngAcc = zeros(nf,3,N);
for i = 1:N
    Pseg = permute(P(:,:,i), [2 3 1]);%4x1xn
%     e0 = Pseg(1,:,:); e1 = Pseg(2,:,:); e2 = Pseg(3,:,:); e3 = Pseg(4,:,:); 
    Eslash = Pseg(2,:,:).*repmat([0 0  0;  0  0 1; 0 -1 0],1,1,nf)+...
             Pseg(3,:,:).*repmat([0 0 -1;  0  0 0; 1  0 0],1,1,nf)+...
             Pseg(4,:,:).*repmat([0 1  0; -1  0 0; 0  0 0],1,1,nf);
    G = [-Pseg(2:4,:,:)  Eslash + Pseg(1,:,:).*repmat(eye(3),1,1,nf)]; 
    Pdir1 = permute([Derivative(TimeSeq, P(:,1,i), 1), Derivative(TimeSeq, P(:,2,i), 1),...
        Derivative(TimeSeq, P(:,3,i), 1), Derivative(TimeSeq, P(:,4,i), 1)], [2 3 1]);%4x1xn
    Pdir2 = permute([Derivative(TimeSeq, P(:,1,i), 2), Derivative(TimeSeq, P(:,2,i), 2),...
        Derivative(TimeSeq, P(:,3,i), 2), Derivative(TimeSeq, P(:,4,i), 2)], [2 3 1]);%4x1xn
    AngVel(:,:,i) = permute(2 * mtimesx(G, Pdir1),[3 1 2]);%n*3*1
    AngAcc(:,:,i) = permute(2 * mtimesx(G, Pdir2),[3 1 2]);
end

