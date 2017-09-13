function yi = PolyVal( p, xi )
% the function gives the predicted value of yi 

% xi: x-coordinates of data points [nframes x 1]
% yi: prediction of y-coordinates of data points [nframes x 1]

if ~isequal(size(xi,2),1) || ~isequal(ndims(xi),2)
    warning('x should be the format of [nframes x 1]. Modified automatically.')
    xi = xi(:); 
end
if ~isequal(size(p,1),1) || ~isequal(ndims(p),2)
    warning('p should be the format of [1 x n]. Modified automatically.')
    p = reshape(p, 1, []); 
end
n = length(p)-1;
y(:,n+1) = ones(length(xi),1);
for j = n:-1:1
   y(:,j) = xi.*y(:,j+1);
end

yi = sum(p.*y,2);

end

