function [x0,yhat,S] = splinesmth(x,y,alpha)

% CSSPLINESMTH   Smoothing Splines
%
%   [x0,yhat,S] = cssplinesmth(x,y,alpha) returns the value of the 
%   smoothing spline using the data pairs x and y. The smoothing parameter
%   is represented by alpha. 
%
%   The output variable contains the estimates yhat(x0), where
%   x0 corresponds to the unique values of x.
%
%   The output variable S is the smoother matrix for the smoothing spline.
%   This is useful in using cross-validation.
%
%   The smoothing parameter is given by alpha. Large values of alpha
%   produce smoother curves. Small values yield curves that are more
%   wiggly. 
%
%   EXAMPLE:
%   
%   load vineyard
%   [x,ind] = sort(row);
%   y = totlugcount(ind);
%   [x0,yhat,s] = cssplinesmth(x,y,5);
%   plot(x,y,'.',x0,yhat)
%

%   EDA Toolbox with MATLAB, 2nd Edition
%   April 2010

if alpha <= 0
    error('Alpha must be greater than 0.')
end

% Sort the x values.
[xs,ind] = sort(x);
ys = y(ind);
% Make sure they are column vectors.
x = xs(:); 
y = ys(:);
n = length(x);
% Create weight vector - starts out as ones.
w = ones(n,1);

% The next portion of code gets rid of tied observations.
% The y values for tied observations are replaced with 
% their average value.
h = diff(x);
ind0 = find(h==0);
if ~isempty(ind0)
    xt = x;
    yt = y;
    wt = w;
    i = 1;
    while ~isempty(ind0)
        indt = find(x(ind0(end)) == x);
        ym(i) = mean(y(indt));
        xm(i) = x(indt(1));
        wm(i) = length(indt);    
        i = i+1;
        xt(indt) = [];
        yt(indt) = [];
        wt(indt) = [];
        [c,ia,ib] = intersect(indt,ind0);
        ind0(ib) = [];
    end
    xu = [xt(:); xm(:)];
    yu = [yt(:); ym(:)];
    wu = [wt(:); wm(:)];
    [xus,inds] = sort(xu);
    yus = yu(inds);
    wus = wu(inds);
    x = xus;
    y = yus;
    w = wus;
end
n = length(x);
% Find h_i = x_i+1 - x_i
h = diff(x);
% Find 1/h_i;
hinv = 1./h;
W = diag(w);
% Use my own way of doing it with sparse
% matrix notation. Keep the Q matrix as
% n by n orginally, so the subscripts match
% the G&S book. Then, I will get rid of the
% first and last column.
qDs = -hinv(1:n-2) - hinv(2:n-1);
I = [1:n-2, 2:n-1, 3:n];
J = [2:n-1,2:n-1,2:n-1];
S = [hinv(1:n-2), qDs, hinv(2:n-1)];
% Create a sparse matrix.
Q = sparse(I,J,S,n,n);
% Delete the first and last columns.
Q(:,n) = []; Q(:,1) = [];
% Now find the R matrix. 
I = 2:n-2;  
J = I + 1;
tmp = sparse(I,J,h(I),n,n);
t = (h(1:n-2) + h(2:n-1))/3;
R = tmp'+tmp+sparse(2:n-1,2:n-1,t,n,n);
% Get rid of the rows/cols that are not needed.
R(n,:) = []; R(1,:) = [];
R(:,n) = []; R(:,1) = [];
% Get the smoothing spline.
S1 = Q'*y;
S2 = R + alpha*Q'*inv(W)*Q;
% Solve for gamma;
gam = S2\S1;
% Find f^hat.
yhat = y - alpha*inv(W)*Q*gam;
S = inv(W + alpha*Q*inv(R)*Q')*W;
% S = inv(eye(n) + alpha*Q*inv(R)*Q');
x0 =x; 
