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
%% 
seq = {'RASI','LASI','RPSI','LPSI','L4L5','LPET','RPET','RTRO','RLFC','RMFC','RTHI','RTT','RSHA',...
    'RLMA','RMMA','RTIB','RHEE','RFOO','RTOE','RMTH','LTRO','LLFC','LMFC','LTHI','LTT','LSHA','LLMA',...
    'LMMA','LTIB','LHEE','LFOO','LTOE','LMTH','C7T1','LBTO','LFRM','LHead','LRM','LSAP','LUM','LUPA',...
    'LUS','LWRA','RBTO','RFRM','RHead','RRM','RSAP','RUM','RUPA','RUS','RWRA'};
load('DataSTS.mat') 
load('subcali.mat') 
nf = size(MKtraj,1);
TimeSeq = reshape(1/smprate:1/smprate:nf/smprate,[],1);%nx1

fpF_local1 = [Fx1,Fy1,Fz1];
fpF_local2 = [Fx2,Fy2,Fz2];
fpF_local = cat(3, fpF_local1, fpF_local2);
fpM_local1 = [Mx1,My1,Mz1];
fpM_local2 = [Mx2,My2,Mz2];
fpM_local = cat(3, fpM_local1, fpM_local2);

corners2 = [508  464, 0;...
            508, 0,   0;...
            0,   0,   0;...
            0,   464, 0];
corners1 = [508, -3,   0;...
            508, -467, 0;...
            0,   -467, 0;...
            0,   -3,   0];
corners = cat(3, corners1, corners2);

[ gCOP, nCOP, fpFg, Rg2fp, Vg2fp ] = ForcePlateN( fpF_local, fpM_local, corners, Vfp2c, Pz );
[ bodyCOM, segCOM, ~, ~, ~ ] = WholeBodyCOM( MKtraj, mklist, shoulderR, 7 );

%%
bodyCOMVecX =  Derivative( TimeSeq, bodyCOM(:,1), 1 );
for i = 1:nf
    if bodyCOMVecX(i)<-0.1 
        continue
    else
        Time1 = i;
        break
    end
end  
for j = Time1:nf
    if bodyCOMVecX(j)>-0.1
        continue
    else
        Time1 = j;
        break
    end
end  
Time2 = find(bodyCOMVecX==min(bodyCOMVecX));%229
fpForceSum = sum(sqrt(sum(fpF_local.^2,2)),3);
Time3 = find(fpForceSum==max(fpForceSum));%267
Time4 = nf;

Time1s = 1;
Time2s = (Time2-Time1)/(Time4-Time1)*100;
Time3s = (Time3-Time1)/(Time4-Time1)*100;
Time4s = 100;
TimePlot = reshape(1:100,[],1);
TimeSeq100 = reshape(linspace(Time1/smprate,Time4/smprate,100),[],1);

bodyCOM100 = interp1(TimeSeq,bodyCOM,linspace(Time1,Time4,100)/smprate);
gCOP100 = interp1(TimeSeq,gCOP,linspace(Time1,Time4,100)/smprate);
gCOP100withZ = cat(2,gCOP100,ones(100,1)); %100*3

%% StaticCali
for i = 1:length(seq)
    index = find(strcmp(mklist,seq(i)));
    if ~isempty(index)
        eval(string(seq{i})+'=MKpose(:,:,index);')
    end
end

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
CoordD = cat(3, CoordP(:,:,3:end), LMTH, RMTH);%%%%%
[ Ms, Is ] = LLInertia( BW, CoordP, CoordD);
Is = Is / 1000000; % kg mm^2  -> kg m^2 
Ms = Ms(:);

%% dH
for i = 1:length(seq)
    index = find(strcmp(mklist,seq(i)));
    if ~isempty(index)
        eval(string(seq{i})+'=MKtraj(:,:,index);')
    end
end
lRg2t = CoordThigh(cat(3, LLFC, LTRO, LMFC), 'l', {'LLFC', 'LTRO', 'LMFC'});
rRg2t = CoordThigh(cat(3, RTRO, RMFC, RLFC), 'r', {'RTRO', 'RMFC', 'RLFC'});
lRg2s = CoordShank(cat(3, LTT, LLMA, LMMA, LSHA), 'l', {'LTT', 'LLMA', 'LMMA', 'LSHA'});
rRg2s = CoordShank(cat(3, RTT, RSHA, RLMA, RMMA), 'r', {'RTT', 'RSHA', 'RLMA', 'RMMA'});
lRg2f = CoordFoot(cat(3, LHEE, LTOE, LFOO), 'l', {'LHEE', 'LTOE', 'LFOO'});
rRg2f = CoordFoot(cat(3, RFOO, RHEE, RTOE), 'r', {'RFOO', 'RHEE', 'RTOE'});
AllLimbRg2l = cat(4, lRg2t, rRg2t, lRg2s, rRg2s, lRg2f, rRg2f);
[ AngVel, AngAcc ] = Rot2LocalAngularEP( AllLimbRg2l, smprate );
[ H, dH ] = AngularMomentum( Is, AngVel, AngAcc );%380*3*6

%% segmentCOMAcc, rCOM2P, rCOM2D
fpMg1 = fpM_local1*Rg2fp(:,:,1).'; %fpMg1(isnan(fpMg1)) = 0;
fpMg2 = fpM_local2*Rg2fp(:,:,2).'; %fpMg2(isnan(fpMg2)) = 0;

