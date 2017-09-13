%%
% Computer Methods in Human Motion Analysis 2017 -- HW4
% Matlab Version: MATLAB R2017a
% Student: ¾÷±ñºÓ¤@ ¤ý«Âµ¾ R05522625

addpath(genpath(fileparts(cd))) % adding all hw directory to PATH.

%% Initialization
clc;
clearvars;
close all;

%% Practice 1
tic
disp('[Practice 1]') 
load('DataQ1.mat')

lRg2p = CoordPelvis(cat(3, LASI, LPSI, RASI), 'l', {'LASI', 'LPSI', 'RASI'});
rRg2p = CoordPelvis(cat(3, LASI, RPSI, RASI), 'r', {'LASI', 'RPSI', 'RASI'});
nframes = length(lRg2p);
thelgp = RotAngConvert(lRg2p, 'yxy');
thergp = RotAngConvert(rRg2p, 'yxy');

smprate = 120;
tr = 1/smprate:1/smprate:nframes/smprate; tc=tr(:);

% format short e
lgpPF = PolyFit(tc, thelgp(:,2), 5);
% lgppf = polyfit(t,thelgp(:,2),5);
rgpPF = PolyFit(tc, thergp(:,2), 5);
% rgppf = polyfit(t,thelgp(:,2),5);

disp('(i)  The coefficients of 5th order polynomial fitting the rotation angles ')
disp('     about x-axis of Euler angles rotation sequence x-y-x:')
lgpPF

disp('(ii) The 1st and 2nd derivative of the rotation angles about x-axis of ')
disp('     Euler angles rotation sequence x-y-x:')
disp('     1st derivative saved in "px1der"')
px1der = permute(PolyVal(PolyDer(lgpPF,1),tc), [2 1]);
disp('     2nd derivative saved in "px2der"')
px2der = permute(PolyVal(PolyDer(lgpPF,2),tc), [2 1]);
toc
disp(' ') 

%% Practice 2
tic
disp('[Practice 2]') 
disp('(i)') 
lRg2t = CoordThigh(cat(3, LLFC, LTRO, LMFC), 'l', {'LLFC', 'LTRO', 'LMFC'});
rRg2t = CoordThigh(cat(3, RTRO, RMFC, RLFC), 'r', {'RTRO', 'RMFC', 'RLFC'});
lRg2s = CoordShank(cat(3, LTT, LLMA, LMMA, LSHA), 'l', {'LTT', 'LLMA', 'LMMA', 'LSHA'});
rRg2s = CoordShank(cat(3, RTT, RSHA, RLMA, RMMA), 'r', {'RTT', 'RSHA', 'RLMA', 'RMMA'});
lRg2f = CoordFoot(cat(3, LHEE, LTOE, LFOO), 'l', {'LHEE', 'LTOE', 'LFOO'});
rRg2f = CoordFoot(cat(3, RFOO, RHEE, RTOE), 'r', {'RFOO', 'RHEE', 'RTOE'});

seq = 'zxz';
[ltAV, ltAA] = Ang2LocalAngular( RotAngConvert(lRg2t,seq), seq, smprate );
[rtAV, rtAA] = Ang2LocalAngular( RotAngConvert(rRg2t,seq), seq, smprate );
[lsAV, lsAA] = Ang2LocalAngular( RotAngConvert(lRg2s,seq), seq, smprate );
[rsAV, rsAA] = Ang2LocalAngular( RotAngConvert(rRg2s,seq), seq, smprate );
[lfAV, lfAA] = Ang2LocalAngular( RotAngConvert(lRg2f,seq), seq, smprate );
[rfAV, rfAA] = Ang2LocalAngular( RotAngConvert(rRg2f,seq), seq, smprate );
dataAV = cat(3, ltAV, rtAV, lsAV, rsAV, lfAV, rfAV);%nx3x6
dataAA = cat(3, ltAA, rtAA, lsAA, rsAA, lfAA, rfAA);%nx3x6
disp('Angular velocity & angular acceleration saved.') 

