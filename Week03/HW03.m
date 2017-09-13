%%
% Computer Methods in Human Motion Analysis 2017 -- HW3
% Matlab Version: MATLAB R2017a
% Student: ¾÷±ñºÓ¤@ ¤ý«Âµ¾ R05522625

addpath(genpath(fileparts(cd))) % adding all hw directory to PATH.

%% Initialization
clc;
clearvars;
close all;


%% Practice 1
tic
disp('Practice 1')
seq = {'xyx', 'xyz', 'xzy', 'xzx', 'yxy', 'yxz', 'yzy', 'yzx', 'zxy', 'zxz', 'zyx', 'zyz'};
for i=1:length(seq)
    eval(['R',seq{i},'=RotFormula(seq{i});'])
end
clear i seq %clear unwanted variables
save EulerR.mat %save .mat file
disp('Done Saving.')
toc
disp(' ')
%% Practice 2
tic
disp('Practice 2')
load('DataQ1.mat')

[lRg2p, lVg2p, lPcoord_local] = CoordPelvis(cat(3, LASI, LPSI, RASI), 'l', {'LASI', 'LPSI', 'RASI'});
[rRg2p, rVg2p, rPcoord_local] = CoordPelvis(cat(3, LASI, RPSI, RASI), 'r', {'LASI', 'RPSI', 'RASI'});
[lRg2t, lVg2t, lTcoord_local] = CoordThigh(cat(3, LLFC, LTRO, LMFC), 'l', {'LLFC', 'LTRO', 'LMFC'});
[rRg2t, rVg2t, rTcoord_local] = CoordThigh(cat(3, RTRO, RMFC, RLFC), 'r', {'RTRO', 'RMFC', 'RLFC'});
[lRg2s, lVg2s, lScoord_local] = CoordShank(cat(3, LTT, LLMA, LMMA, LSHA), 'l', {'LTT', 'LLMA', 'LMMA', 'LSHA'});
[rRg2s, rVg2s, rScoord_local] = CoordShank(cat(3, RTT, RSHA, RLMA, RMMA), 'r', {'RTT', 'RSHA', 'RLMA', 'RMMA'});
[lRg2f, lVg2f, lFcoord_local] = CoordFoot(cat(3, LHEE, LTOE, LFOO), 'l', {'LHEE', 'LTOE', 'LFOO'});
[rRg2f, rVg2f, rFcoord_local] = CoordFoot(cat(3, RFOO, RHEE, RTOE), 'r', {'RFOO', 'RHEE', 'RTOE'});
n=size(lRg2p,3);

lRp2t = mtimesx(lRg2p, 'T', lRg2t); lRt2p = mtimesx(lRg2t, 'T', lRg2p);
rRp2t = mtimesx(rRg2p, 'T', rRg2t); rRt2p = mtimesx(rRg2t, 'T', rRg2p);
lRt2s = mtimesx(lRg2t, 'T', lRg2s); lRs2t = mtimesx(lRg2s, 'T', lRg2t);
rRt2s = mtimesx(rRg2t, 'T', rRg2s); rRs2t = mtimesx(rRg2s, 'T', rRg2t);
lRs2f = mtimesx(lRg2s, 'T', lRg2f); lRf2s = mtimesx(lRg2f, 'T', lRg2s);
rRs2f = mtimesx(rRg2s, 'T', rRg2f); rRf2s = mtimesx(rRg2f, 'T', rRg2s);

thelpt = RotAngConvert(lRp2t,'zxy');
therpt = RotAngConvert(rRp2t,'zxy');
thelts = RotAngConvert(lRt2s,'zxy');
therts = RotAngConvert(rRt2s,'zxy');
thelsf = RotAngConvert(lRs2f,'zxy');
thersf = RotAngConvert(rRs2f,'zxy');

% (i)
dif1=abs(RotAngConvert(therpt,'zxy')-rRp2t);
if ~isempty(dif1(dif1>10^-10))
    disp('(i) not equal!');
else
    disp('(i) equal!'); 
end
    
% (ii)
dif2=abs(therpt+fliplr(RotAngConvert(rRt2p,'yxz')));
if ~isempty(dif2(dif2>10^-10)) 
    disp('(ii) not equal!');
else
    disp('(ii) equal!'); 
end

% (iii)
dif3=abs(RotAngConvert(rRg2t,'zxy')-fliplr(RotAngConvFix(rRg2t,'yxz')));
if ~isempty(dif3(dif3>10^-10)) 
    disp('(iii) not equal!');
