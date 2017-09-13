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
% % Fthd = 0.5; Mthd = 5;
% % fpF_local1 = [AVGfilt(Fx1, Fthd) AVGfilt(Fy1, Fthd), AVGfilt(Fz1, Fthd)];
% % fpF_local2 = [AVGfilt(Fx2, Fthd) AVGfilt(Fy2, Fthd), AVGfilt(Fz2, Fthd)];
% % fpM_local1 = [AVGfilt(Mx1, Mthd) AVGfilt(My1, Mthd), AVGfilt(Mz1, Mthd)];
% % fpM_local2 = [AVGfilt(Mx2, Mthd) AVGfilt(My2, Mthd), AVGfilt(Mz2, Mthd)];
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
Vfp2tc1 = Vfp2c(1,:);
Vfp2tc2 = Vfp2c(2,:);
Pz1 = Pz(1);
Pz2 = Pz(2);
[ gCOP, nCOP, fpFg, Rg2fp, Vg2fp ] = ForcePlateN( fpF_local, fpM_local, corners, Vfp2c, Pz );
figure('Name','COP on the Force Plate', 'NumberTitle','off','position',[600 50 600 500]);

hold on
view(3)
axis equal
fp2 = [0 0 0;0 464 0;508 464 0;508 0 0;0 0 Pz2;0 464 Pz2;508 464 Pz2;508 0 Pz2;];
fp1 = cat(1,corners1,corners1+[0 0 Pz1]);
fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
patch('Vertices',fp1,'Faces',fac,'EdgeColor','b','FaceColor','b', 'FaceAlpha',0.07)
patch('Vertices',fp2,'Faces',fac,'EdgeColor','r','FaceColor','r', 'FaceAlpha',0.07)
text(0,-200,-28,'1','HorizontalAlignment','left','FontSize',12,'Color','b');
text(0,300,-28,'2','HorizontalAlignment','left','FontSize',12,'Color','b');
for i=1:length(fpF_local1)-1 
    plot([gCOP(i,1), gCOP(i+1,1)], [gCOP(i,2), gCOP(i+1,2)],'y');
    scatter(gCOP(i,1), gCOP(i,2), 35, 'MarkerEdgeColor','r',...
              'MarkerFaceColor','k', 'LineWidth',0.5)
    pause(1/60)
end


