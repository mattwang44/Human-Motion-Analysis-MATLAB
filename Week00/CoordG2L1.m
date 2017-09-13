function Pl = CoordG2L( Rg2l, Vg2l, Pg )
    % the function converts the coordinate of points from global CS to local CS
    
    % Rg2l: the rotation matrix converting global to local [3x3]
    % Vg2l: the position vector pointing from global to local [1x3]
    % Pg: the coordinate of every marker in the global coordinate system [nframes x 3]
    % Pl: the coordinate of every marker in the local coordinate system [nframes x 3]
    n = length(Pg); % no. of frames
    Pl = (Pg - ones(n, 1) * Vg2l) * Rg2l;
end

