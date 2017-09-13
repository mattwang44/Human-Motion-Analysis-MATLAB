function [ gCOP, fpFg, Rg2fp, Vg2fp ] = ForcePlate( fpF_local, fpM_local, corners, Vfp2tc, Pz )
    %% Input Arguments
    % fpF_local: The force measured by the force plate relative to the 
    %            local coordinate system on the force plate. 
    %            [nframes x 3]
    
    % fpM_local: The moment measured by the force plate relative to the 
    %            local coordinate system on the force plate. 
    %            [nframes x 3]
    
    % corners: The global coordinates of 4 corners on the force plate with
    %          the sequence of 1st to 4th quadrant relative to the
    %          local coordinate system of the force plate. [4 x 3]
    
    % Vfp2tc: The coordinate of top plate center relative to local C.S. on 
    %         the force plate. [1 x 3]    
    
    % Pz: Z-coordinate of the plane containing COP relative to local C.S.
    %     [1 x 1]
    
    %% Output Arguments
    % gCOP:
    
    % fpFg: 
    
    % Rg2fp: The rotation matrix of force plate C.S. relative to the global
    %        C.S. [3 x 3]
    
    % Vg2fp: The postion vector of the origin of force plate C.S. relative
    %        to global C.S. [1 x 3]
    
    %% Function
    nframes = length(fpF_local);
    if nframes ~= length(fpM_local)
       errordlg('fpF_local and fpM_local have differnet no. of frames!!');
       return    
    end
    
    Vg2tc = sum(corners, 1)/4;
    
    vec = (corners(1,:) + corners(4,:) - corners(2,:) - corners(3,:))/2;
    Xp = (vec/norm(vec)).';
    vec = (corners(1,:) + corners(2,:) - corners(4,:) - corners(3,:))/2;
    Yp = (vec/norm(vec)).';
    Zp = bsxfun(@cross, Xp, Yp);
    
    Rg2fp = [ Xp, Yp, Zp ];
    Vg2fp = Vg2tc - Vfp2tc * Rg2fp.';
 
    Px = (Pz*fpF_local(:, 1) - fpM_local(:, 2)) ./  fpF_local(:, 3);
    Py = (Pz*fpF_local(:, 2) + fpM_local(:, 1)) ./  fpF_local(:, 3);

    COP_local = [Px Py repmat(Pz, nframes, 1)];
    gCOP = CoordL2G( Rg2fp, repmat(Vg2fp,nframes,1), COP_local);
    
    fpFg = fpF_local*Rg2fp.';
    

    
end

