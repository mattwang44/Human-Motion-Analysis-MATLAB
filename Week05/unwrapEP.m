function [ Pi, phii, ni ] = unwrapEP( P, phi, n )


% P: Euler parameters(normalized quaternion) [nframes x 4 x N(segments)]
% phi: the rotation angles rotate about the axis (radians) [nframes x N(segments)]
% n: unit vectors of the rotation axis [nframes x 3 x N(segments)]

if size(P,2)~=4
    error('4')
elseif size(n,2)~=3
    error('3')
elseif ~isequal(size(P,1), size(phi,1), size(n,1))
    error('nframes')
else
    nf = size(P,1);
end
if ~isequal(size(P,3), size(phi,2), size(n,3))
    error('nframes')
else
    N = size(P,3);
end

n = permute(n, [1 3 2]);P = permute(P, [1 3 2]);

difP = diff(P,1,1);%n-1 x N x 4
normp = sqrt(sum(abs(difP).^2,3));%n-1 x N x 1
Ip = zeros(nf,N); 
for i = 1:N
    I = normp(:,i) >= 1;
    I = cat(1, 0, I);
    im = (-1).^cumsum(I);
    Ip(:,i) = im;
end

phii=phi.*Ip;Pi=P.*Ip;
%ni = P(:,:,2:4)./sin(phii/2);
ni=n.*Ip;
% phii = unwrap(phii);

difn = diff(ni,1,1);
normn = sqrt(sum(abs(difn).^2,3));
In = zeros(nf,N);
for i = 1:N
    I = normn(:,i) >= 1;
    I = cat(1, 0, I);
    im = (-1).^cumsum(I);
    In(:,i) = im;
end
ni=ni.*In;phii=phii.*In;
phii = unwrap(phii);


Pi = ipermute(Pi, [1 3 2]);
ni = ipermute(ni, [1 3 2]);


end


