function Rot = Ang2Rot( theta, sequence )
% The function derives the rotation matrices from Euler angles

% Rot: Rotation matrix [3 x 3 x nframes]
% sequence: sequence of the Euler angles '1 x 3' (composed of 'x', 'y', 'z')

% Validation of rotation angles 
if size(theta,2)~=3 || ndims(theta)~=2
    errordlg('Please enter the rotation angles in the form of [n x 3] array in degrees.', 'Rotation Angle Input Error');return
end

eval(['R',sequence,'=RotFormula(sequence);']);

nframes = size(theta,1);
Rot = zeros(3,3,nframes);

for i = 1:nframes
    t1 = theta(i,1)/180*pi; t2 = theta(i,2)/180*pi;t3 = theta(i,3)/180*pi;
    Rot(:,:,i)=eval(eval(['R',sequence]));
end

end