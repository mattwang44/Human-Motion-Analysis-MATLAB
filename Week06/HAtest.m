function HAtest
n = 200;
prinV = rand(1,3);
prinV = prinV./norm(prinV);
lineP = 100*round((rand(1,3)-0.5)*10);
t = 50*rand(1);
sphereO = lineP + t*prinV;
r = (t/2)*rand(n,1);
theta = (2*pi)*rand(n,1);
phi = (2*pi)*rand(n,1);
p = ones(n,1)*sphereO + [r.*cos(phi).*cos(theta) r.*cos(phi).*sin(theta) r.*sin(phi)];
noise = (max(r)/8)*(rand(n,3)-.5);
noiseCenter = ones(n,1)*lineP + noise;
p2 = 2*noiseCenter - p;
u = p2 - p;
[o,E,v] = HelicalAxesCenter(u,p);
figure
plot3(lineP(1),lineP(2),lineP(3),'ob','linewidth',2,'markersize',10),hold on
plot3(o(1),o(2),o(3),'oc','linewidth',2,'markersize',10),legend('Theoritical position','Least-Square')
h = plot3([p(:,1) p2(:,1)].',[p(:,2) p2(:,2)].',[p(:,3) p2(:,3)].');
set(h,'color',[1 .7 .7])
L = sqrt(sum(u.*u,2));
L = (mean(L)+3*std(L))/2;
meanD = [o-L*v;o+L*v];
plot3(meanD(:,1),meanD(:,2),meanD(:,3),'g','linewidth',2)
title({['Error: ' num2str(norm(o-lineP),'%0.2f')];['Residual error: ' num2str(E,'%0.2f')]})
cameratoolbar, axis equal
end