function [ S ] = SwayArea( varargin )
% Principal Component Analyzing (PCA) of the static COP by encircling the COP with a eclipse

% Syntax:
% S = SwayArea;
% S = SwayArea(points);
% S = SwayArea(points,plotlog);
% S = SwayArea(points,plotlog,optimfit);

% points: COP coordinates [nframes x 2] (insert 'rand' to auto create random data set)
% plotlog:  logical value determines whether to plot the result [1 x 1] (Default = false)
% optimfit: logical value determines whether to derive the eclipse precisely encircling 95% of data points
%           [1 x 1] (Default = false)

% S: structure array include following fields:
%    EA: area of the eclipse [1 x 1]
%    majorR: length of major axis [1 x 1]
%    minorR: length of minor axis [1 x 1]
%    majorAng: the angle between major axis and the xy-plane (-pi/2 to pi/2)  [1 x 1]
%    minorAng: the angle between minor axis and the xy-plane (-pi/2 to pi/2)  [1 x 1]
%    majorV: vector of major axis [1 x 2]
%    minorV: vector of minor axis [1 x 2]
%    p: the percentage of data points encircled by the eclipse [1 x 1]

%% input variables and default values
switch nargin
    case 0
        points = 'rand';      
        plotlog = false;
        optimfit = true;
    case 1
        points = varargin{1};
        plotlog = false;
        optimfit = true;
    case 2
        points = varargin{1};
        plotlog = varargin{2};
        optimfit = true;
    case 3
        points = varargin{1};
        plotlog = varargin{2};
        optimfit = varargin{3};
end
% create random data set
if strcmp(points, 'rand')
    N = 2000; r = rand(1); a = [r zeros(1,5)];
    for i = 1:5
        a(i+1) = a(1) + rand(1)/3;
    end
    a = 50*ones(1,6).*a;
    points = cat(1,[randn(N, 1)*a(1)-a(1)/2,randn(N, 1)*a(2)-a(2)/2],[randn(N, 1)*a(3)-a(3)/2,...
        randn(N, 1)*a(4)-a(4)/2],[randn(N, 1)*a(5)-a(5)/2,randn(N, 1)*a(6)-a(6)/2]);
    rot = [r, sqrt(1-r^2);-sqrt(1-r^2), r];rot = rot *rot;
    points = ipermute(mtimesx(repmat(rot,1,1,size(points,1)),permute(points,[2 3 1])),[2 3 1]);
