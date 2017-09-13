function  COP_local = fpCOP( fpF_local, fpM_local, Pz )
    %% Input Arguments
    % fpF_local: The force measured by the force plate relative to the 
    %            local coordinate system on the force plate. 
    %            [nframes x 3]
    
    % fpM_local: The moment measured by the force plate relative to the 
    %            local coordinate system on the force plate. 
    %            [nframes x 3]
    
    % Pz: Z-coordinate of the plane containing COP relative to local C.S.
    %     [1 x 1]
    
    %% Output Arguments
    % COP_local: The coordinates of COP relative to the same C.S. as input 
    %            force and moment.
    %            [nframes x 3]
    
    %%
    nframes = length(fpF_local);
    if nframes ~= length(fpM_local)
       errordlg('fpF_local and fpM_local have differnet no. of frames!!');
       return    
    end   
    Px = (Pz*fpF_local(:, 1) - fpM_local(:, 2)) ./  fpF_local(:, 3);
    Py = (Pz*fpF_local(:, 2) + fpM_local(:, 1)) ./  fpF_local(:, 3);
    
    %
    hold on
    axis equal
    for i=1:nframes
        scatter(Px(i), Py(i));
        pause(0.05)
    end
    %
    
    COP_local = [Px Py repmat(Pz, nframes, 1)];
    
end

