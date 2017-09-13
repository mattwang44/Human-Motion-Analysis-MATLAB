function [Rg2f, Vg2f, Fcoord_local] = CoordFoot(Fcoord, side, MKstr)
    % the function converts the coordinate of points from global CS to
    % local CS on FOOT

    % Rg2l: the rotation matrix converting global to local [3 x 3 x nframes]
    % Vg2l: the position vector pointing from global to local [nframes x 3]
    % Fcoord: the coordinate of every marker in the global coordinate system [nframes x 3 x 3(markers)]
    % Fcoord_local: the coordinate of every marker in the local coordinate system [N markers x 3 x nframes]
    
   % Specify the sequence of input data & Validate the format of MKstr 
   % & Validate side
   if side~='R' && side~='r' && side~='L' && side~='l'
       errordlg('Wrong input of side ! ''R'' or ''r'' for right side and ''L''or ''l'' for left side.','CoordFoot');
       return
   end
   
   index = [find(strcmp(MKstr, 'LHEE')), find(strcmp(MKstr, 'LFOO')), find(strcmp(MKstr, 'LTOE'))]; 
   if numel(index)~=3 || numel(unique(index))~=3 || ~isempty(find(index>3)) 
       index = [find(strcmp(MKstr, 'RHEE')), find(strcmp(MKstr, 'RFOO')), find(strcmp(MKstr, 'RTOE'))]; 
       if numel(index)~=3 || numel(unique(index))~=3 || ~isempty(find(index>3)) 
           errordlg('Wrong spelling or repeating of marker string input (MKstr) !','CoordFoot');
           return
       end
       if side~='R' && side~='r'
           errordlg('You pick wrong side! Choose another!','CoordFoot');
           return
       end
   elseif side~='L' && side~='l'
       errordlg('You pick wrong side! Choose another!','CoordFoot');
       return
   end
   
   % Validate the format of Pcoord
   sFc = size(Fcoord);
   if sFc(2)~=3 || sFc(3)~=3
       errordlg('Wrong format of global coordinate of markers input (Fcoord) !','CoordFoot');
       return    
   end
   
   % Assign the input variables
   Fcell = {Fcoord(:,:,index(1)), Fcoord(:,:,index(2)), Fcoord(:,:,index(3))};
   [HEEp, FOOp,TOEp] = deal(Fcell{:});
   
   % Decide position vectors
   Vg2f = HEEp;
   
   % Local coordinate systen
   vec = (FOOp + TOEp)/2 - HEEp;
   Xp = bsxfun(@rdivide, vec, sqrt(sum(abs(vec).^2,2)));   
   switch side
       case {'R','r'}
           vec = FOOp - TOEp;
       case {'L','l'}
           vec = TOEp - FOOp;
   end
   vec = bsxfun(@cross, Xp, vec);    
   Yp = bsxfun(@rdivide, vec, sqrt(sum(abs(vec).^2,2)));  
   Zp = bsxfun(@cross, Xp, Yp);  
   
   Rg2f = reshape((cat(2, Xp, Yp, Zp)).', 3, 3, []);
   
   Fcoord_local = permute(CoordG2L(Rg2f, Vg2f, Fcoord), [3 2 1]);

end


