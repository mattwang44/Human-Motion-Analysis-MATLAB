function [AngVel, AngAcc] = Rot2LocalAngular( Rg2l, smprate )
% Derive the angular velocity and angular acceleration from rotaion matrices.

% Rg2l: the rotaiton matrices describes from global coordinate to local
%       coordinate [3 x 3 x nframes]
% smprate: sampling rate(Hz) [1 x 1]
% AngVel: angular velocity relative to local coordinate [nframes x 3]
% AngAcc: angular acceleration relative to local coordinate [nframes x 3]

% find the Ang. Vel. and Ang. Acc. derived from different rotation sequence
sequence = {'xyx', 'xyz', 'xzy', 'xzx', 'yxy', 'yxz', 'yzy', 'yzx', 'zxy', 'zxz', 'zyx', 'zyz'};
nframes = size(Rg2l,3);
AVp = zeros(nframes,3,12); AAp = zeros(nframes,3,12);

for i = 1:12
    [AVp(:,:,i), AAp(:,:,i)] = Ang2LocalAngular( RotAngConvert(Rg2l,sequence{i}), sequence{i}, smprate );
end

rAV = 100; rAA = 15;%might need modified
thdAV1 = mean2(abs(AVp(:,1,:)))/rAV;thdAV2 = mean2(abs(AVp(:,2,:)))/rAV;thdAV3 = mean2(abs(AVp(:,3,:)))/rAV;
thdAA1 = mean2(abs(AAp(:,1,:)))/rAA;thdAA2 = mean2(abs(AAp(:,2,:)))/rAA;thdAA3 = mean2(abs(AAp(:,3,:)))/rAA;
[maxAV, ImaxAV] = max(abs(AVp),[],3); minAV = min(abs(AVp),[],3);
[maxAA, ImaxAA] = max(abs(AAp),[],3); minAA = min(abs(AAp),[],3);

Iglv = intersect(ImaxAV(abs(maxAV(:,1)-minAV(:,1))>thdAV1,1),intersect(ImaxAV(abs(maxAV(:,2)-minAV(:,2))>thdAV2,2),ImaxAV(abs(maxAV(:,3)-minAV(:,3))>thdAV3,3)));
Igla = intersect(ImaxAA(abs(maxAA(:,1)-minAA(:,1))>thdAA1,1),intersect(ImaxAA(abs(maxAA(:,2)-minAA(:,2))>thdAA2,2),ImaxAA(abs(maxAA(:,3)-minAA(:,3))>thdAA3,3)));
GLindex = intersect(Iglv,Igla);
index = setdiff(1:12,GLindex);
if ~isempty(GLindex)
    disp('Gimbal lock happend when sequence =')
    disp(string(sequence(GLindex)))
end
 
AngVel = mean(AVp(:,:,index),3);
AngAcc = mean(AAp(:,:,index),3);

end

