function hexplot(X,N,flag)

% HEXPLOT   Hexagonal Binning - Scatterplot
% 
%   HEXPLOT(X,N,FLAG) creates a scatterplot, where the data have been binned
%   into hexagonal bins. The length of the side of the hexagon at the center of each
%   bin is proportional to the number of observations that fall into that
%   bin. 
%
%   The input argument X (n x 2) contains the bivariate data; N is the
%   (approximate) number of bins in the variable that has the larger range;
%   and the optional argument FLAG (can be any value) maps the color of the hexagon 
%   to the probability density at that bin.

[n,p] = size(X);
if p~=2
    error('Dimensionality must be 2')
end
% Find the range - the one with the longest range with have the 'longer'
% side of the hexagon. Use this to find the radius r.
rng = max(X) - min(X);
if rng(1) > rng(2)
    % Then the horizontal is longer.
    r = 2*rng(1)/(3*N);
   % Get the canonical hexagon.
    R = r*ones(1,6);
    theta = (0:60:300)*pi/180;
    % Convert to cartesian.
    [hexX,hexY] = pol2cart(theta,R);
    % Get the centers in x direction, used to generate mesh.
    % Putting some padding on either side to ensure that there are enoug
    % bins.
    xc1 = min(X(:,1))-r:3*r:max(X(:,1))+r;
    yc1 = min(X(:,2))-r:r*sqrt(3):max(X(:,2))+r;
    xc2 = min(X(:,1))-r+3*r/2:3*r:max(X(:,1))+r;
    yc2 = min(X(:,2))-r+r*sqrt(3)/2:r*sqrt(3):max(X(:,2))+r;
    [tx1,ty1] = meshgrid(xc1,yc1);
    [tx2,ty2] = meshgrid(xc2,yc2);
    CX = [tx1(:); tx2(:)];
    CY = [ty1(:); ty2(:)];
else
    % The vertical range is bigger and will have the longer 'side' of the
    % hexagon.
    r = 2*rng(2)/(3*N);
    % Get the canonical hexagon.
    R = r*ones(1,6);
    theta = (30:60:360)*pi/180;
    % Convert to cartesian.
    [hexX,hexY] = pol2cart(theta,R);
    % Get the centers in the y direction, used to generate mesh.
    xc1 = min(X(:,1))-r:sqrt(3)*r:max(X(:,1))+r;
    yc1 = min(X(:,2))-r:3*r:max(X(:,2))+r;
    xc2 = min(X(:,1))-r+r*sqrt(3)/2:r*sqrt(3):max(X(:,1))+r;
    yc2 = min(X(:,2))-r+3*r/2:3*r:max(X(:,2))+r;
    [tx1,ty1] = meshgrid(xc1,yc1);
    [tx2,ty2] = meshgrid(xc2,yc2);
    CX = [tx1(:); tx2(:)];
    CY = [ty1(:); ty2(:)];
end
% Now bin the data. 
freq = zeros(size(CX));
yn = zeros(size(1,50));
for i = 1:length(CX)
    in = inpolygon(X(:,1),X(:,2),hexX+CX(i),hexY+CY(i));
    freq(i) = length(find(in==1));
end

% Get the area of the canonical hexagon for density.
ar = polyarea(hexX,hexY);
% Get the correct n, just in case an observations wasn't binned. If on edge
% of polygon, then doesn't get counted.
n = sum(freq);

% Draw each non-zero bin with r proportional to the number of observations
% in the bin. 
% scale freqs between 0.1*r and r.
% Find all of the non-zero bin freqs.
ind = find(freq > 0);
a = min(freq(ind));
b = max(freq);
figure,hold on
if nargin == 2
    % Then do just the plain plotting. 
    for i = 1:length(ind)
        j = ind(i);
        Rs = scale(freq(j),a,b,0.1*r,r);
        Rt = Rs*ones(1,6);
        [hexTx,hexTy] = pol2cart(theta,Rt);
        patch(hexTx+CX(j),hexTy+CY(j),'k');
    end
else
    % Then do the color mapped to density.
    % Convert to pdf values.
    pdf = freq/(n*ar);
    for i = 1:length(ind)
        j = ind(i);
        Rs = scale(freq(j),a,b,0.1*r,r);
        Rt = Rs*ones(1,6);
        [hexTx,hexTy] = pol2cart(theta,Rt);
        patch(hexTx+CX(j),hexTy+CY(j),pdf(j));
    end
    colorbar
    sum(pdf*ar)
end
hold off
axis equal

function nx = scale(x, a, b, c, d)
% This function converts a value x that orignally between a and b to
% one that is between c and d.
nx = (d - c)*(x - a)/(b - a) + c;





