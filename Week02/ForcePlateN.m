function [ gCOP, nCOP, fpFg, Rg2fp, Vg2fp ] = ForcePlateN( fpF_local, fpM_local, corners, Vfp2tc, Pz )
    %% Input Arguments
    % fpF_local: The force measured by the force plate relative to the 
    %            local coordinate system on the force plate. 
    %            [nframes x 3 x nfp]
    
    % fpM_local: The moment measured by the force plate relative to the 
    %            local coordinate system on the force plate. 
    %            [nframes x 3 x nfp]
    
    % corners: The global coordinates of 4 corners on the force plate with
    %          the sequence of 1st to 4th quadrant relative to the
    %          local coordinate system of the force plate. [4 x 3 x nfp]
    
    % Vfp2tc: The coordinate of top plate center relative to local C.S. on 
    %         the force plate. [nfp x 3]    
    
    % Pz: Z-coordinate of the plane containing COP relative to local C.S.
    %     [1 x nfp]
    
    %% Output Arguments
    % gCOP: Global coordinate of COP (combination)
    %       [nframes x 3]
    
    % nCOP: Global coordinate of COP of each force plates
    %       [nframes x 3 x nfp]

    % fpFg: [nframes x 3 x nfp]
    
    % Rg2fp: The rotation matrix of force plate C.S. relative to the global
    %        C.S. [3 x 3 x nfp]
    
    % Vg2fp: The postion vector of the origin of force plate C.S. relative
    %        to global C.S. [nfp x 3]
    
    %% 
    nframes = size(fpF_local, 1);
    if nframes ~= size(fpM_local, 1)
       errordlg('fpF_local and fpM_local have differnet no. of frames!!');
       return    
    end
    if ~isequal(size(fpF_local,3), size(fpM_local,3), size(corners,3), size(Vfp2tc,1), size(Pz, 2))
       errordlg('Different no. of force plates input!!');
       return   
    end

    Vg2tc = sum(corners, 1)/4; %[1 x 3 x nfp]
    
    vec = (corners(1,:,:) + corners(4,:,:) - corners(2,:,:) - corners(3,:,:))/2;
    Xp = permute(bsxfun(@rdivide, vec, sqrt(sum(abs(vec).^2,2))), [2 1 3]);
    vec = (corners(1,:,:) + corners(2,:,:) - corners(4,:,:) - corners(3,:,:))/2;
    Yp = permute(bsxfun(@rdivide, vec, sqrt(sum(abs(vec).^2,2))), [2 1 3]);
    Zp = bsxfun(@cross, Xp, Yp);
    Rg2fp = cat(2, Xp, Yp, Zp);%[3 x 3 x nfp]
    
    Vg2fp = Vg2tc - mtimesx( permute(Vfp2tc,[3 2 1]), permute(Rg2fp, [2 1 3]));%[1 x 3 x nfp]
    
    Px = bsxfun(@rdivide, (bsxfun(@times, permute(Pz, [1 3 2]), fpF_local(:, 1, :)) - fpM_local(:, 2, :)), fpF_local(:, 3, :));%nfr x 1 x nfp
    Py = bsxfun(@rdivide, (bsxfun(@times, permute(Pz, [1 3 2]), fpF_local(:, 2, :)) + fpM_local(:, 1, :)), fpF_local(:, 3, :));
    
    Tz = fpM_local(:, 3, :) - Px.* fpF_local(:, 2, :) + Py .* fpF_local(:, 1, :) ;% [nframes x 1 x nfp]
    
    fpFg = mtimesx(fpF_local, permute(Rg2fp, [2 1 3])); % [nframes x 3 x nfp]
    Fg = sum(fpFg, 3);% [nframes x 3]    
    
    COP_local = cat(2, Px, Py, repmat(permute(Pz, [1 3 2]), nframes, 1, 1));% [nframes x 3 x nfp]
    
    nCOP = repmat(Vg2fp, nframes, 1, 1) + mtimesx(COP_local, permute(Rg2fp, [2 1 3])); % [nframes x 3 x nfp]
    
    %moment method 1
    Mg1 = sum(bsxfun(@cross, repmat(Vg2fp, nframes, 1, 1), fpFg) + mtimesx(fpM_local, permute(Rg2fp, [2 1 3])), 3);
    
    
    %moment method 2
    Tz(isnan(Tz))=0;
    nCOPp=nCOP;
    nCOPp(isnan(nCOPp))=0;
    Mg2 = sum(bsxfun(@cross, nCOPp, fpFg) + mtimesx(Tz, permute(Rg2fp(:,3,:), [2 1 3])), 3);
    
    % Choosing gCOP by different calculation method
%     gCOP = [-Mg1(:, 2) ./ Fg(:, 3), Mg1(:, 1) ./ Fg(:, 3)];
    gCOP = [-Mg2(:, 2) ./ Fg(:, 3), Mg2(:, 1) ./ Fg(:, 3)];

    Vg2fp = permute(Vg2fp, [3 2 1]);
    end

