%%
% Computer Methods in Human Motion Analysis 2017 -- HW9

% Matlab Version:      MATLAB R2017a 
% Operating System     Ubuntu (Linux)
% Student:            Wei-hsiang Wang
% Department:         Mechanical Engineering
% Student ID:         R05522625 

addpath(genpath(fileparts(cd))) % adding all hw directory to PATH.

%% Initialization
clc;
clearvars;
% close all;

%% 
seq = {'RASI','LASI','RPSI','LPSI','L4L5','LPET','RPET','RTRO','RLFC','RMFC','RTHI','RTT','RSHA',...
    'RLMA','RMMA','RTIB','RHEE','RFOO','RTOE','RMTH','LTRO','LLFC','LMFC','LTHI','LTT','LSHA','LLMA',...
    'LMMA','LTIB','LHEE','LFOO','LTOE','LMTH','C7T1','LBTO','LFRM','LHead','LRM','LSAP','LUM','LUPA',...
    'LUS','LWRA','RBTO','RFRM','RHead','RRM','RSAP','RUM','RUPA','RUS','RWRA'};
load('subcali.mat') 
load('DataSTS.mat') 
nf = size(MKtraj,1);
[ bodyCOM, segCOM, ~, ~, ~ ] = WholeBodyCOM( MKtraj, mklist, shoulderR, 7 );
TimeSeq = reshape(1/smprate:1/smprate:nf/smprate,[],1);%nx1
bodyCOMVecX =  Derivative( TimeSeq, bodyCOM(:,1), 1 );
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
fpF_local1 = [Fx1,Fy1,Fz1];
fpF_local2 = [Fx2,Fy2,Fz2];
fpF_local = cat(3, fpF_local1, fpF_local2);
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

%%
for i = 1:length(seq)
    index = find(strcmp(mklist,seq(i)));
    if ~isempty(index)
        eval(string(seq{i})+'=MKtraj(:,:,index);')
    end
end
[lRg2p, lVg2p, lPcoord_local] = CoordPelvis(cat(3, LASI, LPSI, RASI), 'l', {'LASI', 'LPSI', 'RASI'});
[rRg2p, rVg2p, rPcoord_local] = CoordPelvis(cat(3, LASI, RPSI, RASI), 'r', {'LASI', 'RPSI', 'RASI'});
[lRg2t, lVg2t, lTcoord_local] = CoordThigh(cat(3, LLFC, LTRO, LMFC), 'l', {'LLFC', 'LTRO', 'LMFC'});
[rRg2t, rVg2t, rTcoord_local] = CoordThigh(cat(3, RTRO, RMFC, RLFC), 'r', {'RTRO', 'RMFC', 'RLFC'});
[lRg2s, lVg2s, lScoord_local] = CoordShank(cat(3, LTT, LLMA, LMMA, LSHA), 'l', {'LTT', 'LLMA', 'LMMA', 'LSHA'});
[rRg2s, rVg2s, rScoord_local] = CoordShank(cat(3, RTT, RSHA, RLMA, RMMA), 'r', {'RTT', 'RSHA', 'RLMA', 'RMMA'});
[lRg2f, lVg2f, lFcoord_local] = CoordFoot(cat(3, LHEE, LTOE, LFOO), 'l', {'LHEE', 'LTOE', 'LFOO'});
[rRg2f, rVg2f, rFcoord_local] = CoordFoot(cat(3, RFOO, RHEE, RTOE), 'r', {'RFOO', 'RHEE', 'RTOE'});