% Fig.1 plotting
artiname = {'lThigh','rThigh','lShank','rShank','lFoot','rFoot'};
figure('Name','Angular Velocity of Lower Limbs','NumberTitle','off','position',[100 50 600 700]);
for j = 1:6
    eval(['ax',num2str(j)]) = subplot(3,2,j);
    hold on
    title(char(artiname(j)))
    a = plot( 1:nframes, dataAV(:,1,j), 'b');
    b = plot( 1:nframes, dataAV(:,2,j), 'g');
    c = plot( 1:nframes, dataAV(:,3,j), 'r');

    ylabel('Ang. Vel. (rad/s)')
    xlabel('frames')
    xlim([0 nframes]) 

    if j == 2
        Leg = legend([a; b; c], {'Wx', 'Wy', 'Wz'});
        Pos = get(Leg, 'Position'); 
        set(Leg, 'Position', [Pos(1)+0.1, Pos(2)+0.09, Pos(3), Pos(4)])
    end
end   
disp('Fig.1 is plotted.')

% Fig.2 plotting
disp('(ii)') 
artiname = {'X','Y','Z'};
figure('Name','Comparison of Two Methods to Derive Angular Acc.','NumberTitle','off','position',[500 50 600 700]);
for j = 1:3
    eval(['ax',num2str(j)]) = subplot(3,1,j);
    hold on
    title(char(artiname(j)))
    
    b = plot( 1:nframes, Derivative(tc,dataAV(:,j,6),1), 'r'); % ang. vel. by derivative of ang. acc.
    a = plot( 1:nframes, dataAA(:,j,6), 'b');                  % ang. vel. by formula

    ylabel('Ang. Acc.. (rad/s^2)')
    xlabel('frames')
    xlim([0 nframes]) 

    if j == 1
        Leg = legend([a; b; ], {'rAngAccf', 'drAngVelf'});
        Pos = get(Leg, 'Position'); 
        set(Leg, 'Position', [Pos(1)+0.1, Pos(2)+0.09, Pos(3), Pos(4)])
    end
end   
disp('Fig.2 is plotted.')

% Fig.3 plotting
disp('(iii)') 
TargetLimb = rRg2t;
figure('Name','Comparison of Right Thigh`s Angular Velocity derived by 12 Different Rotation Sequences','NumberTitle','off','position',[900 50 600 700]);
sequence = {'xyx', 'xyz', 'xzy', 'xzx', 'yxy', 'yxz', 'yzy', 'yzx', 'zxy', 'zxz', 'zyx', 'zyz'};

[AngV, AngA] = Rot2LocalAngular( TargetLimb, smprate );% result achieved from the function "Rot2LocalAngular" in (iv).
for i = 1:3
    eval(['ax',num2str(i)]) = subplot(3,1,i);
    hold on
    title(char(artiname(i)))
    ylabel('Ang. Vel. (rad/s)')
    xlabel('frames')
    xlim([0 nframes]) 
    for j = 1:12
        [rtAVp, rtAAp] = Ang2LocalAngular( RotAngConvert(TargetLimb,sequence{j}), sequence{j}, smprate );
        plt(j) = plot(1:nframes, rtAVp(:,i));
    end
    plot(1:nframes, AngV(:,i), 'k--') % plot the result achieved from the function "Rot2LocalAngular" in (iv).
    if i == 1
        Leg = legend(plt, sequence);
        Pos = get(Leg, 'Position'); 
        set(Leg, 'Position', [Pos(1)-0.8, Pos(2), Pos(3), Pos(4)+0.02])
    end
end
disp('Fig.3 is plotted.')
disp('(iv)') 
disp('The result achieved from the function "Rot2LocalAngular" is plotted ')
disp('as black dotted line in Fig. 3.')
toc