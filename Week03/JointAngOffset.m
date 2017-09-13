function Rc = JointAngOffset( Rs, Rd )
% The function output rotation matrices ,represent angle between two body segments,
% which have been offsetted by the static position (anatomical position).

% Rc: output offsetted rotation matrices [3 x 3 x nframes]
% Rs: static rotation matrices representing angle between two body segments (anatomical position) [3 x 3]
% Rd: dynamic rotation matrices representing angle between two body segments [3 x 3 x nframes]

if isequal(size(Rd,1), size(Rd,2), size(Rs,1), size(Rs,2), 3) && numel(Rs)==9
    nframes = size(Rd,3);
else
    errordlg('Please enter the correct form of rotation matrice. (Rs[3x3], Rd[3x3xn])', 'JointAngOffset');return
end
    
Rc = mtimesx( repmat(Rs.', 1, 1, nframes),Rd);