end
%% vectors and lengths of two principal axis
Npt = size(points,1);                            % length of data
AvgPt = mean(points);                            % center point (average)
PointsShift = points - AvgPt;
[V,D] = eig(PointsShift.' * PointsShift);        % eigenvectors are vectors of principal axis
D = sum(D,1);                                    % array of lengths of principal axis

% make the first column for the long axis and second for the short
if D(1) < D(2)
    V = fliplr(V);
    D = fliplr(D);
end
S.majorV = V(:,1).'; S.minorV = V(:,2).';
S.majorAng = atan(V(2,1)/V(1,1))*180/pi;
S.minorAng = atan(V(2,2)/V(1,2))*180/pi;

%% roughly estimated result (Standard Deviation*1.96)
AxL = sqrt(D/Npt)*1.96;
S.majorR = AxL(1);% a (rough result)
S.minorR = AxL(2);% b (rough result)
syms x y
% regular eclipse 
funcE = AxL(2)^2 * x^2 + AxL(1)^2 * y^2 - AxL(1)^2*AxL(2)^2;           
% oblique eclipse
if S.majorAng>0
    theta = -(S.majorAng+pi/2);
else
    theta = -S.majorAng;
end
funcOE = vpa(simplify(expand(subs(subs(E2EO(funcE, theta/180*pi),x,x-AvgPt(1)),y,y-AvgPt(2)))),5);   
% EXPAND FUNCTION of oblique eclipse with coef. of X^2 equals to 1
[c,k] = coeffs(funcOE, [x y]); 
funcOE = vpa(funcOE / c(k == x^2), 5);                                                              

%% Optimal Fit
% roughly estimated result as answer
if optimfit == false
    S.p = CalP(funcOE, points);
    S.EA = pi * AxL(1) * AxL(2);
% precise result as answer
elseif optimfit == true
    % function of eclipse encircling 95% of data points
    [funcOE, S.p] = findt(funcOE, points);
    % EXPAND FUNCTION of oblique eclipse with coef. of X^2 equals to 1
    [c,k] = coeffs(funcOE, [x y]);
    funcOE = vpa(funcOE / c(k == x^2), 5);
    % coefficient of constant term
    [c,k] = coeffs(funcOE, [x y]); 
    Ft = c(k == 1);
    
    % calculate the length ratio (ts) between rough and precise eclipse
    syms t
    % general function of regular eclipse 
    sfun = AxL(2)^2 * x^2 + AxL(1)^2 * y^2 - t^2*AxL(1)^2*AxL(2)^2;
    % general function of oblique eclipse
    sfunOE = vpa(simplify(expand(subs(subs(E2EO(sfun, theta/180*pi),x,x-AvgPt(1)),y,y-AvgPt(2)))),5);
    % EXPAND FUNCTION of oblique eclipse with coef. of X^2 equals to 1
    [c,k] = coeffs(sfunOE, [x y]); 
    sfunOE = vpa(sfunOE / c(k == x^2),5);
    % coefficient of constant term
    [c,k] = coeffs(sfunOE, [x y]);
    Fs = c(k == 1);
    % solve for the ratio
    ts = solve(Ft-Fs,t); ts = double(ts(ts>0));
    
    AxL = AxL*ts;
    S.majorR = double(AxL(1));
    S.minorR = double(AxL(2));
    S.EA = double(pi * AxL(1) * AxL(2));
else
    error('Insert only "true" or "false" to determine whether to achieve precise result (the eclipse encases exactly 95% points).')
end

%% plot
if plotlog == true
    figure('Name','Static COP', 'NumberTitle','off','position',[100 50 600 600]);
    hold on
    axis equal
    axis([min(points(:,1))-(max(points(:,1))-min(points(:,1)))/10,max(points(:,1))+(max(points(:,1))-min(points(:,1)))/10,...
        min(points(:,2))-(max(points(:,2))-min(points(:,2)))/10,max(points(:,2))+(max(points(:,2))-min(points(:,2)))/10])
    % plot the data point
    scatter(points(:,1),points(:,2), 10, 'c', 'filled', 'MarkerFaceAlpha',0.3);
    % plot the eclipse
    ezplot(matlabFunction(funcOE),[min(points(:,1))-min(points(:,1))/15,max(points(:,1))+max(points(:,1))/10,min(points(:,2))-min(points(:,2))/15,max(points(:,2))+max(points(:,2))/10])  
    % plot the principal axis
    pa1 = AvgPt + (AxL.*V).';    pa2 = AvgPt - (AxL.*V).';
    plot([pa1(1),pa2(1)],[pa1(3),pa2(3)],'r')
    plot([pa1(2),pa2(2)],[pa1(4),pa2(4)],'m')
    
    title('Area: '+string(S.EA)+', a='+string(S.majorR)'+ ', b='+string(S.minorR)'+...
        ', Ang=['+string(S.majorAng)+'¢X,'+string(S.minorAng)+'¢X], p='+string(S.p*100)+'%')
elseif plotlog ~= false
    error('Insert only "true" or "false" to determine whether to plot the result.')
end
end

%% function
% Get function of oblique ellipse from unrotated eclipse
function funcOE = E2EO(funcE, t)
syms x y
[c,k] = coeffs(funcE, [x y]);
% regular eclipse
% Ax^2 + Cy^2 + Dx + Ey + F = 0
A = c(k == x^2); A(isempty(A))=0;
F = c(k == 1);   F(isempty(F))=0; F = (F/A); D = c(k == x);   D(isempty(D))=0; D = double(D/A);
C = c(k == y^2); C(isempty(C))=0; C = double(C/A); E = c(k == y);   E(isempty(E))=0; E = double(E/A);
A = 1;
% oblique ellipse
% (A(cos(t))^2+C(sin(t))^2) X^2 + (C(cos(t))^2+A(sin(t))^2) Y^2 +
% ((C-A)sin(2t))XY + (Dcos(t)+Esin(t))X + (Ecos(t)-Dsin(t))Y +F = 0
funcOE = simplify((A*(cos(t))^2+C*(sin(t))^2)*x^2 + (C*(cos(t))^2+A*(sin(t))^2)*y^2 +...
    ((C-A)*sin(2*t))*x*y + (D*cos(t)+E*sin(t))*x + (E*cos(t)-D*sin(t))*y +F);
end

% calculate S.p
function p = CalP(funcOE, points)
syms x y
[c,k] = coeffs(funcOE, [x y]);
A = c(k == x^2); A(isempty(A))=0; 
B = c(k == x*y); B(isempty(B))=0; B = double(B/A); D = c(k == x);   D(isempty(D))=0; D = double(D/A);
C = c(k == y^2); C(isempty(C))=0; C = double(C/A); E = c(k == y);   E(isempty(E))=0; E = double(E/A);
F = c(k == 1);   F(isempty(F))=0; F = double(F/A); A = 1;
X = points(:,1); Y = points(:,2);
EqVal = A*X.^2 + B*X.*Y + C*Y.^2 + D*X + E*Y + F;
p = sum(EqVal<0)/size(points,1);
end

% get specific 95% result
function [funcOEn, p] = findt(funcOE, points)
syms x y
[c,k] = coeffs(funcOE, [x y]);
A = c(k == x^2); A(isempty(A))=0; oA = A;
B = c(k == x*y); B(isempty(B))=0; B = double(B/A); D = c(k == x);   D(isempty(D))=0; D = double(D/A);
C = c(k == y^2); C(isempty(C))=0; C = double(C/A); E = c(k == y);   E(isempty(E))=0; E = double(E/A);
F = c(k == 1);   F(isempty(F))=0; F = double(F/A); A = 1;
X = points(:,1); Y = points(:,2);                            
Ms = sort([A*X.^2 + B*X.*Y + C*Y.^2 + D*X + E*Y + F, points],1,'descend');
p95 = ceil(size(Ms,1)*0.05);
opt = mean(Ms(p95:p95+1,1));
funcOEn = simplify(funcOE/oA - opt);
[c,k] = coeffs(funcOEn, [x y]);
p = CalP(funcOEn/c(k == x^2), points);
end
