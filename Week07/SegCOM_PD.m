function [ CoordP, CoordD, LLJC ] = SegCOM_PD( MKcoord, mklist, shoulderR, SegNum )
% Calculate the proximal and distal coordinates of each limb and joint
% centers of lower limbs

% MKcoord: Position of all markers on human body [nframes x 3 x N(markers)]
% mklist: List of marker names with the sequence of MKcoord {1 x N}
% shoulderR: Radius of left and right shoulders [1 x 2]
% SegNum: Number of limbs for calculation [1 x 1]

% CoordP: Proximal coordinates of N limbs [nframes x 3 x N(limbs)], N = 7, 11, 12, 13
% CoordD: Distal coordinates of N limbs [nframes x 3 x N(limbs)], N = 7, 11, 12, 13
% LLJC: Joint centers of lower limbs (left to right, hip to knee to ankle) 
%       [nframes x 3 x 2(sides) x 3(joints)]

%% Variables assigned
seq = {'RASI','LASI','RPSI','LPSI','L4L5','LPET','RPET','RTRO','RLFC','RMFC','RTHI','RTT','RSHA',...
    'RLMA','RMMA','RTIB','RHEE','RFOO','RTOE','RMTH','LTRO','LLFC','LMFC','LTHI','LTT','LSHA','LLMA',...
    'LMMA','LTIB','LHEE','LFOO','LTOE','LMTH','C7T1','LBTO','LFRM','LHead','LRM','LSAP','LUM','LUPA',...
    'LUS','LWRA','RBTO','RFRM','RHead','RRM','RSAP','RUM','RUPA','RUS','RWRA'};
for i = 1:length(seq)
    index = find(strcmp(mklist,seq(i)));
    if isempty(index)
        eval(string(seq{i})+'=[];')
    else
        eval(string(seq{i})+'=MKcoord(:,:,index);')
    end
end
%% Equations
LKnee = (LLFC + LMFC)/2;
RKnee = (RLFC + RMFC)/2;
Zvector = (RASI + LASI + RPSI + LPSI)/4 - (LSAP + RSAP)/2;
unitV = Zvector./sqrt(sum(Zvector.^2,2));
LGH = LSAP + shoulderR(1,1) * unitV;
RGH = RSAP + shoulderR(1,2) * unitV;
LElbow = (LRM + LUM)/2;
RElbow = (RRM + RUM)/2;
GT = (LTRO + RTRO) / 2;
GH = (LGH+RGH)/2;
EarCanal = (LHead + RHead)/2;
%% Upper boddy
switch SegNum
    case 7
        ProxUB = GT;
        DistUB = GH;
    case 11 
        ProxUB = GT;
        DistUB = GH;
    case 12 
        ProxUB = cat(3, GT, C7T1);
        DistUB = cat(3, GH, EarCanal);
    case 13
        ProxUB = cat(3, L4L5, C7T1, C7T1);
        DistUB = cat(3, GT, L4L5, EarCanal);
    otherwise 
        error('Only 7, 11, 12, 13 can be assigned as number of limbs for calaulation!')
end
%% Upper limb
if SegNum == 7
    ProxUL = [];
    DistUL = [];
else
    ProxUL = cat(3, LGH, RGH, LElbow, RElbow);
    DistUL = cat(3, LElbow, RElbow, LUS, RUS);
end
%% Lower limb
ProxLL = cat(3, LTRO, RTRO, LKnee, RKnee, LLMA, RLMA);
DistLL = cat(3, LKnee, RKnee, LMMA, RMMA, LMTH, RMTH);
%% Proximal & Distal
CoordP = cat(3, ProxLL, ProxUL, ProxUB);
CoordD = cat(3, DistLL, DistUL, DistUB);
%% Joint center of lower limb
InterASIS = sqrt(sum((RASI - LASI).^2, 2));%nx1
lHipLoc = permute(InterASIS .* [-.19 -.3 -.36], [2 3 1]);
rHipLoc = permute(InterASIS .* [-.19 -.3 .36], [2 3 1]);
[rRg2p, ~, ~] = CoordPelvis(cat(3, LASI, RPSI, RASI), 'r', {'LASI', 'RPSI', 'RASI'});
[lRg2p, ~, ~] = CoordPelvis(cat(3, LASI, LPSI, RASI), 'l', {'LASI', 'LPSI', 'RASI'});
LLJC = cat(4, cat(3, (RASI + LASI)/2 + permute(mtimesx(lRg2p,lHipLoc), [3 1 2]), ...%left hip
                     (RASI + LASI)/2 + permute(mtimesx(rRg2p,rHipLoc), [3 1 2]))... %right hip
            ,cat(3, (LLFC+LMFC)/2, (RLFC+RMFC)/2)...%knee
            ,cat(3, (LLMA+LMMA)/2, (RLMA+RMMA)/2));%ankle
end