else
    disp('(iii) equal!'); 
end

toc
disp(' ')
%% Practice 3
tic
disp('Practice 3')

% Load data
load('subcali.mat');

% Create Rs
lRg2p = CoordPelvis(cat(3, LASI, LPSI, RASI), 'l', {'LASI', 'LPSI', 'RASI'});
rRg2p = CoordPelvis(cat(3, LASI, RPSI, RASI), 'r', {'LASI', 'RPSI', 'RASI'});
lRg2t = CoordThigh(cat(3, LLFC, LTRO, LMFC), 'l', {'LLFC', 'LTRO', 'LMFC'});
rRg2t = CoordThigh(cat(3, RTRO, RMFC, RLFC), 'r', {'RTRO', 'RMFC', 'RLFC'});
lRg2s = CoordShank(cat(3, LTT, LLMA, LMMA, LSHA), 'l', {'LTT', 'LLMA', 'LMMA', 'LSHA'});
rRg2s = CoordShank(cat(3, RTT, RSHA, RLMA, RMMA), 'r', {'RTT', 'RSHA', 'RLMA', 'RMMA'});
lRg2f = CoordFoot(cat(3, LHEE, LTOE, LFOO), 'l', {'LHEE', 'LTOE', 'LFOO'});
rRg2f = CoordFoot(cat(3, RFOO, RHEE, RTOE), 'r', {'RFOO', 'RHEE', 'RTOE'});
lRspt = lRg2p\lRg2t; rRspt = rRg2p\rRg2t;
lRsts = lRg2t\lRg2s; rRsts = rRg2t\rRg2s;
lRssf = lRg2s\lRg2f; rRssf = rRg2s\rRg2f;

% Create Rc
lRcpt = JointAngOffset( lRspt, lRp2t ); 
rRcpt = JointAngOffset( rRspt, rRp2t );
lRcts = JointAngOffset( lRsts, lRt2s ); rRcts = JointAngOffset( rRsts, rRt2s );
lRcsf = JointAngOffset( lRssf, lRs2f ); rRcsf = JointAngOffset( rRssf, rRs2f );

% Euler angle of Rc
rcpt = RotAngConvert(rRcpt, 'zxy'); lcpt = RotAngConvert(lRcpt, 'zxy'); 
rcts = RotAngConvert(rRcts, 'zxy'); lcts = RotAngConvert(lRcts, 'zxy'); 
rcsf = RotAngConvert(rRcsf, 'zxy'); lcsf = RotAngConvert(lRcsf, 'zxy'); 

% Plot
figname = {'Z', 'X', 'Y'};
artiname = {'lHip','rHip','lKnee','rKnee','lAnkle','rAnkle'};
dataRo = cat(3, thelpt, therpt, thelts, therts, thelsf, thersf);
dataRc = cat(3, lcpt, rcpt, lcts, rcts, lcsf, rcsf);
difRoc = abs(dataRc - dataRo);
frame = 1:n;
for i = 1:3
    figure('Name',char(figname(i)),'NumberTitle','off','position',[400*i-300 50 600 700]);
    hold on
    suptitle(['Euler Angle : ',char(figname(i)),' -axis']);
    for j = 1:6
        eval(['ax',num2str(j)]) = subplot(3,2,j);
        hold on
        title(char(artiname(j)))
        a=plot(frame, dataRo(:,i,j));
        b=plot(frame, dataRc(:,i,j));
        mi = difRoc(:,i,j)==max(difRoc(:,i,j));
        scatter([frame(mi) frame(mi)],[dataRo(mi, i, j) dataRc(mi, i, j)],'k')
        ha = annotation('arrow');  % store the arrow information in ha
        ha.Parent = gca;           % associate the arrow the the current axes
        ha.Y = [dataRo(mi, i, j) dataRc(mi, i, j)];          % the location in data units
        ha.X = [frame(mi) frame(mi)];  
        ylabel('Angle (deg)')
        xlim([0 n]) 
        ylim auto 
        if j == 2
            Leg = legend([a; b], {'Raw', 'Offseted'});
            Pos = get(Leg, 'Position'); 
            set(Leg, 'Position', [Pos(1)+0.1, Pos(2)+0.07, Pos(3), Pos(4)])
        end
    end   
end

disp('Done Plotting.')
toc
save('rotang.mat', 'lRg2t', 'rRg2t', 'lRg2s', 'rRg2s', 'lRg2f', 'rRg2f')


