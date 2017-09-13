function [ Ms, Is ] = LLInertia( BW, CoordP, CoordD )
% Calculate the mass and inertia of each limb 
% (shape of limb is assumed to be a line with mass)

% BW:Body weight of the subject.(unit: kg) [1 x 1]
% CoordP: Coordinates of the proximal point on each (lower) limb [1 x 3 x 6(limb)]
% CoordD: Coordinates of the diatal point on each (lower) limb [1 x 3 x 6(limb)]
% (sequence: left thigh. right thigh, left knee, right knee, left anke, right ankle) 

% Ms: Mass of each limb (unit: kg) [2(sides) x 3(limb)]
% Is: Inertia of each limb (unit: kg-m^2) [3 x 3 x 6(limb)]

M = BW * [.1 .1 .0465 .0465 .0145 .0145];
Ms = reshape(M, 2, 3);

C = [.323 .323 .302 .302 .475 .475];
I = M .* (C.^2) .* reshape(sum( (((CoordD-CoordP)).^2), 2 ), 1, []);
I = permute(I, [1 3 2]);

Is = zeros(3, 3, 6);
Is(1,1,1:4) = I(1,1,1:4);
Is(2,2,5:6) = I(1,1,5:6);
Is(3,3,:) = I;

end

