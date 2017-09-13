function theta = Rot2Ang( Rot, sequence )
% The function derives the Euler angles from rotation matrices

% Rot: Rotation matrix [3 x 3 x nframes]
% sequence: sequence of the Euler angles '1 x 3' (composed of 'x', 'y', 'z')

% Validation of rotation matrice (dimension)
if ~isequal(3,size(Rot,1),size(Rot,2))
    errordlg('Please enter the rotation matrice in the form of [3 x 3 x n] matrices.', 'Rotation Matrices Input Error');return
end
eval(['R',sequence,'=RotFormula(sequence);'])
nframes = size(Rot,3);

t1 = zeros(1,1,nframes);t2 = zeros(1,1,nframes);t3 = zeros(1,1,nframes);
switch sequence
    case 'zxy'
        t3 = atan2d(-Rot(3,1,:), Rot(3,3,:));
        t1 = atan2d(-Rot(1,2,:), Rot(2,2,:));
        t2 = asind(Rot(3,2,:));
    case 'yxz'
        t3 = atan2d(Rot(2,1,:), Rot(2,2,:));
        t1 = atan2d(Rot(1,3,:), Rot(3,3,:));
        t2 = asind(-Rot(2,3,:));   
    case 'xyz'
        t3 = atan2d(-Rot(1,2,:), Rot(1,1,:));
        t1 = atan2d(-Rot(2,3,:), Rot(3,3,:));
        t2 = asind(Rot(1,3,:));
    case 'zyx'       
        t3 = atan2d(Rot(3,2,:), Rot(3,3,:));
        t1 = atan2d(Rot(2,1,:), Rot(1,1,:));
        t2 = asind(-Rot(3,1,:));
    case 'xyx'
        t3 = atan2d(Rot(1,2,:), Rot(1,3,:));
        t2 = acosd(Rot(1,1,:));
        t1 = atan2d(Rot(2,1,:), -Rot(3,1,:));     
    case 'xzx'
        t1 = atan2d(Rot(3,1,:), Rot(2,1,:));
        t3 = atan2d(Rot(1,3,:), -Rot(1,2,:));
        t2 = acosd(Rot(1,1,:));
    case 'xzy'
        t1 = atan2d(Rot(3,2,:), Rot(2,2,:));
        t3 = atan2d(Rot(1,3,:), Rot(1,1,:));
        t2 = asind(-Rot(1,2,:));
    case 'yzx'
        t1 = atan2d(-Rot(3,1,:), Rot(1,1,:));
        t3 = atan2d(-Rot(2,3,:), Rot(2,2,:));
        t2 = asind(Rot(2,1,:));
    case 'yxy'
        t3 = atan2d(Rot(2,1,:), -Rot(2,3,:));
        t1 = atan2d(Rot(1,2,:), Rot(3,2,:));
        t2 = acosd(Rot(2,2,:));
    case 'yzy'
        t1 = atan2d(Rot(3,2,:), -Rot(1,2,:));
        t3 = atan2d(Rot(2,3,:), Rot(2,1,:));
        t2 = acosd(Rot(2,2,:));
    case 'zxz'
        t1 = atan2d(Rot(1,3,:), -Rot(2,3,:));
        t3 = atan2d(Rot(3,1,:), Rot(3,2,:));
        t2 = acosd(Rot(3,3,:));
    case 'zyz'        
        t1 = atan2d(Rot(2,3,:), Rot(1,3,:));
        t3 = atan2d(Rot(3,2,:), -Rot(3,1,:));
        t2 = acosd(Rot(3,3,:));
end
the = [t1 t2 t3];

t1 = t1*pi/180;t2 = t2*pi/180;t3 = t3*pi/180;

wi = [];
R = eval(eval(['R',sequence]));

for i = 1:nframes
    dif = R(:,:,i)-Rot(:,:,i);
    if ~isempty(dif(dif>10^-3))
        wi = [wi,i];
    end
end
if ~isempty(wi)
    switch sequence
        case 'zxy'
            t3 = atan2d(Rot(3,1,:), -Rot(3,3,:));
            t1 = atan2d(Rot(1,2,:), -Rot(2,2,:));
            t2 = 180 - asind(Rot(3,2,:));    
        case 'yxz'
            t3 = atan2d(-Rot(2,1,:), -Rot(2,2,:));
            t1 = atan2d(-Rot(1,3,:), -Rot(3,3,:));
            t2 = 180 - asind(-Rot(2,3,:)); 
        case 'xyz'        
            t3 = atan2d(Rot(1,2,:), -Rot(1,1,:));
            t1 = atan2d(Rot(2,3,:), -Rot(3,3,:));
            t2 = 180 - asind(Rot(1,3,:));
        case 'zyx'       
            t3 = atan2d(-Rot(3,2,:), -Rot(3,3,:));
            t1 = atan2d(-Rot(2,1,:), -Rot(1,1,:));
            t2 = 180 - asind(-Rot(3,1,:));
        case 'xyx'
            t3 = atan2d(-Rot(1,2,:), -Rot(1,3,:));
            t2 = -acosd(Rot(1,1,:));
            t1 = atan2d(-Rot(2,1,:), Rot(3,1,:));  
        case 'xzx'
            t1 = atan2d(-Rot(3,1,:), -Rot(2,1,:));
            t3 = atan2d(-Rot(1,3,:), Rot(1,2,:));
            t2 = -acosd(Rot(1,1,:));
        case 'xzy'
            t1 = atan2d(-Rot(3,2,:), -Rot(2,2,:));
            t3 = atan2d(-Rot(1,3,:), -Rot(1,1,:));
            t2 = 180 - asind(-Rot(1,2,:));
        case 'yzx'
            t1 = atan2d(Rot(3,1,:), -Rot(1,1,:));
            t3 = atan2d(Rot(2,3,:), -Rot(2,2,:));
            t2 = 180 - asind(Rot(2,1,:));
        case 'yxy'
            t3 = atan2d(-Rot(2,1,:), Rot(2,3,:));
            t1 = atan2d(-Rot(1,2,:), -Rot(3,2,:));
            t2 = -acosd(Rot(2,2,:));    
        case 'yzy'
            t1 = atan2d(-Rot(3,2,:), Rot(1,2,:));
            t3 = atan2d(-Rot(2,3,:), -Rot(2,1,:));
            t2 = -acosd(Rot(2,2,:));
        case 'zxz'
            t1 = atan2d(-Rot(1,3,:), Rot(2,3,:));
            t3 = atan2d(-Rot(3,1,:), -Rot(3,2,:));
            t2 = -acosd(Rot(3,3,:));
        case 'zyz'        
            t1 = atan2d(-Rot(2,3,:), -Rot(1,3,:));
            t3 = atan2d(-Rot(3,2,:), Rot(3,1,:));
            t2 = -acosd(Rot(3,3,:));
    end    
end
the(:,:,wi)=[t1(:,:,wi) t2(:,:,wi) t3(:,:,wi)];
t1 = t1*pi/180;t2 = t2*pi/180;t3 = t3*pi/180;
theta = permute(the, [ 3 2 1 ]);
% 
% wi = [];
% for i = 1:nframes
%     dif = R(:,:,i)-Rot(:,:,i);
%     if ~isempty(dif(dif>10^-6))
%         wi = [wi,i];
%     end
% end
% if ~isempty(wi)
%     disp('error')
%     length(wi)
% end
%    