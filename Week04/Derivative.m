function dyi = Derivative( xi, yi, dorder )
% dorder-th derivative of data

% xi: x-coordinates of data points [nframes x 1] / [1 x nframes]
% yi: y-coordinates of data points [nframes x 1] / [1 x nframes]
% dorder: order of derivative
% dyi: derivative of yi

if ~isequal(size(xi),size(yi))
    error('x and y must be the same size.')
end
if ~isequal(size(xi,2),1) && ~isequal(size(xi,1),1) || ~isequal(ndims(xi),2)
    warning('x and y should be the format of [nframes x 1] or [1 x nframes]. Modified to [nframes x 1] when calculation automatically.')  
end
xir = xi(:);    yir = yi(:);

% method 1
% fpp = fit(xir,yir,'smoothingspline','SmoothingParam',1-10e-10);
% fpp.p = fnder(fpp.p, dorder);
% dyi = fpp(xir);
% dyi = reshape(dyi,size(yi));   

% method 2
sp = csapi(xir, yir);
sp = fnder(sp, dorder);
dyi = fnval(sp, xir);

% method 3
% for i = 1:dorder
%     yir = diff([eps; yir(:)])./diff([eps; xir(:)]);
% end
% dyi = yir;

end

