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
close all;

%% variables
smprate = 120;
Mass = 73.5; %kg
g = 9.81;
LL = 0.85; %m
load('subcali.mat') 

%% Ms
InterASIS = sqrt(sum((RASI - LASI).^2, 2));
lHipLoc = InterASIS .* [-.19 -.3 -.36];
rHipLoc = InterASIS .* [-.19 -.3 .36];
[rRg2p, ~, ~] = CoordPelvis(cat(3, LASI, RPSI, RASI), 'r', {'LASI', 'RPSI', 'RASI'});
[lRg2p, ~, ~] = CoordPelvis(cat(3, LASI, LPSI, RASI), 'l', {'LASI', 'LPSI', 'RASI'});
lHip = (RASI + LASI)/2 + lHipLoc * lRg2p;
rHip = (RASI + LASI)/2 + rHipLoc * rRg2p;
lKnee = (LLFC+LMFC)/2;      rKnee = (RLFC+RMFC)/2;
lAnkle = (LLMA+LMMA)/2;     rAnkle = (RLMA+RMMA)/2;
CoordP = cat(3, lHip, rHip, lKnee, rKnee, lAnkle, rAnkle);
CoordD = cat(3, CoordP(:,:,3:end), LBTO, RBTO);
[ Ms, Is ] = LLInertia( Mass, CoordP, CoordD);
Is = Is / 1000000; % kg mm^2  -> kg m^2 
Ms = Ms(:);

%% dH
load('DataQ1.mat') 
lRg2t = CoordThigh(cat(3, LLFC, LTRO, LMFC), 'l', {'LLFC', 'LTRO', 'LMFC'});
rRg2t = CoordThigh(cat(3, RTRO, RMFC, RLFC), 'r', {'RTRO', 'RMFC', 'RLFC'});
lRg2s = CoordShank(cat(3, LTT, LLMA, LMMA, LSHA), 'l', {'LTT', 'LLMA', 'LMMA', 'LSHA'});
rRg2s = CoordShank(cat(3, RTT, RSHA, RLMA, RMMA), 'r', {'RTT', 'RSHA', 'RLMA', 'RMMA'});
lRg2f = CoordFoot(cat(3, LHEE, LTOE, LFOO), 'l', {'LHEE', 'LTOE', 'LFOO'});
rRg2f = CoordFoot(cat(3, RFOO, RHEE, RTOE), 'r', {'RFOO', 'RHEE', 'RTOE'});
AllLimbRg2l = cat(4, lRg2t, rRg2t, lRg2s, rRg2s, lRg2f, rRg2f);
[ AngVel, AngAcc ] = Rot2LocalAngularEP( AllLimbRg2l, smprate );
[ H, dH ] = AngularMomentum( Is, AngVel, AngAcc );

%% segmentCOMAcc, rCOM2P, rCOM2D
% nCOP
Fthd = 5; Mthd = 80;
fpF_local1 = [AVGfilt(Fx1, Fthd) AVGfilt(Fy1, Fthd), AVGfilt(Fz1, Fthd)];
fpF_local2 = [AVGfilt(Fx2, Fthd) AVGfilt(Fy2, Fthd), AVGfilt(Fz2, Fthd)];
% fpF_local1 = [Fx1,Fy1,Fz1];
% fpF_local2 = [Fx2,Fy2,Fz2];
fpM_local1 = [AVGfilt(Mx1, Mthd) AVGfilt(My1, Mthd), AVGfilt(Mz1, Mthd)];
fpM_local2 = [AVGfilt(Mx2, Mthd) AVGfilt(My2, Mthd), AVGfilt(Mz2, Mthd)];
corners1 = [0,   508, 0;...
            464, 508, 0;...
            464, 0,   0;...
            0,   0,   0];

corners2 = [464, 511,  0;...
            0,   511,  0;...
            0,   1019, 0;...
            464, 1019, 0];