% COM of lower limb
LKnee = (LLFC + LMFC)/2;
RKnee = (RLFC + RMFC)/2;
ProxLL = cat(3, LTRO, RTRO, LKnee, RKnee, LLMA, RLMA);
DistLL = cat(3, LKnee, RKnee, LMMA, RMMA, LMTH, RMTH);
w = reshape(repmat([.433 .433 .5],2,1),1,1,[]);
COMLL = w .* DistLL + (1-w) .* ProxLL;%380*3*6

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
rCOP2P = cat(3, rCOM2P(:,:,:,1), rCOM2P(:,:,:,2), rCOM2P(:,:,:,3));%380*3*6
rCOP2D = cat(3, rCOM2D(:,:,:,1), rCOM2D(:,:,:,2), rCOM2D(:,:,:,3));%380*3*6
segCOMAcc = cat(3, segCOMAcc(:,:,:,1), segCOMAcc(:,:,:,2), segCOMAcc(:,:,:,3));%380*3*6

%% Force & Moment of segments
segCOMAcc = segCOMAcc/1000;              % mm/sec^2  ->  m/sec^2
Fd_fp = cat(3, fpFg(:,:,1), fpFg(:,:,2));% N
Md_fp = cat(3, fpMg1, fpMg2)/1000000;       % Nmm  ->  Nm    %%%?????????????????????????????????????????????   /1000   ??????????????????????????????????????????????
rCOM2P = rCOM2P/1000;                    % mm -> m
rCOM2D = rCOM2D/1000;                    % mm -> m
[ Fp_local_Ak, Mp_local_Ak, Fp_Ak, Mp_Ak ] = JointForceMoment( AllLimbRg2l(:,:,:,5:6), Ms(5:6), segCOMAcc(:,:,5:6), dH(:,:,5:6), rCOM2P(:,:,5:6), rCOM2D(:,:,5:6),  Fd_fp,  Md_fp ); 
[ Fp_local_Kn, Mp_local_Kn, Fp_Kn, Mp_Kn ] = JointForceMoment( AllLimbRg2l(:,:,:,3:4), Ms(3:4), segCOMAcc(:,:,3:4), dH(:,:,3:4), rCOM2P(:,:,3:4), rCOM2D(:,:,3:4), -Fp_Ak, -Mp_Ak ); 
[ Fp_local_Hp, Mp_local_Hp, Fp_Hp, Mp_Hp ] = JointForceMoment( AllLimbRg2l(:,:,:,1:2), Ms(1:2), segCOMAcc(:,:,1:2), dH(:,:,1:2), rCOM2P(:,:,1:2), rCOM2D(:,:,1:2), -Fp_Kn, -Mp_Kn ); 
Fp_local_Hp = interp1(TimeSeq,Fp_local_Hp,linspace(Time1,Time4,100)/smprate);
Fp_local_Kn = interp1(TimeSeq,Fp_local_Kn,linspace(Time1,Time4,100)/smprate);
Fp_local_Ak = interp1(TimeSeq,Fp_local_Ak,linspace(Time1,Time4,100)/smprate);
Fp_local = cat(4, Fp_local_Hp, Fp_local_Kn, Fp_local_Ak);
Mp_local_Hp = interp1(TimeSeq,Mp_local_Hp,linspace(Time1,Time4,100)/smprate);
Mp_local_Kn = interp1(TimeSeq,Mp_local_Kn,linspace(Time1,Time4,100)/smprate);
Mp_local_Ak = interp1(TimeSeq,Mp_local_Ak,linspace(Time1,Time4,100)/smprate);
Mp_local = cat(4, Mp_local_Hp, Mp_local_Kn, Mp_local_Ak);

% %% plotting
artiname = {'Hip','Knee','Ankle'};
% open Joint_Moment.fig;
dirname = {'Abd(+)/Adduction(-)','Internal(+)/External(-) rotation','Flex(+)/Extension(-)'};
% figure
g = 9.80665;
for i = 1:3
    for j = 1:3
        subplot(3,3,(i-1)*3+j)
        hold on
        if j == 1
            data = cat(3, Mp_local(:,j,1,i), -Mp_local(:,j,2,i))/BW/g/LegLength;
        end
        if j == 2
            data = cat(3, -Mp_local(:,j,1,i), Mp_local(:,j,2,i))/BW/g/LegLength;

        end
        if j == 3
            data = cat(3, Mp_local(:,j,1,i), Mp_local(:,j,2,i))/BW/g/LegLength;
            if i == 2
                data = cat(3, -Mp_local(:,j,1,i), -Mp_local(:,j,2,i))/BW/g/LegLength;
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
        xlim([0 100])
        ylim([min(data(:)) max(data(:))])
        hold on
        a=plot(1:100,data(:,:,1,:),'b');
        b=plot(1:100,data(:,:,2,:),'r');
        plot([Time1s,Time1s],[min(data(:)) max(data(:))],'k--',[Time2s,Time2s],[min(data(:)) max(data(:))],'k--',[Time4s,Time4s],[min(data(:)) max(data(:))],'k--',[Time3s,Time3s],[min(data(:)) max(data(:))],'k--')
        
        legend([a; b], {'Left','Right'});
    end
end
% open Joint_Moment.fig;
% % close all

