%%
% Computer Methods in Human Motion Analysis 2017 -- HW1
% Matlab Version: MATLAB R2015b
% Student: ����Ӥ@ ��µ�?R05522625

addpath(genpath(fileparts(cd))) % adding all hw directory to PATH.

%% Initialization
clc;
clearvars;
close all;

%% Variables
% Load data
load('DataQ1.mat');
Fthd = 25; Mthd = 100;
fpF_local1 = [AVGfilt(Fx1, Fthd) AVGfilt(Fy1, Fthd), AVGfilt(Fz1, Fthd)];
fpF_local2 = [AVGfilt(Fx2, Fthd) AVGfilt(Fy2, Fthd), AVGfilt(Fz2, Fthd)];
fpM_local1 = [AVGfilt(Mx1, Mthd) AVGfilt(My1, Mthd), AVGfilt(Mz1, Mthd)];
fpM_local2 = [AVGfilt(Mx2, Mthd) AVGfilt(My2, Mthd), AVGfilt(Mz2, Mthd)];

% Variables given by manufacturer of force plate
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

Pz1 = Vfp2tc1(3);
Pz2 = Vfp2tc2(3);

%% Practice 1

%[ Rg2fp1, Vg2fp1 ] = fpRV(corners1, Vfp2tc1);
%[ Rg2fp2, Vg2fp2 ] = fpRV(corners2, Vfp2tc2);

%COP_local1 = fpCOP( fpF_local1, fpM_local1, Pz1 );
%COP_local2 = fpCOP( fpF_local2, fpM_local2, Pz2 );

[ gCOP1, fpFg1, Rg2fp1, Vg2fp1 ] = ForcePlate( fpF_local1, fpM_local1, corners1, Vfp2tc1, Pz1 );
[ gCOP2, fpFg2, Rg2fp2, Vg2fp2 ] = ForcePlate( fpF_local2, fpM_local2, corners2, Vfp2tc2, Pz2 );

%% Practice 2
% Variables 
fpF_local = cat(3, fpF_local1, fpF_local2);
fpM_local = cat(3, fpM_local1, fpM_local2);
corners = cat(3, corners1, corners2);
Vfp2tc = cat(1, Vfp2tc1, Vfp2tc2);
Pz = [Pz1 Pz2]; 

% Call Function
[ gCOP, nCOP, fpFg, Rg2fp, Vg2fp ] = ForcePlateN( fpF_local, fpM_local, corners, Vfp2tc, Pz );
    
%% Practice 3
figure('Name','COP on the Force Plate', 'NumberTitle','off','position',[600 50 600 500]);

hold on
view(3)
axis equal
fp1 = [0 0 0;464 0 0;464 508 0;0 508 0;0 0 Vfp2tc1(3);464 0 Vfp2tc1(3);464 508 Vfp2tc1(3);0 508 Vfp2tc1(3)];
fp2 = [0 511 0;464 511 0;464 1019 0;0 1019 0;0 511 Vfp2tc2(3);464 511 Vfp2tc2(3);464 1019 Vfp2tc2(3);0 1019 Vfp2tc2(3)];
fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
patch('Vertices',fp1,'Faces',fac,'EdgeColor','b','FaceColor','b', 'FaceAlpha',0.07)
patch('Vertices',fp2,'Faces',fac,'EdgeColor','r','FaceColor','r', 'FaceAlpha',0.07)
text(0,75,-28,'1','HorizontalAlignment','left','FontSize',12,'Color','b');
text(0,580,-28,'2','HorizontalAlignment','left','FontSize',12,'Color','b');

% Color changes along with the magnitude of the force (small,green --> big,yellow)
a=sqrt(sum(abs(sum(fpFg,3)).^2,2));
m=max(a);a=a/m;

for i=1:length(fpF_local1)-1 
    plot([gCOP(i,1), gCOP(i+1,1)], [gCOP(i,2), gCOP(i+1,2)],'r');
    scatter(gCOP(i,1), gCOP(i,2), 35, 'MarkerEdgeColor',[a(i) .5 0],...
              'MarkerFaceColor',[a(i) .7 0], 'LineWidth',0.5)
    pause(1/30)
end

function [ Xf ]= AVGfilt( X, thd)
% Function: offset the data to eliminate the means of error and the data
%           with absolute values under the threshold.

% thd : threshold 

s = size(X);
Xf =  X - mean(X(abs(X)<thd));
Xf(abs(X)<thd)=0;

end
