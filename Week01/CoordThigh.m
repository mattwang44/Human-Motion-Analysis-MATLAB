function [Rg2t, Vg2t, Tcoord_local] = CoordThigh(Tcoord, side, MKstr)
    % the function converts the coordinate of points from global CS to
    % local CS on THIGH

    % Rg2l: the rotation matrix converting global to local [3 x 3 x nframes]
    % Vg2l: the position vector pointing from global to local [nframes x 3]
    % Tcoord: the coordinate of every marker in the global coordinate system [nframes x 3 x 3(markers)]
    % Tcoord_local: the coordinate of every marker in the local coordinate system [N markers x 3 x nframes]
    
   % Specify the sequence of input data & Validate the format of MKstr 
   % & Validate side
   if side~='R' && side~='r' && side~='L' && side~='l'
       errordlg('Wrong input of side ! ''R'' or ''r'' for right side and ''L''or ''l'' for left side.','CoordThigh');
       return
   end
   
   index = [find(strcmp(MKstr, 'LTRO')), find(strcmp(MKstr, 'LLFC')), find(strcmp(MKstr, 'LMFC'))]; 
   if numel(index)~=3 || numel(unique(index))~=3 || ~isempty(find(index>3)) 
       index = [find(strcmp(MKstr, 'RTRO')), find(strcmp(MKstr, 'RLFC')), find(strcmp(MKstr, 'RMFC'))]; 
       if numel(index)~=3 || numel(unique(index))~=3 || ~isempty(find(index>3)) 
           errordlg('Wrong spelling or repeating of marker string input (MKstr) !','CoordThigh');
           return
       end
       if side~='R' && side~='r'
           errordlg('You pick wrong side! Choose another!','CoordThigh');
           return
       end
   elseif side~='L' && side~='l'
       errordlg('You pick wrong side! Choose another!','CoordThigh');
       return
   end
   
   % Validate the format of Pcoord
   sTc = size(Tcoord);
   if sTc(2)~=3 || sTc(3)~=3
       errordlg('Wrong format of global coordinate of markers input (Tcoord) !','CoordThigh');
       return    
   end
   
   % Assign the input variables
   Tcell = {Tcoord(:,:,index(1)), Tcoord(:,:,index(2)), Tcoord(:,:,index(3))};
   [TROp, LFCp, MFCp] = deal(Tcell{:});
   
   % Decide position vectors
   Vg2t = TROp;
   
   % Local coordinate systen
   switch side
       case {'R','r'}
           vec = LFCp - MFCp;
       case {'L','l'}
           vec = MFCp - LFCp;
   end
   Zp = bsxfun(@rdivide, vec, sqrt(sum(abs(vec).^2,2)));
   vec = bsxfun(@cross, TROp - LFCp, Zp);
   Xp = bsxfun(@rdivide, vec, sqrt(sum(abs(vec).^2,2)));
   Yp = bsxfun(@cross, Zp, Xp);    
     
   Rg2t = reshape((cat(2, Xp, Yp, Zp)).', 3, 3, []);
   
   Tcoord_local = permute(CoordG2L(Rg2t, Vg2t, Tcoord), [3 2 1]);

end

