function [ rCOM2P, rCOM2D, segCOMAcc ] = LLCOM2PD( segCOM, LLJC, nCOP, smprate )
% Calculate the vectors pointing from COM to distal and proxinal points (ceter of joint)
% of each limb and the acceleration of the COM.

% segCOM: Coordinate of COM of each limb [nframes x 3 x 6(limbs)]
% LLJC: Joint centers of lower limbs (left to right, hip to knee to ankle) 
%       [nframes x 3 x 2(sides) x 3(joints)]
% nCOP: The COP positon derived from each force plate relative to the
%       global coordinate. (Left foor first, and then right foot)
%       [nframes x 3 x 2 (feet)]
% smprate: sampling rate. [1 x 1]

% rCOM2P: The vectors pointing from COMs to proxinal points. (unit: m)
%         [nframes x 3 x 2(sides) x 3(segment)]
% rCOM2D: The vectors pointing from COMs to distal points. (unit: m)
%         [nframes x 3 x 2(sides) x 3(segment)]
% segCOMAcc: The acceleration of COM on each limb. (unit: m/sec^2)
%            [nframes x 3 x 2(sides) x 3(segment)]

%% Testng whether the variables have same no. of frames.
% disp(size(segCOM))
% disp(size(LLJC))
% disp(size(nCOP))
if ~isequal(size(segCOM,1),size(LLJC,1),size(nCOP,1))
    error("The variables have different no. of frames!")
else
    nframes = size(nCOP,1);
end
MsegCOM = permute(cat(4, segCOM(:,:,[1,3,5]), segCOM(:,:,[2,4,6])),[1 2 4 3]);
rCOM2P = LLJC - MsegCOM;

%% Distinguish the force plate correspong to left and right foot (voting by algo.)
vote = 0;
weight = [0.3 1];
% method 1: frame index of whose value is NaN (fist and last)
COP1 = nCOP(:,1,1); COP2 = nCOP(:,1,2);
iCOP1 = find(isnan(COP1)); iCOP2 = find(isnan(COP2)); 
FirstOcc = [min(iCOP1);min(iCOP2)];
LastOcc =  [max(iCOP1);max(iCOP2)];
if ~isnan(FirstOcc)
    if (FirstOcc(2)<FirstOcc(1) && LastOcc(2)<LatstOcc(1))
        vote = vote + weight(1);
    elseif (FirstOcc(1)<FirstOcc(2) && LastOcc(1)<LastOcc(2))
        vote = vote - weight(1);
    end
end
% method 2: frame index of whose value is NaN (avg)
if mean(iCOP2) < mean(iCOP1)
   vote = vote + weight(1);
elseif mean(iCOP2) ~= mean(iCOP1)
   vote = vote - weight(1);
end

% method 3: frame index of whose value is NaN (median)
if mean(iCOP2) < median(iCOP1)
   vote = vote + weight(1);
elseif mean(iCOP2) ~= median(iCOP1)
   vote = vote - weight(1);
end

% method 4: nframes/2, distance from ankle to nCOP
midframe = floor(nframes/2);
COP1 = nCOP(:,:,1); COP2 = nCOP(:,:,2);
avgCOP1 = mean(COP1(~isnan(COP1)));
avgCOP2 = mean(COP2(~isnan(COP2)));
avgLAnk = squeeze(mean(LLJC(1:midframe,:,1,3)));
avgRAnk = squeeze(mean(LLJC(midframe+1:end,:,2,3)));
if norm(avgLAnk-avgCOP1)+norm(avgRAnk-avgCOP2) > norm(avgLAnk-avgCOP2)+norm(avgRAnk-avgCOP1)
    vote = vote + weight(2);
else
    vote = vote - weight(2);
end

% Result
if vote >= 0 
    segD = cat(4, LLJC(:,:,:,2:3), cat(3,COP2,COP1));
else
    segD = cat(4, LLJC(:,:,:,2:3), cat(3,COP1,COP2));
end

rCOM2D = segD - MsegCOM;
 
%% Acceleration
% time sequence
TimeSeq = reshape(1/smprate:1/smprate:size(LLJC,1)/smprate,[],1);%nx1
segCOMAcc = zeros(nframes, 3, 2, 3);
for i = 1:3 % 4th dimen.: seg.
    for j = 1:2 % 3rd dimen.: side
        for k = 1:3 % 2nd dimen.: xyz
            segCOMAcc(:,k,j,i) = Derivative(TimeSeq, MsegCOM(:,k,j,i), 2);
        end
    end
end

end

 