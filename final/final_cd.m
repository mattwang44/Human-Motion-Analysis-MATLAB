%%
% Computer Methods in Human Motion Analysis 2017 -- Final

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
load('DataSTS.mat') 
nf = size(MKtraj,1);
fpF_local1 = [Fx1,Fy1,Fz1];
fpF_local2 = [Fx2,Fy2,Fz2];
fpM_local1 = [Mx1,My1,Mz1];
fpM_local2 = [Mx2,My2,Mz2];
fpF_local = cat(3, fpF_local1, fpF_local2);
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

load('subcali.mat') 
[ bodyCOM, segCOM, ~, ~, ~ ] = WholeBodyCOM( MKtraj, mklist, shoulderR, 7 );
TimeSeq = reshape(1/smprate:1/smprate:nf/smprate,[],1);%nx1
bodyCOMVecX =  Derivative( TimeSeq, bodyCOM(:,1), 1 );
% plot(TimeSeq,bodyCOMAccX )
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

vec = bodyCOM100-gCOP100withZ;
theS = atan(vec(:,1)./vec(:,3));
theF = -atan(vec(:,2)./vec(:,3));


figure('Name','(d) The Vector pointing from COP to COM', 'NumberTitle','off','position',[100 50 1100 450]);

subplot(2,1,1)
hold on
plot([Time1s,Time1s],[min(ran(:)) max(ran(:))],'k--',[Time2s,Time2s],[min(ran(:)) max(ran(:))],'k--',[Time4s,Time4s],[min(ran(:)) max(ran(:))],'k--',[Time3s,Time3s],[min(ran(:)) max(ran(:))],'k--')
ylim([0 30])
title('The angle projected on the Sagittal Plane (deg)')
plot(TimePlot, theS*180/pi)

subplot(2,1,2)
hold on
plot([Time2s,Time2s],[-5 15],'k--',[Time3s,Time3s],[-5 15],'k--')
ylim([-5 15])
title('The angle projected on the Frontal Plane (deg)')
plot(TimePlot, theF*180/pi)