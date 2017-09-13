function [varargout] = CoordL2G( Rg2l, Vg2l, varargin )
    % the function converts the coordinate of points from global CS to local CS
    
    % Rg2l: the rotation matrix converting global to local 
    % [3 x 3 x nframes] or [3 x 3]
    
    % Vg2l: the position vector pointing from global to local [nframes x 3]
    
    % varargin: the coordinate of every marker in the global coordinate system 
    %[nframes x 3] / [nframes x 3 x N markers]
    
    % varargout: the coordinate of every marker in the local coordinate system [nframes x 3]
    %[nframes x 3] / [nframes x 3 x N markers]
    
    %% Checking no. of input (minimum = 3)
    narginchk(3, nargin)
    
    %% Checking formats of rotation matrice and position vectors
    ir = size(Rg2l); iv = size(Vg2l); % size of rotation matrice and position vectors
    irl = ndims(Rg2l); ivl = ndims(Vg2l);
    
    if ~isequal(iv(2),  3) || ivl~=2
       errordlg('Wrong format of position vectors ( [nframes x 3] ) !!');
       return    
    end    
    
    nframe = iv(1); % no. of frames
    
    if ~isequal(ir(1), ir(2), 3)
       errordlg('Wrong format of rotation matrice ( [3 x 3 x nframes] or [3 x 3] ) !!');
       return    
    end

    switch irl
        case 2
            nRg2l = repmat(Rg2l,1,1,nframe); % rotation matrice of n frames
        case 3
            nRg2l = Rg2l;
            if ir(3)~=nframe
                errordlg('Rotation matrice and position vectors have different no. of frames !!');
                return 
            end                
        otherwise
            errordlg('Wrong format of rotation matrice ( [3 x 3 x nframes] or [3 x 3] ) !!');
            return 
    end
            
    
    %% Calculations for different syntax
    if length(varargin) == 1 % P_local has format of [nframes x 3 x N markers]
        P_local = varargin{:};
        sPl = size(P_local);
        if sPl(1) ~= nframe
            errordlg('Markers and position vectors have different no. of frames !!');
            return
        end
        if ndims(P_local)==3
            Nm = sPl(3);% no. of markers
        else
            Nm = 1; % only one marker
        end
        nargoutchk(1, 1)
%         varargout{1} = permute(pagefun(@mtimes, gpuArray(repmat(Rg2l, 1, 1, 1, Nm)), gpuArray(permute(P_local, [2 4 1 3]))), [3 1 4 2]) + repmat(Vg2l, 1, 1, Nm);
        varargout{1} = permute(mtimesx(repmat(Rg2l, 1, 1, 1, Nm),permute(P_local, [2 4 1 3])), [3 1 4 2]) + repmat(Vg2l, 1, 1, Nm);

    elseif length(varargin) > 1 % P_global of each marker are input separately.
        nVarargs = length(varargin);
        nargoutchk(nVarargs, nVarargs)
        for k = 1:nVarargs
            varargout{k} = permute(mtimesx(Rg2l, permute(varargin{k}, [2 3 1])), [3 1 2]) + Vg2l;
        end
    end
            
end

