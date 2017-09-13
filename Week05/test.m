close all
phi = linspace(0,6*pi,180);
phiL = length(phi);
theta = [zeros(phiL,1) phi.' zeros(phiL,1)];
R = Ang2Rot(theta/pi*180,'xyz');
[P, phi, n] = Rot2EulerP(R);
find(sign(diff(P,1,1))==-1);
find(sign(diff(phi))==-1);
find(sign(diff(n))==-1);

i=1;
subplot(3,2,1+1*(i-1))
%plot(1:phiL,Derivative(a(:),P(:,1,:),1))
plot(1:phiL,P)
subplot(3,2,3+1*(i-1))
plot(1:phiL,phi)
subplot(3,2,5+1*(i-1))
plot(1:phiL,n)
% size(P)
% size(phi)
% size(n)
[ P, phi, n ] = unwrapEP( P, phi, n );
% size(P)
% size(phi)
% size(n)
i=2;
subplot(3,2,1+1*(i-1))
%plot(1:phiL,Derivative(a(:),P(:,1,:),1))
plot(1:phiL,P)
subplot(3,2,3+1*(i-1))
plot(1:phiL,phi)
subplot(3,2,5+1*(i-1))
plot(1:phiL,n)


