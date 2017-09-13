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

%% (b)
load('DataSTS.mat')
nf = size(MKtraj,1);
load('subcali.mat') 
[ bodyCOM, segCOM, ~, ~, ~ ] = WholeBodyCOM( MKtraj, mklist, shoulderR, 7 );
TimeSeq = reshape(1/smprate:1/smprate:nf/smprate,[],1);%nx1

b = figure('Name','(b) Animation of Human Sitting to Standing', 'NumberTitle','off','position',[600 50 600 700]);
pause(.5)
for i = 1:nf
    figure(b)
    hold on
    set(gca,'color','black')
    ax = gca;
    axis equal
    axis([bodyCOM(i,1)-750 bodyCOM(i,1)+750 bodyCOM(i,2)-750 bodyCOM(i,2)+750 0 2000])
    for j = -500:250:1000
        plot3([j j],[-1500 2000],[0 0],	'Color',[0.1 0.1 0.1]);
    end
    for j = -1500:250:2000
        plot3([-500 1000],[j j],[0 0],	'Color',[0.1 0.1 0.1]);
    end
    
    view(3)
    scatter3(MKtraj(i,1,:),MKtraj(i,2,:),MKtraj(i,3,:),'y')
    scatter3(segCOM(i,1,:),segCOM(i,2,:),segCOM(i,3,:),'g')
    scatter3(bodyCOM(i,1),bodyCOM(i,2),bodyCOM(i,3),'m')
    
    pause(1/120)
    if i ~= nf
        clf
    end
end


