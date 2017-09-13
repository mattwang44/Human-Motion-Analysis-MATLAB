%%
% Computer Methods in Human Motion Analysis 2017 -- HW8
% Matlab Version: MATLAB R2017a
% Student: ¾÷±ñºÓ¤@ ¤ý«Âµ¾ R05522625

addpath(genpath(fileparts(cd))) % adding all hw directory to PATH.

%% Initialization
clc;
clearvars;
close all;

%% Practice 1
disp('Practice 1') 
load('QuietStance.mat')
S = SwayArea(COP(:,1:2), true, false);
S = SwayArea(COP(:,1:2), true, true);
disp('Done') 
disp(' ') 
