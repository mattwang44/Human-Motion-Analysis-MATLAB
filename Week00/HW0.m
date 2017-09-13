%%
% Computer Methods in Human Motion Analysis 2017 -- HW0
% Matlab Version: MATLAB R2015b
% Student: 機械碩一 王威翔 R05522625

%% Generate automatically (by TA)
% 這個檔案由程式自動產生
% 為了方便程式呼叫不同次作業間的程式碼，建議往後撰寫主程式時加入如下指令...
% Good luck!!!
%                                           by Jia-Da Li, 2014
addpath(genpath(fileparts(cd)))
% adding all hw directory to PATH.

%% Initialization
clc;
clearvars;
close all;

%% Practice 2
% (1)
load('HWdemo.mat')
% gCOM: global coordinate of the center of mass along with the changing of time.
%       [nframes x 3]
%
% Rg2l: the rotation matrix converting from global to local.
%       [3x3]
%
% Vg2l: the coordinate of the origin of local coordinate system relative to
%       the global coordinate system.
%       [1x3]

% (2)
n = length(gCOM); % no. of frames
lCOM = (gCOM - ones(n, 1)*Vg2l) * Rg2l;
% lCOM: local coordinate of the center of mass along with the changing of time.
%       [nframes x 3]

% (3)
gCOM2 = lCOM*Rg2l.' + ones(n, 1)*Vg2l;
% gCOM2: global coordinate of the center of mass calculated from lCOM, Rg2l, and Vg2l.
%        [nframes x 3]

% (4)
% if gCOM is not equal to gCOM2 (deviation of any component > 10^-10), halt the program and open an error dialog.
if ~isempty(find(abs(gCOM2-gCOM)>1.0e-10))     
    errordlg('gCOM2 is NOT equal to gCOM','Error!!');
    return
end

% (5)
% plot gCOM(x1, y1, z1) and gCOM2(x2, y2, z2) versus time(frame index)
hold on
plot(linspace(1,n,n), gCOM(:,:))
plot(linspace(1,n,n), gCOM2(:,:))
legend('x1','y1','z1','x2','y2','z2')