function boxprct(X,vw)

%  BOXPRCT Box-Percentile Plot
%   
%  BOXPRCT(X,'VW')
%   This function constructs the box-percentile plot. The input argument
%   can be a cell array of samples (used when sample sizes are different)
%   or a matrix X, where each column contains a sample.
%
%   The sides of the box-percentile plot encodes the information of a
%   percentile plot, which is equivalent to the empirical cumulative
%   distribution function.
%
%   The optional input argument 'VW' will construct variable width plots,
%   where the maximum width is proportional to the square root of the
%   sample size.

% Reference: The box-percentile plot, by Esty and Banfield, Journal of
% Statistical Software, www.jstatsoft.org.

% Figure out what inputs were given.
if nargin == 1
    % Then just the plain boxplots.
    w = 2;
    varw = 0;
elseif strcmp(vw,'vw')
    varw = 1;
else
    error('Second argument can only be ''vw''')
end
if isnumeric(X) & varw==1
    error('Cannot do variable width boxplots when the sample sizes are the same.')
end
% Find the type of input argument x
if iscell(X)
    p = length(X);
    for i = 1:p
        % Get all of the sample sizes and the index for the median.
        n(i) = length(X{i});
    end
    if length(unique(n))==1 & varw==1
        error('Cannot do variable width boxplots when the sample sizes are the same.')
    end
    % Get the min and the max of the root n.
    maxn = max(sqrt(n));
    minn = min(sqrt(n));
else
    [n,p] = size(X);
end
% Find some of the things needed to plot them.
% Each boxplot will have a maximum width of 2 units.
ctr = 4:4:4*p;
figure, hold on
for i = 1:p
    % Extract the data.
    if iscell(X)
        x = sort(X{i});
    else
        x = sort(X(:,i));
        plain = 1;
    end
    if varw
        % Then it is a variable width boxplot.
        ns = sqrt(n(i));
        % Scale between 0.5 and 2.
        w = scale(ns, minn, maxn, 0.5, 2);
    end
    % Get the quartiles.
    q = quartiles(x);
    if length(n) ~= 1
        % Then we have different sample sizes.
        N = n(i);
    else
        N = n;
    end
    qinds = getk(N);
    KK = qinds(2);
    Lside = [ctr(i)-(1:KK)*w/(N+1), ctr(i)-(N+1-(KK+1:N))*w/(N+1)];
    Rside = [ctr(i)+(1:KK)*w/(N+1), ctr(i)+(N+1-(KK+1:N))*w/(N+1)];
    plot(Lside,x,'k', Rside,x,'k')
    % plot the quartiles.
    k1 = qinds(1);
    plot([ctr(i)-k1*w/(N+1),ctr(i)+k1*w/(N+1)],[q(1),q(1)],'k')
    k2 = qinds(2);
    plot([ctr(i)-k2*w/(N+1),ctr(i)+k2*w/(N+1)],[q(2),q(2)],'k')
    k3 = qinds(3);
    plot([ctr(i)-(N+1-(k3))*w/(N+1),ctr(i)+(N+1-(k3))*w/(N+1)],[q(3),q(3)],'k')
end
ax = axis;
axis([ctr(1)-2 ctr(end)+2 ax(3:4)])
set(gca,'XTickLabel',' ')
hold off

function K = getk(n)
% This function gets the index K for the median of a sample of size n.
K = zeros(1,3);
if rem(n,2)==0
    % then its even
    K(2) = n/2;
    ptrs = K(2)+1:n; 
else
    K(2) = (n+1)/2;
    ptrs = K(2):n;
end
% Get the index to the first quartile.
if rem(K(2),2) ==0
    % If the median is at an even index, then the halves will have even
    % sizes.
    K(1) = K(2)/2;
    K(3) = ptrs(K(1));
else
    K(1) = (K(2)+1)/2;
    K(3) = ptrs(K(1));
end


function nx = scale(x, a, b, c, d)
% This function converts a value x that orignally between a and b to
% one that is between c and d.
nx = (d - c)*(x - a)/(b - a) + c;
