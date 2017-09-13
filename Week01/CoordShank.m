function [Rg2s, Vg2s, Scoord_local] = CoordShank(Scoord, side, MKstr)
    % the function converts the coordinate of points from global CS to
    % local CS on SHANK

    % Rg2l: the rotation matrix converting global to local [3 x 3 x nframes]
    % Vg2l: the position vector pointing from global to local [nframes x 3]
    % Scoord: the coordinate of every marker in the global coordinate system [nframes x 3 x 3(markers)]
    % Scoord_local: the coordinate of every marker in the local coordinate system [N markers x 3 x nframes]
    
   % Specify the sequence of input data & Validate the format of MKstr 
   % & Validate side
   if side~='R' && side~='r' && side~='L' && side~='l'
       errordlg('Wrong input of side ! ''R'' or ''r'' for right side and ''L''or ''l'' for left side.','CoordShank');
       return
   end
   
   index = [find(strcmp(MKstr, 'LTT')), find(strcmp(MKstr, 'LSHA')), find(strcmp(MKstr, 'LLMA')), find(strcmp(MKstr, 'LMMA'))]; 
   if numel(index)~=4 || numel(unique(index))~=4 || ~isempty(find(index>4)) 
       index = [find(strcmp(MKstr, 'RTT')), find(strcmp(MKstr, 'RSHA')), find(strcmp(MKstr, 'RLMA')), find(strcmp(MKstr, 'RMMA'))];  
       if numel(index)~=4 || numel(unique(index))~=4 || ~isempty(find(index>4)) 
           errordlg('Wrong spelling or repeating of marker string input (MKstr) !','CoordShank');
           return
       end
       if side~='R' && side~='r'
           errordlg('You pick wrong side! Choose another!','CoordShank');
           return
       end
   elseif side~='L' && side~='l'
       errordlg('You pick wrong side! Choose another!','CoordShank');
       return
   end
   
   % Validate the format of Pcoord
   sSc = size(Scoord);
   if sSc(2)~=3 || sSc(3)~=4
       errordlg('Wrong format of global coordinate of markers input (Scoord) !','CoordShank');
       return    
   end
   
   % Assign the input variables
   Scell = {Scoord(:,:,index(1)), Scoord(:,:,index(2)), Scoord(:,:,index(3)), Scoord(:,:,index(4))};
   [TTp, SHAp, LMAp, MMAp] = deal(Scell{:});
   
   % Decide position vectors
   Vg2s = TTp;
   
   % Local coordinate systen
   vec = bsxfun(@cross, SHAp - MMAp, LMAp - MMAp);
   Xp = bsxfun(@rdivide, vec, sqrt(sum(abs(vec).^2,2)));
   if side == 'L' || side == 'l'
       Xp=-Xp; 
   end
   vec = bsxfun(@cross, Xp, TTp - (MMAp+LMAp)/2);
   Zp = bsxfun(@rdivide, vec, sqrt(sum(abs(vec).^2,2)));
   Yp = bsxfun(@cross, Zp, Xp);    
     
   Rg2s = reshape((cat(2, Xp, Yp, Zp)).', 3, 3, []);
   
   Scoord_local = permute(CoordG2L(Rg2s, Vg2s, Scoord), [3 2 1]);

end

