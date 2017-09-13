function R = RotFormula( sequence )
% This function returns a symbolic Euler rotation matrix. The input 
% argument, 'sequence', is a string only composed of character 'x', 'y', 
% and 'z'. The symbols of rotation angles are t1, t2, ...tn, where n is the
% number of characters in the variable 'sequence'.
%
% E.g.  
%
% >> R = RotFormula( 'xxxx' )
%  
% R =
% [ 1,                      0,                       0]
% [ 0, cos(t1 + t2 + t3 + t4), -sin(t1 + t2 + t3 + t4)]
% [ 0, sin(t1 + t2 + t3 + t4),  cos(t1 + t2 + t3 + t4)]
%
% >> R = RotFormula( '' )
%  
% R =
% [ 1, 0, 0]
% [ 0, 1, 0]
% [ 0, 0, 1]
% 
% >> R = RotFormula( 'xzy' )
%  
% R =
% [                           cos(t2)*cos(t3),        -sin(t2),                           cos(t2)*sin(t3)]
% [ sin(t1)*sin(t3) + cos(t1)*cos(t3)*sin(t2), cos(t1)*cos(t2), cos(t1)*sin(t2)*sin(t3) - cos(t3)*sin(t1)]
% [ cos(t3)*sin(t1)*sin(t2) - cos(t1)*sin(t3), cos(t2)*sin(t1), cos(t1)*cos(t3) + sin(t1)*sin(t2)*sin(t3)]

n = length(sequence);
var = sym('t', [1 n]);% Create t1 t2 t3
R = sym(eye(3));
for i = 1:n
    t = var(i);
    switch sequence(i)
        case ''
            break
        case 'x'
            R = R * [1 0 0; 0 cos(t) -sin(t); 0 sin(t) cos(t)];
        case 'y'
            R = R * [cos(t) 0 sin(t); 0 1 0; -sin(t) 0 cos(t)];
        case 'z'
            R = R * [cos(t) -sin(t) 0; sin(t) cos(t) 0; 0 0 1];
        otherwise
            errordlg('Please enter the sequence only composed of ''x'', ''y'', and ''z''.', 'Sequence Error');
            return
    end
end
R = simplify(R);
end

