%Calculate by Circumcenter & Intersection Point Fitting
load('HipROM.mat')
[lRg2p, lVg2p, ~] = CoordPelvis(cat(3, LASI, LPSI, RASI), 'l', {'LASI', 'LPSI', 'RASI'});
[lRg2t, lVg2t, ~] = CoordThigh(cat(3, LLFC, LTRO, LMFC), 'l', {'LLFC', 'LTRO', 'LMFC'});
[~, lVg2s, ~] = CoordShank(cat(3, LTT, LLMA, LMMA, LSHA), 'l', {'LTT', 'LLMA', 'LMMA', 'LSHA'});
marker = {'LTRO','LLFC','LMFC'};
o = [];
c = [];
for i = 1:3
    T = marker{i};
    Tar = eval(T);
    
    PT = CoordG2L( lRg2p, lVg2p, Tar );
    nf = size(PT,1);
    S  = floor(nf/3);
    PT = PT(1:S*3,:);
    
    DT = triangulation(reshape(1:S*3,[],3),PT);
    CC = circumcenter(DT,[1:floor(nf/3)]');
    UU = cross(PT(1:S,:)-PT(S+1:2*S,:),PT(2*S+1:end,:)-PT(1:S,:));
    [O, E, ~] = HelicalAxesCenter( UU, CC );
    
%     figure(i)
%     view(3)
%     title([string(T),'center: '+string(O(1))+', '+string(O(2))+', '+string(O(3))])
%     hold on
%     axis equal
%     plot3(PT(1:S,1),PT(1:S,2),PT(1:S,3),'r')
%     text(PT(1,1),PT(1,2),PT(1,3),'1','color','r')
%     plot3(PT(S:2*S,1),PT(S:2*S,2),PT(S:2*S,3),'g')
%     text(PT(S+1,1),PT(S+1,2),PT(S+1,3),'2','color','g')
%     plot3(PT(2*S:end,1),PT(2*S:end,2),PT(2*S:end,3),'b')
%     text(PT(2*S+1,1),PT(2*S+1,2),PT(2*S+1,3),'3','color','b')

%     scatter3(0,0,0,'k')
%     text(0,0,0,'origin')
%     scatter3(O(1),O(2),O(3))
%     text(O(1),O(2),O(3),'center')
%     plot3(O(1),O(2),O(3))
    
%     figure(4)
%     axis equal
%     hold on
%     plot3(PT(:,1),PT(:,2),PT(:,3))
%     text(O(1),O(2),O(3),(marker{i}))
    o = cat(1, o, O);
end
% legend(marker)
% scatter3(o(:,1),o(:,2),o(:,3))
o = sum(o,1)/3;
% title(['average center: '+string(o(1))+', '+string(o(2))+', '+string(o(3))])
% 
% view(3)
% scatter3(0,0,0,'k')
% text(0,0,0,'origin')
disp('Calculated by Circumcenter & Intersection Point Fitting:')
disp('The estimate hip center joint is (' + string(o(1)) + ', ' + string(o(2)) + ', '+ string(o(3)) + ').' )