Vfp2tc1 = [ -0.156, 0.995, -43.574 ];
Vfp2tc2 = [ 0.195, 1.142, -41.737 ];
fpF_local = cat(3, fpF_local1, fpF_local2);
fpM_local = cat(3, fpM_local1, fpM_local2);
corners = cat(3, corners1, corners2);
Vfp2tc = cat(1, Vfp2tc1, Vfp2tc2);
Pz = Vfp2tc(:,3).'; 
[ gCOP1, fpFg1, Rg2fp1, Vg2fp1 ] = ForcePlate( fpF_local1, fpM_local1, corners1, Vfp2tc1, Pz(1) );
[ gCOP2, fpFg2, Rg2fp2, Vg2fp2 ] = ForcePlate( fpF_local2, fpM_local2, corners2, Vfp2tc2, Pz(2) );
[ gCOP, nCOP, fpFg, Rg2fp, Vg2fp ] = ForcePlateN( fpF_local, fpM_local, corners, Vfp2tc, Pz );
fpMg1 = fpM_local1*Rg2fp1.'; %fpMg1(isnan(fpMg1)) = 0;
fpMg2 = fpM_local2*Rg2fp2.'; %fpMg2(isnan(fpMg2)) = 0;

% COM of lower limb
LKnee = (LLFC + LMFC)/2;
RKnee = (RLFC + RMFC)/2;
ProxLL = cat(3, LTRO, RTRO, LKnee, RKnee, LLMA, RLMA);
DistLL = cat(3, LKnee, RKnee, LMMA, RMMA, LBTO, RBTO);
w = reshape(repmat([.433 .433 .5],2,1),1,1,[]);
COMLL = w .* DistLL + (1-w) .* ProxLL;

% Joint center of lower limb
InterASIS = sqrt(sum((RASI - LASI).^2, 2));%nx1
lHipLoc = permute(InterASIS .* [-.19 -.3 -.36], [2 3 1]);
rHipLoc = permute(InterASIS .* [-.19 -.3 .36], [2 3 1]);
[rRg2p, ~, ~] = CoordPelvis(cat(3, LASI, RPSI, RASI), 'r', {'LASI', 'RPSI', 'RASI'});
[lRg2p, ~, ~] = CoordPelvis(cat(3, LASI, LPSI, RASI), 'l', {'LASI', 'LPSI', 'RASI'});
LLJC = cat(4, cat(3, (RASI + LASI)/2 + permute(mtimesx(lRg2p,lHipLoc), [3 1 2]), ...%left hip
                     (RASI + LASI)/2 + permute(mtimesx(rRg2p,rHipLoc), [3 1 2]))... %right hip
            ,cat(3, (LLFC+LMFC)/2, (RLFC+RMFC)/2)...%knee
            ,cat(3, (LLMA+LMMA)/2, (RLMA+RMMA)/2));%ankle

[ rCOM2P, rCOM2D, segCOMAcc ] = LLCOM2PD( COMLL, LLJC, nCOP, smprate );
rCOP2P = cat(3, rCOM2P(:,:,:,1), rCOM2P(:,:,:,2), rCOM2P(:,:,:,3));
rCOP2D = cat(3, rCOM2D(:,:,:,1), rCOM2D(:,:,:,2), rCOM2D(:,:,:,3));
segCOMAcc = cat(3, segCOMAcc(:,:,:,1), segCOMAcc(:,:,:,2), segCOMAcc(:,:,:,3));

%% Force & Moment of segments

