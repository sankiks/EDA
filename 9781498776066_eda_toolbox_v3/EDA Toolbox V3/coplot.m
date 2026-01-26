function coplot(data,labels,intervalParams,fitParams)
%   COPLOT  Construct a coplot - conditional dependence plot.
%  make a conditioning plot for three variables
%  coplot(data,labels,intervalParams,fitParams)
%  data is a 3 column matrix with conditioning variable in first column
%  labels = {given title; dependence xlabel; dependence ylabel}
%  intervalParams = [number overlap] for conditioning variable
%  fitParams = [alpha lambda robustFlag] for loess fit

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $
% Revision: 6-2004
% Revised to update to Matlab 6 and higher. Function FMIN is obsolete, so
% replaced by FMINBND. Also put the calling functions as subfunctions to
% this one. 

if size(data,2)~=3
   error('data must be a 3 column matrix')
end

%  separate the variables
given = data(:,1);
dependx = data(:,2);
dependy = data(:,3);

%  determine breakpoints for equal count intervals
np = intervalParams(1);  %  number of given intervals
overlap = intervalParams(2);
breakPoint = equalcount(given,np,overlap);  %  endpoints for the intervals

%  determine dependence subplot layout params
plotRows = floor(sqrt(np));
plotCols = ceil(np/plotRows);

%  make given plot
clf
subplot(plotRows+1,1,1)
givenplot(breakPoint)  %  basic given plot
title(labels(1))
hold on
%  add broken lines  as layout hint
for ii = 1:plotRows-1
   plot([min(breakPoint(2,:)) max(breakPoint(1,:))],[ii*plotCols+0.5 ii*plotCols+0.5],'k--')
end
hold off
set(gca,'FontSize',8)
   pos = get(gca,'Position');
   pos(4) = 0.93*pos(4);
   pos(2) = 1.04*pos(2);
   set(gca,'Position',pos)

%  get loess curve fit parameters
if nargin>3
   doFit = 1;
   alpha = fitParams(1);
   lambda = fitParams(2);
   robustFlag = fitParams(3);
end

%  reorder the plot data
plotBreakPoint = breakPoint;
for ii = 1:plotRows-1
   plotBreakPoint = [plotBreakPoint(:,end-plotCols+1:end) plotBreakPoint];
   plotBreakPoint(:,end-plotCols+1:end) = [];
end

%  compute label locations for dependence plots
xLabelPos = round((np+plotCols+np+1)/2);
yLabelPos = floor((plotRows+1)/2)*plotCols+1;

aspectRatio = zeros(1,np);

for ii = 1:np
   subplot(plotRows+1,plotCols,ii+plotCols)
   %  select points for this plot
   index = given>=plotBreakPoint(2,ii) & given<=plotBreakPoint(1,ii);
   x = dependx(index);
   y = dependy(index);
   if doFit
      %  compute loess fit if desired
      fitx = linspace(min(x),max(x),10);
      fity = loess(x,y,fitx,alpha,lambda,robustFlag);
      %  plot both
      plot(x,y,'o',fitx,fity,'-')
      %  determine dependence plot aspect ratio
      aspectRatio(ii) = aspect45(fitx,fity);
   else
      %  otherwise just plot data
      plot(x,y,'o')
   end
   %  suppress most tick labels
   if ii<np-plotCols+1
      set(gca,'XTickLabel',[])
   end
   if rem(ii,plotCols)~=1
      set(gca,'YTickLabel',[])
   end
   %  make plots slightly bigger than default
   pos = get(gca,'Position');
   pos(3:4) = 1.14*pos(3:4);
   set(gca,'Position',pos)
   set(gca,'FontSize',8)
   if ii+plotCols==xLabelPos
      xlabel(labels(2))
   end
   if ii+plotCols==yLabelPos
      ylabel(labels(3))
   end
end

if any(aspectRatio~=0)
   averageAspectRatio = mean(aspectRatio);
end

function breakpoint = equalcount(x,intervals,overlap)
%  determine sets of values which slice x into equal count intervals
%  breakpoint = equalcount(x,intervals,overlap)
%  intervals  number of intervals
%  0<=desired_overlap<1
%  breakpoint = [upperValue; lowerValue]

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

k = intervals;  % number of intervals
f = overlap;    %  target overlap
r = length(x)/(k*(1-f)+f);   %  target points per interval

%  determine indices for end points
jj = (1:k)';
lowerIndex = round(1+(jj-1)*(1-f)*r);
upperIndex = round(r+(jj-1)*(1-f)*r);
lowerIndex(1) = 1;
upperIndex(end) = length(x);

x = sort(x);

%  determine end point values
lowerValue = x(lowerIndex);
upperValue = x(upperIndex);
breakpoint = [upperValue(:).'; lowerValue(:).'];

function givenplot(breakPoint)
%  make a given plot from break points
%  givenplot(breakPoint)
%  called by coplot.m

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

nbar = size(breakPoint,2);  %  number of interval bars
hw = 0.2;   %  bar halfwidth

%  draw the bars
hold on
for ii = 1:nbar
   temp1 = breakPoint(2,ii);
   temp2 = breakPoint(1,ii);
   xx = [temp1 temp1 temp2 temp2 temp1];
   yy = [ii-hw ii+hw ii+hw ii-hw ii-hw];
   plot(xx,yy,'-')
end
hold off

%  set axes
set(gca,'YTick',1:nbar)
set(gca,'YLim',[0 nbar+1])
box on