lRp2t = mtimesx(lRg2p, 'T', lRg2t); lRt2p = mtimesx(lRg2t, 'T', lRg2p);
rRp2t = mtimesx(rRg2p, 'T', rRg2t); rRt2p = mtimesx(rRg2t, 'T', rRg2p);
lRt2s = mtimesx(lRg2t, 'T', lRg2s); lRs2t = mtimesx(lRg2s, 'T', lRg2t);
rRt2s = mtimesx(rRg2t, 'T', rRg2s); rRs2t = mtimesx(rRg2s, 'T', rRg2t);
lRs2f = mtimesx(lRg2s, 'T', lRg2f); lRf2s = mtimesx(lRg2f, 'T', lRg2s);
rRs2f = mtimesx(rRg2s, 'T', rRg2f); rRf2s = mtimesx(rRg2f, 'T', rRg2s);

thelpt = RotAngConvert(lRp2t,'xyz');
therpt = RotAngConvert(rRp2t,'xyz');
thelts = RotAngConvert(lRt2s,'xyz');
therts = RotAngConvert(rRt2s,'xyz');
thelsf = RotAngConvert(lRs2f,'xyz');
thersf = RotAngConvert(rRs2f,'xyz');


%%
for i = 1:length(seq)
    index = find(strcmp(mklist,seq(i)));
    if ~isempty(index)
        eval(string(seq{i})+'=MKpose(:,:,index);')
    end
end
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
lRcpt = JointAngOffset( lRspt, lRp2t ); rRcpt = JointAngOffset( rRspt, rRp2t );
lRcts = JointAngOffset( lRsts, lRt2s ); rRcts = JointAngOffset( rRsts, rRt2s );
lRcsf = JointAngOffset( lRssf, lRs2f ); rRcsf = JointAngOffset( rRssf, rRs2f );

% Euler angle of Rc
rcpt = RotAngConvert(rRcpt, 'xyz'); lcpt = RotAngConvert(lRcpt, 'xyz'); 
rcts = RotAngConvert(rRcts, 'xyz'); lcts = RotAngConvert(lRcts, 'xyz'); 
rcsf = RotAngConvert(rRcsf, 'xyz'); lcsf = RotAngConvert(lRcsf, 'xyz'); 
lcpt = interp1(TimeSeq,lcpt,linspace(Time1,Time4,100)/smprate);
rcpt = interp1(TimeSeq,rcpt,linspace(Time1,Time4,100)/smprate);
lcts = interp1(TimeSeq,lcts,linspace(Time1,Time4,100)/smprate);
rcts = interp1(TimeSeq,rcts,linspace(Time1,Time4,100)/smprate);
lcsf = interp1(TimeSeq,lcsf,linspace(Time1,Time4,100)/smprate);
rcsf = interp1(TimeSeq,rcsf,linspace(Time1,Time4,100)/smprate);
%
dataRc = cat(3, lcpt, rcpt, lcts, rcts, lcsf, rcsf);
figure('Name','Joint Angle', 'NumberTitle','off','position',[0 50 1680 750]);
dirname = {'Abd(+)/Adduction(-)','Internal(+)/External(-) rotation','Flex(+)/Extension(-)'};
artiname = {'Hip','Knee','Ankle'};
for i = 1:3
    for j = 1:3
        subplot(3,3,3*(j-1)+i)
        hold on
        ran = cat(3,-dataRc(:,i,2*j-1), dataRc(:,i,2*j));
        if i == 3
            ran = cat(3,dataRc(:,i,2*j-1), dataRc(:,i,2*j));
            if j == 2
                ran = cat(3,-dataRc(:,i,2*j-1), -dataRc(:,i,2*j));
            end
        end
        plot([Time1s,Time1s],[min(ran(:)) max(ran(:))],'k--',[Time2s,Time2s],[min(ran(:)) max(ran(:))],'k--',[Time4s,Time4s],[min(ran(:)) max(ran(:))],'k--',[Time3s,Time3s],[min(ran(:)) max(ran(:))],'k--')
        ylim([min(ran(:)) max(ran(:))])
        plot(ran(:,:,1))
        plot(ran(:,:,2))
        if j == 1
            title(dirname(i))
        end
        if i == 1
            ylabel([artiname(j),'(deg)'])
        end
    end
end