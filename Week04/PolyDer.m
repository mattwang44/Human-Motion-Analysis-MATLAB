function dp = PolyDer( p, dorder )
% the function the coefficients of polynmial with dth-order of derivation.
% p: coefficient of original polynomial (power down) [(n+1) x 1]
% dorder: order of derivation [1 x 1] / [1 x N]
% dp: coefficient of derivative polynomial (power down) [(n+1-dorder) x 1]

% E.g.
% >> PolyDer( 1:7,  0:7)
% 
% ans =
% 
%      1     2     3     4     5     6     7
%      0     6    10    12    12    10     6
%      0     0    30    40    36    24    10
%      0     0     0   120   120    72    24
%      0     0     0     0   360   240    72
%      0     0     0     0     0   720   240
%      0     0     0     0     0     0   720
%      0     0     0     0     0     0     0


if ~isequal(size(p,1),1) || ~isequal(ndims(p),2)
    warning('p should be the format of [1 x n]. Modified automatically.')
    p = reshape(p, 1, []); 
end

if ~isequal(size(dorder,1), size(dorder,2), 1)
    d = dorder(:);
    dp = zeros(length(d), size(p,2));
    for i = 1:length(d)
        dp(i,d(i)+1:size(p,2)) = derivation( p, d(i) );
    end
    
else
    dp = derivation( p, dorder );
end

function np =  derivation( p, d )
n = length(p);
if d == 0
    np = p;
    return
elseif d >= n
    np = 0;
    return
end
sq = fliplr(d:n-1);
np = p(1:n-d);
for i = 1:d
    np = np .* (sq - i + 1);
end



