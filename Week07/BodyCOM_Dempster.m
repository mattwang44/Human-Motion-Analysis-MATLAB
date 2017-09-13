function [ bodyCOM, segCOM ] = BodyCOM_Dempster( CoordP, CoordD )
% Calculate the COM of each limb and whole body from anthropometric data

% CoordP: Proximal coordinates of N limbs [nframes x 3 x N(limbs)], N = 7, 11, 12, 13
% CoordD: Distal coordinates of N limbs [nframes x 3 x N(limbs)], N = 7, 11, 12, 13

% bodyCOM: coordinate of COM of whole body [n x 3]
% segCOM: coordinate of COM of each limb [nframes x 3 x N(limbs)], N = 7, 11, 12, 13

Nl = size(CoordP, 3);
ProxLL = CoordP(:,:,1:6); DistLL = CoordD(:,:,1:6);
if Nl ~= 7
    ProxUL=CoordP(:,:,7:10); DistUL=CoordD(:,:,7:10);
    ProxUB=CoordP(:,:,11:end); DistUB=CoordD(:,:,11:end);
else
    ProxUB=CoordP(:,:,7); DistUB=CoordD(:,:,7);
end

%% COM of limb
% Lower limb
w = reshape(repmat([.433 .433 .5],2,1),1,1,[]);
COMLL = w .* DistLL + (1-w) .* ProxLL;
% Upper limb
if Nl ~= 7
    w = reshape(repmat([.436 .682],2,1),1,1,[]);
    COMUL = w .* DistUL + (1-w) .* ProxUL;
else
    COMUL = [];
end
% Upper body
switch Nl
    case 7
        COMUB = .626 * DistUB + .374 * ProxUB;
    case 11
        COMUB = .66 * DistUB + .34 * ProxUB;
    case 12
        w = reshape([.5 1],1,1,[]);
        COMUB = w .* DistUB + (1-w) .* ProxUB;
    case 13
        w = reshape([.105 .63 1],1,1,[]);
        COMUB = w .* DistUB + (1-w) .* ProxUB;
end
segCOM = cat(3, COMLL, COMUL, COMUB);

%% COM of body
switch Nl
    case 7
        w = reshape([.1 .1 .0465 .0465 .0145 .0145 .678],1,1,[]);
    case 11
        w = reshape([.1 .1 .0465 .0465 .0145 .0145 ...
            .028 .028 .022 .022 .578],1,1,[]);
    case 12
        w = reshape([.1 .1 .0465 .0465 .0145 .0145 ...
            .028 .028 .022 .022 .497 .081],1,1,[]);
    case 13
        w = reshape([.1 .1 .0465 .0465 .0145 .0145 ...
            .028 .028 .022 .022 .142 .355 .081],1,1,[]);
end
bodyCOM = sum(segCOM .* w, 3);        

end

