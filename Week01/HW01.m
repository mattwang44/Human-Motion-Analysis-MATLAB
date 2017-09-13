%%
% Computer Methods in Human Motion Analysis 2017 -- HW1
% Matlab Version: MATLAB R2015b
% Student: ����Ӥ@ ��µ� R05522625

addpath(genpath(fileparts(cd))) % adding all hw directory to PATH.

%% Initialization
clc;
clearvars;
close all;

%% Practice 1
tic
%load data
load('DataQ1.mat');

Pcoordl = cat(3, LASI, LPSI, RASI); MKstrPl = { 'LASI', 'LPSI','RASI'};
Pcoordr = cat(3, LASI, RPSI, RASI); MKstrPr = { 'LASI', 'RPSI','RASI'};
Tcoordl = cat(3, LLFC, LTRO, LMFC); MKstrTl = {'LLFC', 'LTRO', 'LMFC'};
Tcoordr = cat(3, RTRO, RMFC, RLFC); MKstrTr = {'RTRO', 'RMFC', 'RLFC'};
Scoordl = cat(3, LTT, LLMA, LMMA, LSHA); MKstrSl = {'LTT', 'LLMA', 'LMMA', 'LSHA'}; 
Scoordr = cat(3, RTT, RSHA, RLMA, RMMA); MKstrSr = {'RTT', 'RSHA', 'RLMA', 'RMMA'}; 
Fcoordl = cat(3, LHEE, LTOE, LFOO); MKstrFl = {'LHEE', 'LTOE', 'LFOO'}; 
Fcoordr = cat(3,  RFOO, RHEE,RTOE); MKstrFr = { 'RFOO', 'RHEE','RTOE'}; 

% Result
[lRg2p, lVg2p, lPcoord_local] = CoordPelvis(Pcoordl, 'l', MKstrPl);
[rRg2p, rVg2p, rPcoord_local] = CoordPelvis(Pcoordr, 'r', MKstrPr);
[lRg2t, lVg2t, lTcoord_local] = CoordThigh(Tcoordl, 'l', MKstrTl);
[rRg2t, rVg2t, rTcoord_local] = CoordThigh(Tcoordr, 'r', MKstrTr);
[lRg2s, lVg2s, lScoord_local] = CoordShank(Scoordl, 'l', MKstrSl);
[rRg2s, rVg2s, rScoord_local] = CoordShank(Scoordr, 'r', MKstrSr);
[lRg2f, lVg2f, lFcoord_local] = CoordFoot(Fcoordl, 'l', MKstrFl);
[rRg2f, rVg2f, rFcoord_local] = CoordFoot(Fcoordr, 'r', MKstrFr);

% Elapsed time of Practice1 is 0.020202 seconds.
toc
%% Practice 2
% Gather all difference between original and converted global coordinates
% of every markers in the matrix "Result"
tic
Result = cat(3,...
    Pcoordl-CoordL2G(lRg2p, lVg2p, permute(lPcoord_local, [3 2 1])),...
    Pcoordr-CoordL2G(rRg2p, rVg2p, permute(rPcoord_local, [3 2 1])),...
    Tcoordl-CoordL2G(lRg2t, lVg2t, permute(lTcoord_local, [3 2 1])),...
    Tcoordr-CoordL2G(rRg2t, rVg2t, permute(rTcoord_local, [3 2 1])),...
    Scoordl-CoordL2G(lRg2s, lVg2s, permute(lScoord_local, [3 2 1])),...
    Scoordr-CoordL2G(rRg2s, rVg2s, permute(rScoord_local, [3 2 1])),...
    Fcoordl-CoordL2G(lRg2f, lVg2f, permute(lFcoord_local, [3 2 1])),...
    Fcoordr-CoordL2G(rRg2f, rVg2f, permute(rFcoord_local, [3 2 1])));

if ~isempty(find(abs(Result)>1.0e-12, 1))     
    errordlg('The result is not zero, WRONG conversion!!','Error!!');
    return
else 
    msgbox('The result is zero, Run Sucessfully!')
end
toc
% Elapsed time of Practice2 is 0.011175 seconds.