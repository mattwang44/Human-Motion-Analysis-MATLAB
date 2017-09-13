function [Rg2p, Vg2p, Pcoord_local] = CoordPelvis(Pcoord, side, MKstr)
    % the function converts the coordinate of points from global CS to
    % local CS on PELVIS

    % Rg2l: the rotation matrix converting global to local [3 x 3 x nframes]
    % Vg2l: the position vector pointing from global to local [nframes x 3]
    % Pcoord: the coordinate of every marker in the global coordinate system [nframes x 3 x 3(markers)]
    % Pcoord_local: the coordinate of every marker in the local coordinate system [N markers x 3 x nframes]
    if side~='R' && side~='r' && side~='L' && side~='l'
       errordlg('Wrong input of side ! ''R'' or ''r'' for right side and ''L''or ''l'' for left side.','CoordPelvis');
       return
   end

   % Specify the sequence of input data
   index = [find(strcmp(MKstr, 'RASI')), find(strcmp(MKstr, 'LASI')), find(strcmp(MKstr, 'RPSI'))]; 

   if numel(index)~=3 || numel(unique(index))~=3 || ~isempty(find(index>4)) 
       index = [find(strcmp(MKstr, 'RASI')), find(strcmp(MKstr, 'LASI')), find(strcmp(MKstr, 'LPSI'))];  
       if numel(index)~=3 || numel(unique(index))~=3 || ~isempty(find(index>4)) 
           errordlg('Wrong spelling or repeating of marker string input (MKstr) !','CoordPelvis');
           return
       end
       if side~='L' && side~='l'
           errordlg('You pick wrong side! Choose another!','CoordPelvis');
           return
       end
   elseif side~='R' && side~='r'
       errordlg('You pick wrong side! Choose another!','CoordPelvis');
       return
   end
   
   % Validate the format of Pcoord
   sPc = size(Pcoord);
   if sPc(2)~=3 || sPc(3)~=3
       errordlg('Wrong format of global coordinate of markers input (Pcoord) !','CoordPelvis');
       return    
   end
   
   % Assign the input variables
   Pcell = {Pcoord(:,:,index(1)), Pcoord(:,:,index(2)), Pcoord(:,:,index(3))};
   [RASIp, LASIp, XPSIp] = deal(Pcell{:});
   vec = RASIp - LASIp;
   Zp = bsxfun(@rdivide, vec, sqrt(sum(abs(vec).^2,2)));
   
   % Decide side
   switch side
       case {'R','r'}
           Vg2p = RASIp;
           vec = bsxfun(@cross, Zp, RASIp - XPSIp);
           Yp = bsxfun(@rdivide, vec, sqrt(sum(abs(vec).^2,2)));
       case {'L','l'}
           Vg2p = LASIp;
           vec = bsxfun(@cross, Zp, LASIp - XPSIp);
           Yp = bsxfun(@rdivide, vec, sqrt(sum(abs(vec).^2,2)));
   end
    
   Xp = bsxfun(@cross, Yp, Zp);
     
   Rg2p = reshape((cat(2, Xp, Yp, Zp)).', 3, 3, []);
   
   Pcoord_local = permute(CoordG2L(Rg2p, Vg2p, Pcoord), [3 2 1]);

end

