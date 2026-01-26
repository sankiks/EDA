function [xhato,yhato] = polarloess(x,y,alpha,deg)
% POLARLOESS   Polar loess smoothing
%
%  [XHAT, YHAT] = POLARLOESS(X,Y,ALPHA,DEG)
%
%   This function does the polar smoothing for variables X and Y.
%   ALPHA is the smoothing parameter, and DEG is the degree of 
%   the local fit (1 or 2). The output consists of variables XHAT
%   and YHAT that can be used to superimpose a curve over the
%   scatterplot.
%

%   W. L. and A. R. Martinez, 3-04
%   EDA Toolbox
%   Reference is Cleveland and McGill, Many Faces of a Scatterplot.
%   JASA, 1984.


% Step 1.
% Normalize using the median absolute deviation.
% We will use the Matlab 'inline' functionality.
md = inline('median(abs(x - median(x)))');
xstar = (x - median(x))/md(x);
ystar = (y - median(y))/md(y);
% Step 2.
s = ystar + xstar;
d = ystar - xstar;
% Step 3. Normalize these values.
sstar = s/md(s);
dstar = d/md(d);
% Step 4. Convert to polar coordinates.
[th,m] = cart2pol(sstar,dstar);
% Step 5. Transform radius m.
z = m.^(2/3);
% Step 6. Smooth z given theta.
n = length(x);
J = ceil(n/2);
% Get the temporary data for loess.
tx = -2*pi + th((n-J+1):n);
% So we can get the values back, find this.
ntx = length(tx);  
tx = [tx; th];
tx = [tx; th(1:J)];
ty = z((n-J+1):n);
ty = [ty; z];
ty = [ty; z(1:J)];
tyhat = loess(tx,ty,tx,0.5,1);
% Step 7. Transform the values back.
% Note that we only need the middle values.
tyhat(1:ntx) = [];
mhat = tyhat(1:n).^(3/2);
% Step 8. Convert back to Cartesian.
[shatstar,dhatstar] = pol2cart(th,mhat);
% Step 9. Transform to original scales.
shat = shatstar*md(s);
dhat = dhatstar*md(d);
xhat = ((shat-dhat)/2)*md(x) + median(x);
yhat = ((shat+dhat)/2)*md(y) + median(y);
% Step 10. Plot the smooth.
% We use the convex hull to make it easier
% for plotting.
K = convhull(xhat,yhat);

xhato = xhat(K);
yhato = yhat(K);

