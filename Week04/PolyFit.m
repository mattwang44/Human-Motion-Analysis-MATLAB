function p = PolyFit( xi, yi, n )
% the function derives a curve-fitting polynomial with least-square-error from data.
% xi: x-coordinates of data points [nframes x 1] / [1 x nframes]
% yi: y-coordinates of data points [nframes x 1] / [1 x nframes]
% n: the highest power of the polynomial [1 x 1]
% p: coefficient of polynomial (power down) [(n+1) x 1]

if ~isequal(size(xi),size(yi))
    error('x and y must be the same size.')
end
if ~isequal(size(xi,2),size(yi,2),1) || ~isequal(ndims(xi),ndims(yi),2)
    warning('x and y should be the format of [nframes x 1]. Modified automatically.')
    xi = xi(:);    yi = yi(:);
end

% Construct Vandermonde matrix.
V(:,n+1) = ones(length(xi),1);
for j = n:-1:1
   V(:,j) = xi.*V(:,j+1);
end

% Solve least squares problem.
% Method 1:
p1 = (V.' * V) \ V.' *yi; p1 = p1.';
% Method 2:
[Q,R] = qr(V,0);
p2 = R\(Q'*yi); p2 = p2.';

% choose the one with smaller summation of least square error
if sum((PolyVal(p1, xi)-yi).^2,1) < sum((PolyVal(p2, xi)-yi).^2,1)
    p = p1;c = 'r';
else
    p = p2;c = 'k';
end


% close all
% hold on
% scatter(xi,yi)
% x = linspace(max(xi),min(xi),length(xi)*10);
% y = PolyVal(p1, x);
% po = polyfit(xi,yi,n);
% yo = PolyVal(po, x);
% plot(x,y,c)
% plot(x,yo,'b')
% disp('p diff:')
% norm(p1-po)
% disp('P')
% sum((polyval(p1, xi)-yi).^2,1)
% disp('p')
% sum((polyval(po, xi)-yi).^2,1)
% sum((polyval(p1, xi)-yi).^2,1)-sum((polyval(po, xi)-yi).^2,1)

end

