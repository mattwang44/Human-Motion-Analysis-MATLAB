%%
% Computer Methods in Human Motion Analysis 2017 -- HW7
% Matlab Version: MATLAB R2017a
% Student: ¾÷±ñºÓ¤@ ¤ý«Âµ¾ R05522625

addpath(genpath(fileparts(cd))) % adding all hw directory to PATH.

%% Initialization
clc;
clearvars;
close all;

%% Practice 1
disp('[Practice 1]') 
load('Walk.mat')
nf = size(RASI,1);
shoulderR = [52.52 50.93];
[ bodyCOM7, segCOM7, ~, ~, ~ ] = WholeBodyCOM( MKcoord, mklist, shoulderR, 7 );
[ bodyCOM11, segCOM11, ~, ~, ~ ] = WholeBodyCOM( MKcoord, mklist, shoulderR, 11 );
[ bodyCOM12, segCOM12, ~, ~, ~ ] = WholeBodyCOM( MKcoord, mklist, shoulderR, 12 );
[ bodyCOM13, segCOM13, ~, ~, ~ ] = WholeBodyCOM( MKcoord, mklist, shoulderR, 13 );
disp('Done') 
disp(' ') 
%% Practice 2
disp('[Practice 2]') 

bodyCOMt = cat(3, bodyCOM7,bodyCOM11,bodyCOM12,bodyCOM13);
figure('Name','Comparison of COM Coordinates Calculated by Different Numbers of Limbs', 'NumberTitle','off','position',[100 50 600 700]);
artiname = {'x','y','z'};
for i = 1:3
    subplot(3,1,i)
    hold on
    title(artiname(i))
    for j = 1:4
       plot(1:nf, bodyCOMt(:,i,j))
    end
    if i == 1
        legend({'7','11','12','13'},'Location','northwest')
    end
end
disp('Fig. 1 plotted!') 
figure('Name','Animation of Human Motion', 'NumberTitle','off','position',[600 50 600 700]);
pause(.5)

for i = 1:nf
    hold on
    set(gca,'color','black')
    ax = gca;
    axis equal
    axis([bodyCOM13(i,1)-750 bodyCOM13(i,1)+750 bodyCOM13(i,2)-750 bodyCOM13(i,2)+750 0 2000])
    for j = -500:250:1000
        plot3([j j],[-1500 2000],[0 0],	'Color',[0.1 0.1 0.1]);
    end
    for j = -1500:250:2000
        plot3([-500 1000],[j j],[0 0],	'Color',[0.1 0.1 0.1]);
    end
    
    view(3)
    scatter3(MKcoord(i,1,:),MKcoord(i,2,:),MKcoord(i,3,:),'y')
    scatter3(segCOM13(i,1,:),segCOM13(i,2,:),segCOM13(i,3,:),'g')
    scatter3(bodyCOM13(i,1),bodyCOM13(i,2),bodyCOM13(i,3),'m')
    
    pause(1/60)
    if i ~= nf
        clf
    end
    
end
disp('Fig. 2 plotted!') 