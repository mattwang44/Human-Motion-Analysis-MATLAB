%%
% Computer Methods in Human Motion Analysis 2017 -- HW9

% Matlab Version:      MATLAB R2017a 
% Operating System     Ubuntu (Linux)
% Student:            Wei-hsiang Wang
% Department:         Mechanical Engineering
% Student ID:         R05522625 

addpath(genpath(fileparts(cd))) % adding all hw directory to PATH.

%% Initialization
clc;
clearvars;
% close all;

%% Practice 1
disp('[Practice 1]') 
disp('See the funciton LLCOM2PD.m') 
open LLCOM2PD.m
disp(' ') 

%% Practice 2
disp('[Practice 2]') 
load('subcali.mat') 

InterASIS = sqrt(sum((RASI - LASI).^2, 2));
lHipLoc = InterASIS .* [-.19 -.3 -.36];
rHipLoc = InterASIS .* [-.19 -.3 .36];
[rRg2p, ~, ~] = CoordPelvis(cat(3, LASI, RPSI, RASI), 'r', {'LASI', 'RPSI', 'RASI'});
[lRg2p, ~, ~] = CoordPelvis(cat(3, LASI, LPSI, RASI), 'l', {'LASI', 'LPSI', 'RASI'});
lHip = (RASI + LASI)/2 + lHipLoc * lRg2p;
rHip = (RASI + LASI)/2 + rHipLoc * rRg2p;
lKnee = (LLFC+LMFC)/2;
rKnee = (RLFC+RMFC)/2;
lAnkle = (LLMA+LMMA)/2;
rAnkle = (RLMA+RMMA)/2;

CoordP = cat(3, lHip, rHip, lKnee, rKnee, lAnkle, rAnkle);
CoordD = cat(3, CoordP(:,:,3:end), LBTO, RBTO);
BW = 73.5;

[ Ms, Is ] = LLInertia( BW, CoordP, CoordD );
Is = Is/1000000;
disp('Mass & Inertia of each limb are saved')
disp(' ')

%% Practice 3
disp('[Practice 3]') 
load('DataQ1.mat') 
smprate = 120;
lRg2t = CoordThigh(cat(3, LLFC, LTRO, LMFC), 'l', {'LLFC', 'LTRO', 'LMFC'});
rRg2t = CoordThigh(cat(3, RTRO, RMFC, RLFC), 'r', {'RTRO', 'RMFC', 'RLFC'});
lRg2s = CoordShank(cat(3, LTT, LLMA, LMMA, LSHA), 'l', {'LTT', 'LLMA', 'LMMA', 'LSHA'});
rRg2s = CoordShank(cat(3, RTT, RSHA, RLMA, RMMA), 'r', {'RTT', 'RSHA', 'RLMA', 'RMMA'});
lRg2f = CoordFoot(cat(3, LHEE, LTOE, LFOO), 'l', {'LHEE', 'LTOE', 'LFOO'});
rRg2f = CoordFoot(cat(3, RFOO, RHEE, RTOE), 'r', {'RFOO', 'RHEE', 'RTOE'});
AllLimb = cat(4, lRg2t, rRg2t, lRg2s, rRg2s, lRg2f, rRg2f);
[ AngVel, AngAcc ] = Rot2LocalAngularEP( AllLimb, smprate );
[ H, dH ] = AngularMomentum( Is, AngVel, AngAcc );

nframes = size(H, 1);
data = H;
tilname = {'Angular Momentum', '1st Derivative of Angular Momentum'};
lgd = {'Hx', 'Hy', 'Hz'};
for i = 1:2
    artiname = {'lThigh','rThigh','lShank','rShank','lFoot','rFoot'};
    figure('Name',[char(tilname(i)),' of Lower Limbs'], 'NumberTitle','off','position',[-800+800*i 50 800 700]);
    ylbl = {'Ang. Momemtum (kg-m^2/s)','1st der. (kg-m^2/s^2)'};
    for j = 1:6
        eval(['ax',num2str(j)]) = subplot(3,2,j);
        hold on
        title(artiname(j))
        a = plot( 1:nframes, data(:,1,j), 'b');
        b = plot( 1:nframes, data(:,2,j), 'g');
        c = plot( 1:nframes, data(:,3,j), 'r');
        ylabel(ylbl(i))
        xlabel('frames')
        xlim([0 nframes])
        if j == 2
            Leg = legend([a; b; c], lgd);
            Pos = get(Leg, 'Position');
            set(Leg, 'Position', [Pos(1)+0.1, Pos(2)+0.09, Pos(3), Pos(4)])
        end
    end
    lgd = {'dHx', 'dHy', 'dHz'};
    data = dH;
end
disp('Fig. 1 & 2 plotted.')