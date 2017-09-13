% Calculate by Sphere fitting
load('HipROM.mat')
[lRg2p, lVg2p, ~] = CoordPelvis(cat(3, LASI, LPSI, RASI), 'l', {'LASI', 'LPSI', 'RASI'});
[lRg2t, lVg2t, ~] = CoordThigh(cat(3, LLFC, LTRO, LMFC), 'l', {'LLFC', 'LTRO', 'LMFC'});
[~, lVg2s, ~] = CoordShank(cat(3, LTT, LLMA, LMMA, LSHA), 'l', {'LTT', 'LLMA', 'LMMA', 'LSHA'});
marker = {'LTRO','LLFC','LMFC','Average Center','Origin'};
nf = size(lRg2t,3);
Col = [(1:nf)/nf; -(-nf:-1)/nf; ones(1,nf)*1].';
c = [];
for i = 1:3
    T = marker{i};
    Tar = eval(T);
    
    PT = CoordG2L( lRg2p, lVg2p, Tar );
    
    [C,Radius] = sphereFit(PT);
    
%     figure(i)
%     view(3)
%     title([string(T),'center: '+string(C(1))+', '+string(C(2))+', '+string(C(3))])
%     hold on
%     grid on
%     axis equal
%    
%     scatter3(PT(:,1),PT(:,2),PT(:,3),repmat(3,nf,1),Col)
%     scatter3(0,0,0,'k')
%     text(0,0,0,'origin')
%     scatter3(C(1),C(2),C(3))
%     text(C(1),C(2),C(3),'center')
%     plot3(C(1),C(2),C(3))
%     
%     figure(4)
%     axis equal
%     hold on
%     plot3(PT(:,1),PT(:,2),PT(:,3))
    c = cat(1, c, C);
end
% grid on
c = sum(c,1)/3;
% title(['average center: '+string(c(1))+', '+string(c(2))+', '+string(c(3))])
% scatter3(c(:,1),c(:,2),c(:,3))
% view(3)
% scatter3(0,0,0,'k')
% legend(marker)
disp('Calculated by Sphere Fitting:')
disp('The estimate hip center joint is (' + string(c(1)) + ', ' + string(c(2)) + ', '+ string(c(3)) + ').' )
