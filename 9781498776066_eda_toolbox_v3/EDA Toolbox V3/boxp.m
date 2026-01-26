function boxp(X, vw)

%  BOXP  Boxplot and variations
%
%   BOXP(X, 'VW', 'HP')
%   This function implements the boxplot for data that has variable sample
%   sizes. The input X can be an n x p matrix, in which case, each column is
%   portrayed as a verticle boxplot. The variable X can also be a cell
%   array, where each cell contains one of the samples. 
%
%   The optional argument 'VW' can be used to adjust the widths
%   of the boxplots, such that they are proportional to the square root of
%   the sample size.
%
%   The optional argument 'HP' can be used to produce a histplot,
%   where the width of the 'box' at the quartiles is proportional to the
%   estimated density. Note that we use a kernel density estimate, where 
%   the window width is based on the Normal Reference Rule (Scott, 1992).
%
%   EXAMPLES
%           boxp(x)      % Plots the plain boxplot for each col/cell of x
%           boxp(x,'vw') % Plots the variable width boxplots
%           boxp(x,'hp') % Plots the histplot

% Figure out what inputs were given.
if nargin == 1
    % Then just the plain boxplots.
    plain = 1;
    varw = 0;
    histp = 0;
    w = 2;
elseif strcmp(vw,'vw')
    plain = 0;
    varw = 1;
    histp = 0;
elseif strcmp(vw,'hp')
    plain = 0;
    varw = 0;
    histp = 1;
else
    error('Second argument can only be ''vw'' or ''hp''')
end
% Find the type of input argument x
if iscell(X)
    p = length(X);
    for i = 1:p
        % Get all of the sample sizes.
        n(i) = length(X{i});
    end
    % Get the min and the max of the root n.
    maxn = max(sqrt(n));
    minn = min(sqrt(n));
else
    [n,p] = size(X);
end
% Find some of the things needed to plot them.
% Each boxplot will have a maximum width of 2 units.
N = 4 + p-1 + 3*p;
ctr = 4:4:4*p;
Le = ctr - 1;
Re = ctr + 1;
figure, hold on
for i = 1:p
    % Extract the data.
    if iscell(X)
        x = X{i};
    else
        x = X(:,i);
    end
    % Get the quartiles.
    q = quartiles(x);
    % Get the outliers and adjacent values.
    [adv,outs] = getout(q,x);
    % Get the maximum width of the boxplot.
    if varw
        if length(n) == 1
            error('All sample sizes are equal. Do not do variable width boxplot.')
        end
        % Then it is a variable width boxplot.
        ns = sqrt(n(i));
        % Scale between 0.5 and 2.
        w = scale(ns, minn, maxn, 0.5, 2);
    end
    % Draw the boxes.
    if plain
        % If we have plain boxplots.
        % Draw the quartiles.
        plot([Le(i) Re(i)],[q(1),q(1)])
        plot([Le(i) Re(i)],[q(2),q(2)])
        plot([Le(i) Re(i)],[q(3),q(3)])
        % Draw the sides of the box
        plot([Le(i) Le(i)],[q(1),q(3)])
        plot([Re(i) Re(i)],[q(1),q(3)])
        % Draw the whiskers.
        plot([ctr(i) ctr(i)],[q(1),adv(1)], [ctr(i)-.25 ctr(i)+.25], [adv(1) adv(1)]) 
        plot([ctr(i) ctr(i)],[q(3),adv(2)], [ctr(i)-.25 ctr(i)+.25], [adv(2) adv(2)])
    elseif varw
        % If we have variable width boxplots.
        % Draw the quartiles.
        plot([ctr(i)-w ctr(i)+w],[q(1),q(1)])
        plot([ctr(i)-w ctr(i)+w],[q(2),q(2)])
        plot([ctr(i)-w ctr(i)+w],[q(3),q(3)])
        % Draw the sides of the box
        plot([ctr(i)-w ctr(i)-w],[q(1),q(3)])
        plot([ctr(i)+w ctr(i)+w],[q(1),q(3)])
        % Draw the whiskers.
        ww = scale(ns, minn, maxn, 0.1, 0.25);
        plot([ctr(i) ctr(i)],[q(1),adv(1)], [ctr(i)-ww ctr(i)+ww], [adv(1) adv(1)]) 
        plot([ctr(i) ctr(i)],[q(3),adv(2)], [ctr(i)-ww ctr(i)+ww], [adv(2) adv(2)])
    else
        % We must have the histplot. Plot widths at quartiles proportional
        % to the density estimate there.
        % Draw the quartiles - first get estimates of the density at each.
        for j = 1:3
            fhat(j) = cskern1d(x,q(j));
        end
        w1 = scale(fhat(1),min(fhat),max(fhat),0.5,2);
        w1 = w1/2;
        plot([ctr(i)-w1 ctr(i)+w1],[q(1),q(1)])
        w2 = scale(fhat(2),min(fhat),max(fhat),0.5,2);
        w2 = w2/2;
        plot([ctr(i)-w2 ctr(i)+w2],[q(2),q(2)])
        w3 = scale(fhat(3),min(fhat),max(fhat),0.5,2);
        w3 = w3/2;
        plot([ctr(i)-w3 ctr(i)+w3],[q(3),q(3)])
        % Plot the sides.
        plot([ctr(i)-w1 ctr(i)-w2],[q(1),q(2)])
        plot([ctr(i)+w1 ctr(i)+w2],[q(1),q(2)])
        plot([ctr(i)-w2 ctr(i)-w3],[q(2),q(3)])
        plot([ctr(i)+w2 ctr(i)+w3],[q(2),q(3)])
        % Draw the whiskers.
        plot([ctr(i) ctr(i)],[q(1),adv(1)], [ctr(i)-.25 ctr(i)+.25], [adv(1) adv(1)]) 
        plot([ctr(i) ctr(i)],[q(3),adv(2)], [ctr(i)-.25 ctr(i)+.25], [adv(2) adv(2)])
    end
    % Draw the outliers.
    plot(ctr(i)*ones(size(outs)), outs,'o')
    
    
end
ax = axis;
axis([Le(1)-2 Re(end)+2 ax(3:4)])
set(gca,'XTickLabel',' ')
hold off


function [adv,outs] = getout(q,x)
% This helper function returns the adjacent values and
% outliers.
x = sort(x);
n = length(x);
% Get the upper and lower limits.
iq = q(3) - q(1);
UL = q(3) + iq*1.5;
LL = q(2) - iq*1.5;
% Find any outliers.
ind = [find(x > UL); find(x < LL)];
outs = x(ind);
% Get the adjacent values. Find the
% points that are NOT outliers.
inds = setdiff(1:n,ind);
% Get their min and max.
adv = [x(inds(1)) x(inds(end))];

function nx = scale(x, a, b, c, d)
% This function converts a value x that is orignally between a and b to
% one that is between c and d.
nx = (d - c)*(x - a)/(b - a) + c;

function fhat = cskern1d(data,x)
n = length(data);
fhat = zeros(size(x));
h = 1.06*n^(-1/5);
for i=1:n
   f=exp(-(1/(2*h^2))*(x-data(i)).^2)/sqrt(2*pi)/h;
   fhat = fhat+f/(n);
end





