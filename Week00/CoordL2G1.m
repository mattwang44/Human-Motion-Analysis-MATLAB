function Pg = CoordL2G( Rg2l, Vg2l, Pl )
    % the function converts the coordinate of points from local CS to global CS
    
    % Rg2l: the rotation matrix converting global to local [3x3]
    % Vg2l: the position vector pointing from global to local [1x3]
    % Pg: the coordinate of every marker in the global coordinate system [nframes x 3]
    % Pl: the coordinate of every marker in the local coordinate system [nframes x 3]
    n = length(Pl); % no. of frames
    Pg = Pl*Rg2l.' + ones(n, 1)*Vg2l;
end

