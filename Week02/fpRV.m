function [ Rg2fp, Vg2fp ] = fpRV( corners, Vfp2tc )
    %% Input Arguments
    % corners: The global coordinates of 4 corners on the force plate with
    %          the sequence of 1st to 4th quadrant relative to the
    %          local coordinate system of the force plate. [4 x 3]
    
    % Vfp2tc: The coordinate of top plate center relative to local C.S. on 
    %         the force plate. [1 x 3]
    
    %% Output Arguments
    % Rg2fp: The rotation matrix of force plate C.S. relative to the global
    %        C.S. [3 x 3]
    
    % Vg2fp: The postion vector of the origin of force plate C.S. relative
    %        to global C.S. [1 x 3]
    
    %% Function
    Vg2tc = sum(corners, 1)/4;
    
    vec = (corners(1,:) + corners(4,:) - corners(2,:) - corners(3,:))/2;
    Xp = (vec/norm(vec)).';
    vec = (corners(1,:) + corners(2,:) - corners(4,:) - corners(3,:))/2;
    Yp = (vec/norm(vec)).';
    Zp = bsxfun(@cross, Xp, Yp);
    
    Rg2fp = [ Xp, Yp, Zp ];
    Vg2fp = Vg2tc - Vfp2tc * Rg2fp.';

end

