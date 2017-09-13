%%
% Computer Methods in Human Motion Analysis 2017 -- HW5
% Matlab Version: MATLAB R2017a
% Student: ¾÷±ñºÓ¤@ ¤ý«Âµ¾ R05522625

addpath(genpath(fileparts(cd))) % adding all hw directory to PATH.

%% Initialization
clc;
clearvars;
close all;

%%
disp('[Practice 1]') 

%% (i)
tic
disp('(i)')
load('DataQ1.mat')

smprate = 120;
nframes = size(LLFC,1);
tr = 1/smprate:1/smprate:nframes/smprate; tc=tr(:);

lRg2t = CoordThigh(cat(3, LLFC, LTRO, LMFC), 'l', {'LLFC', 'LTRO', 'LMFC'});
rRg2t = CoordThigh(cat(3, RTRO, RMFC, RLFC), 'r', {'RTRO', 'RMFC', 'RLFC'});
lRg2s = CoordShank(cat(3, LTT, LLMA, LMMA, LSHA), 'l', {'LTT', 'LLMA', 'LMMA', 'LSHA'});
rRg2s = CoordShank(cat(3, RTT, RSHA, RLMA, RMMA), 'r', {'RTT', 'RSHA', 'RLMA', 'RMMA'});
lRg2f = CoordFoot(cat(3, LHEE, LTOE, LFOO), 'l', {'LHEE', 'LTOE', 'LFOO'});
rRg2f = CoordFoot(cat(3, RFOO, RHEE, RTOE), 'r', {'RFOO', 'RHEE', 'RTOE'});
[ P, phi, n ] = Rot2EulerP( rRg2f );
[ Puwp, ~, ~ ] = unwrapEP( P, phi, n );

figure('Name','Euler Parameters of Right Foot Before and After Function "unwrapEP()"','NumberTitle','off','position',[100 50 600 700]);
ax1 = subplot(2,1,1);
plot(1:nframes,P)
title('Euler Parameters of Right Foot BEFORE unwrapEP()')
h = legend(ax1, 'e_0','e_1','e_2','e_3'); pos = get(h,'position');
set(h, 'position',[-0.018 0.88 pos(3:4)])
xlabel('frames')
ylabel('Value of Euler Parameters')
subplot(2,1,2)
plot(1:nframes,Puwp)
title('Euler Parameters of Right Foot AFTER unwrapEP()')
xlabel('frames')
ylabel('Value of Euler Parameters')
disp('Fig. 1 plotted')
toc
disp(' ')
%% (ii)
tic
disp('(ii)')
AllLimb = cat(4, lRg2t, rRg2t, lRg2s, rRg2s, lRg2f, rRg2f);
[ P, phi, n ] = Rot2EulerP( AllLimb );
[ Puwp, phiuwp, nuwp ] = unwrapEP( P, phi, n );
RotEP = EulerP2Rot( P );
RotEPuwp = EulerP2Rot( Puwp );
dif = RotEP-RotEPuwp;
if ~isempty(dif(dif > 10^-8))
    disp('unwrapEP() affected the result of rotation matrices calculated from Euler parameters!')
else
    disp('unwrapEP() won''t affected the result of rotation matrices calculated from Euler parameters!')
end
toc
disp(' ')
%% (iii)
tic
disp('(iii)')
seq = 'zxz';
[ltAV, ltAA] = Ang2LocalAngular( RotAngConvert(lRg2t,seq), seq, smprate );
[rtAV, rtAA] = Ang2LocalAngular( RotAngConvert(rRg2t,seq), seq, smprate );
[lsAV, lsAA] = Ang2LocalAngular( RotAngConvert(lRg2s,seq), seq, smprate );
[rsAV, rsAA] = Ang2LocalAngular( RotAngConvert(rRg2s,seq), seq, smprate );
[lfAV, lfAA] = Ang2LocalAngular( RotAngConvert(lRg2f,seq), seq, smprate );
[rfAV, rfAA] = Ang2LocalAngular( RotAngConvert(rRg2f,seq), seq, smprate );
dataAV = cat(3, ltAV, rtAV, lsAV, rsAV, lfAV, rfAV);%nx3x6
dataAA = cat(3, ltAA, rtAA, lsAA, rsAA, lfAA, rfAA);%nx3x6

[ AngVelEP, AngAccEP ] = Rot2LocalAngularEP( AllLimb, smprate );

data = dataAV; dataEP = AngVelEP;
funname = {'Ang2LocalAngular()','Rot2LocalAngularEP()'};
tilname = {'Angular Velocity', 'Angular Acceleration'};
for i = 1:2
    artiname = {'lThigh','rThigh','lShank','rShank','lFoot','rFoot'};
    figure('Name',[char(tilname(i)),' of Lower Limbs by Ang2LocalAngular() & Rot2LocalAngularEP()',...
        char(funname(i))], 'NumberTitle','off','position',[100+400*i 50 600 700]);
    ylbl = {'Ang. Vel. (rad/s)','Ang. Acc. (rad/s^2)'};
    for j = 1:6
        eval(['ax',num2str(j)]) = subplot(3,2,j);
        hold on
        title(artiname(j))
        a = plot( 1:nframes, data(:,1,j), 'm--');
        b = plot( 1:nframes, data(:,2,j), 'k--');
        c = plot( 1:nframes, data(:,3,j), 'c--');
        d = plot( 1:nframes, dataEP(:,1,j), 'b');
        e = plot( 1:nframes, dataEP(:,2,j), 'g');
        f = plot( 1:nframes, dataEP(:,3,j), 'r');
        ylabel(ylbl(i))
        xlabel('frames')
        xlim([0 nframes])
        if j == 2
            Leg = legend([a; b; c; d; e; f], {'Wx', 'Wy', 'Wz', 'Wx EP', 'Wy EP', 'Wz EP'});
            Pos = get(Leg, 'Position');
            set(Leg, 'Position', [Pos(1)+0.1, Pos(2)+0.09, Pos(3), Pos(4)])
        end
    end
    data = dataAA; dataEP = AngAccEP;
end
disp('Fig. 2 & 3 are plotted.')
toc