function aspectRatio = aspect45(x,y)
%  determine aspect ratio to bank data to 45 degrees
%  aspectRatio = aspect45(x,y)
%  x,y  data points

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

%  sort points in order of x
xy = [x(:) y(:)];
xy = sortrows(xy);
x = xy(:,1);
y = xy(:,2);

%  computes deltas
h = diff(x);
v = diff(y);

%  define min and max acceptable aspect ratios
amin = 0.2;
amax = 1/amin;

%  find acceptable aspect ratio for banking closest to 45 degrees
% aspectRatio = fmin('banker',amin,amax,[],h,v);
aspectRatio = fminbnd('banker',amin,amax,[],h,v);

function err = banker(a,h,v)
%  compute error from 45 degrees for aspect ratio a and data steps h,v
%  err = banker(a,h,v)
%  called by aspect45

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

%  weight based on step lengths
weight = sqrt(h.^2+a^2*v.^2);
%  deal with 0 in denominator
contrib = zeros(size(h));
index = h~=0;
contrib(index) = abs(a*v(index).*weight(index)./h(index));
contrib(~index) = max(contrib);
err = sum(contrib);
err = abs(err/sum(weight)-1);

function weight = bisquare(residual)
%  calculate robustness weights using bisquare technique
%  weight = bisquare(residual)
%  refer to Cleveland, Visualizing Data

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

%  use median absolute deviation of residuals as scale factor
s = median(abs(residual));
%  make 0<= scaled residuals <=1
u = min(abs(residual/(6*s)),1);
%  use bisquare function
weight = (1-u.^2).^2;

function [p,S] = least2(x,y,n,w)
%	[p,S] = least2(x,y,n,w) finds the coefficients of a polynomial
%	p(x) of degree n that fits the data, p(x(i)) ~= y(i),
%	in a weighted least-squares sense with weights w(i).
%  The structure S contains additional info.
%	This routine is based on polyfit. 
%
%	See also POLYFIT, POLY, POLYVAL, ROOTS.

% Copyright (c) 1998 by Datatool
%	$Revision: 1.1 $ 

% The regression problem is formulated in matrix format as:
%
%    A'*W*y = A'*W*A*p
%
% where the vector p contains the coefficients to be found.  For a
% 2nd order polynomial, matrix A would be:
%
% A = [x.^2 x.^1 ones(size(x))];

if nargin==4
    if any(size(x) ~= size(w))
        error('X and W vectors must be the same size.')
	end
    else
%		default weights are unity.
        w = ones(size(x));
    end
if any(size(x) ~= size(y))
    error('X and Y vectors must be the same size.')
end
x = x(:);
y = y(:);
w = w(:);

%  remove data for w=0 to reduce computations and storage
zindex=find(w==0);
x(zindex) = [];
y(zindex) = [];
w(zindex) = [];
nw = length(w);

% Construct the matrices. Use sparse form to avoid large weight matrix.
W = spdiags(w,0,nw,nw);

A = vander(x);
A(:,1:length(x)-n-1) = [];

V = A'*W*A;
Y = A'*W*y;

% Solve least squares problem. Use QR decomposition for computation.
[Q,R] = qr(V,0);
    
p = R\(Q'*Y);    % Same as p = V\Y;
r = Y - V*p;     % residuals
p = p';          % Polynomial coefficients are row vectors by convention.

% S is a structure containing three elements: the Cholesky factor of the
% Vandermonde matrix, the degrees of freedom and the norm of the residuals.

S.R = R;
S.df = length(y) - (n-1);
S.normr = norm(r);

function g = loess(x,y,newx,alpha,lambda,robustFlag)
%  curve fit using local regression
%  g = loess(x,y,newx,alpha,lambda,robustFlag)
%  apply loess curve fit -- nonparametric regression
%  x,y  data points
%  newx,g  fitted points
%  alpha  smoothing  typically 0.25 to 1.0
%  lambda  polynomial order 1 or 2
%  if robustFlag is present, use bisquare
%  for loess info, refer to Cleveland, Visualizing Data

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

robust = 0;
if nargin>5,robust=1;end

n = length(x);      %  number of data points
q = floor(alpha*n);
q = max(q,1);
q = min(q,n);       %  used for weight function width
tol = 0.003;        %  tolerance for robust approach
maxiterations = 100;

%  perform a fit for each desired x point
for ii = 1:length(newx)
   deltax = abs(newx(ii)-x);     %  distances from this new point to data
   deltaxsort = sort(deltax);     %  sorted small to large
   qthdeltax = deltaxsort(q);     % width of weight function
   arg = min(deltax/(qthdeltax*max(alpha,1)),1);
   tricube = (1-abs(arg).^3).^3;  %  weight function for x distance
   index = tricube>0;  %  select points with nonzero weights
   p = least2(x(index),y(index),lambda,tricube(index));  %  weighted fit parameters
   newg = polyval(p,newx(ii));  %  evaluate fit at this new point
   if robust
      %   for robust fitting, use bisquare
      test = 10*tol;
      niteration = 1;
      while test>tol
         oldg = newg;
         residual = y(index)-polyval(p,x(index));  %fit errors at points of interest
         weight = bisquare(residual);  %  robust weights based on residuals
         newWeight = tricube(index).*weight;  %  new overall weights
         p = least2(x(index),y(index),lambda,newWeight);  
         newg = polyval(p,newx(ii));  %  revised fit
         niteration = niteration+1;
         if niteration>maxiterations
            disp('Too many iterations')
            break
         end
         test = max(0.5*abs(newg-oldg)./(newg+oldg));
      end
   end
   g(ii) = newg;
end