segCOMAcc = segCOMAcc/1000;              % mm/sec^2  ->  m/sec^2
Fd_fp = cat(3, fpFg2, fpFg1);            % N
Md_fp = cat(3, fpMg2, fpMg1)/1000;    % Nmm  ->  Nm    %%%?????????????????????????????????????????????   /1000   ??????????????????????????????????????????????
rCOM2P = rCOM2P/1000;                    % mm -> m
rCOM2D = rCOM2D/1000;                    % mm -> m
[ Fp_local_Ak, Mp_local_Ak, Fp_Ak, Mp_Ak ] = JointForceMoment( AllLimbRg2l(:,:,:,5:6), Ms(5:6), segCOMAcc(:,:,5:6), dH(:,:,5:6), rCOM2P(:,:,5:6), rCOM2D(:,:,5:6),  Fd_fp,  0); 
[ Fp_local_Kn, Mp_local_Kn, Fp_Kn, Mp_Kn ] = JointForceMoment( AllLimbRg2l(:,:,:,3:4), Ms(3:4), segCOMAcc(:,:,3:4), dH(:,:,3:4), rCOM2P(:,:,3:4), rCOM2D(:,:,3:4), -Fp_Ak, -Mp_Ak ); 
[ Fp_local_Hp, Mp_local_Hp, Fp_Hp, Mp_Hp ] = JointForceMoment( AllLimbRg2l(:,:,:,1:2), Ms(1:2), segCOMAcc(:,:,1:2), dH(:,:,1:2), rCOM2P(:,:,1:2), rCOM2D(:,:,1:2), -Fp_Kn, -Mp_Kn ); 
Fp_local = cat(4, Fp_local_Hp, Fp_local_Kn, Fp_local_Ak);
Mp_local = cat(4, Mp_local_Hp, Mp_local_Kn, Mp_local_Ak);

%% plotting
% F = figure('Name','Force Applied at the Lower Limb Joints', 'NumberTitle','off','position',[0 50 1680 750]);
% M = figure('Name','Moment Applied at the Lower Limb Joints', 'NumberTitle','off','position',[0 50 1680 750]);
dirname = {'Anterior(+)/Posteriro(-)','Superior(+)/Inferior(-)','Lateral(+)/Medial(-)'};
artiname = {'Hip','Knee','Ankle'};
open Joint_Force.fig;
for i = 1:3
    for j = 1:3
        figure(1)
        subplot(3,3,(i-1)*3+j)
        hold on
        if j == 3
            data = cat(3,-Fp_local(:,j,1,i), Fp_local(:,j,2,i))/Mass/g;
        else
            data = cat(3, Fp_local(:,j,1,i), Fp_local(:,j,2,i))/Mass/g;
        end
        if i == 1
            title(dirname(j))
        end
        if j == 1
            ylabel([artiname{i},'  (N/BW)'])
        end
        xlim([0 159])
        ylim([min(data(:)) max(data(:))])
        hold on
        a=plot(1:159,data(:,:,1,:),'b--');
        b=plot(1:159,data(:,:,2,:),'r--');
        legend([a; b], {'Left','Right'});
    end
end

open Joint_Moment.fig;
dirname = {'Abd(+)/Adduction(-)','Internal(+)/External(-) rotation','Flex(+)/Extension(-)'};
% figure
for i = 1:3
    for j = 1:3
        subplot(3,3,(i-1)*3+j)
        hold on
        if j == 1
            data = cat(3, Mp_local(:,j,1,i), -Mp_local(:,j,2,i))/Mass/g/LL;
        end
        if j == 2
            data = cat(3, -Mp_local(:,j,1,i), Mp_local(:,j,2,i))/Mass/g/LL;

        end
        if j == 3
            data = cat(3, Mp_local(:,j,1,i), Mp_local(:,j,2,i))/Mass/g/LL;
            if i == 2
                data = cat(3, -Mp_local(:,j,1,i), -Mp_local(:,j,2,i))/Mass/g/LL;
            end
        end
%         if j >0
%             data = cat(3, Mp_local(:,j,1,i), Mp_local(:,j,2,i))/Mass/g/LL;
%         end
        if i == 1
            title(dirname(j))
        end
        if j == 1
            ylabel([artiname{i},'  (Nm/BW/LL)'])
        end
        xlim([0 159])
        ylim([min(data(:)) max(data(:))])
        hold on
        a=plot(1:159,data(:,:,1,:),'b--');
        b=plot(1:159,data(:,:,2,:),'r--');
        legend([a; b], {'Left','Right'});
    end
end
% open Joint_Moment.fig;
% close all
function [ Xf ]= AVGfilt( X, thd)
% Function: offset the data to eliminate the means of error and the data
%           with absolute values under the threshold.
% thd : threshold

s = size(X);
Is = abs(X)<thd;
Xf =  X - mean(X(Is));
Xf(Is)=0;
end
