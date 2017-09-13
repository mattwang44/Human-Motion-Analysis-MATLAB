function theta = Rot2AngFSOLVE( Rot, sequence )
% The function derives the Euler angles from rotation matrice
% Rot: Rotation matrix [3 x 3 x nframes]
% sequence: sequence of the Euler angles '1 x 3' (composed of 'x', 'y', 'z')

% Validation of rotation matrice (dimension)
if ~isequal(3,size(Rot,1),size(Rot,2))
    errordlg('Please enter the rotation matrice in the form of [3 x 3 x n] matrice.', 'Rotation Matrice Input Error');return
end

nframes = size(Rot,3);
theta = zeros(nframes,3);

% Eliminate the error when at least one component of Rot is zero
% Rot = fix(10^17*Rot)/10^17;
Rot(abs(Rot)<10^-12) = 0;


% Validation of rotation matrice (determinant)
dmtmo = ones(1, nframes);% DeterMinanT Minus One
for i=1:nframes
    dmtmo(i) = det(Rot(:,:,i))-1;
end
if ~isempty(dmtmo(dmtmo>10^-12))
    text = ['Rotation matrice have wrong forms (determinant is not equal to 1). Matrice of frame no. = ('... 
        ,num2str(find(abs(dmtmo)>10^-12)), ') have problems.'];
    errordlg(text, 'Rotation Matrice Error');
end

% fsolve
options = optimset('Display','off','Algorithm','levenberg-marquardt','MaxIter',400000,'TolFun',10^-12);
for i = 1:nframes
    eqn = matlabFunction(genEq( Rot(:,:,i), sequence ));
    modeqn = @(t)eqn(t(1),t(2),t(3));
    the = fsolve(modeqn,[pi/4;10^3;10^3],options);
    theta(i,:) = reshape(the*180/pi,1,[]);
    theta(i,:) = degcst(theta(i,:));
end

% Generate equations for 'fsolve'
function F = genEq( Rot, sequence )
eval(['R',sequence,'=RotFormula(sequence);']);
l=reshape(eval(['R',sequence])-Rot, 1, []);
for i=1:length(l)
    F(i)=l(i);
end

% Constraint of output degree: 0 <= theta < 360
function F = degcst(X)
for j = 1:3
    if X(1,j)>360
        X(1,j)=X(1,j)-floor(X(1,j)/360)*360;
        continue
    elseif X(1,j)<=0
        X(1,j)=X(1,j)-floor(X(1,j)/360)*360;
        continue
    end
end
F=X;

