function Output = RotAngConvFix( Input, sequence )
% The function cenvert between rotation matrices and Fix angles

% sequence: sequence of the Euler angles '1 x 3' (composed of 'x', 'y', 'z')
% Input:  rotation matrices [3 x 3 x nframes] / Fix angles [nframes x 3]
% Output: Fix angles [nframes x 3] / rotation matrices [3 x 3 x nframes]

if ndims(Input)==3
    id = 'm';     
elseif ndims(Input)==2
    if size(Input, 1)~=3
        id = 'a';       
    elseif abs(det(Input)-1)>10^-12
        id = 'a';
    else
        text = [strrep(char(sym(Input)),'matrix',''),' ¡÷ det(Input)=1. Is the input matrx a single-frame ROTATION MATRIX or a 3-frames FIXED ANGLE ?'];
        choice = questdlg(text,'Can`t Judge the Form of the Matrix.','Rotation Matrix','Euler Angles','Cancel','Cancel');
        
        switch choice
            case 'Rotation Matrix'
                id = 'm';   
            case 'Fixed Angles'
                id = 'a';  
            case 'Cancel'
                return
        end
    end
else
    errordlg('Wrong input format! [3 x 3 x nframes] for rotation matrice and [nframes x 3] for Euler angles.', 'Input Error');return
end
    
sequence = fliplr(sequence);

switch id
    case 'm' % rotation matrix
        Output = fliplr(Rot2Ang(Input,sequence));
        if nargout == 0
            nframes = size(Input, 3);
            disp(['Input form: ROTATION MATRICE [3 x 3 x ', num2str(nframes),' frames ] '])
            disp('Fixed angles =')        
            disp(num2str(Output))
        end
    case 'a' % rotation angle
        Input = fliplr(Input);
        Output = Ang2Rot(Input,sequence);
        if nargout == 0
            nframes = size(Input, 1);
            disp(['Input form: FIXED ANGLE [ ', num2str(nframes),' frames x 3 ] '])
            disp('Rotation matrice =')       
            disp(num2str(Output))
        end
        
end

