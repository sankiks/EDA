function rangefinder(X, labs)

%  RANGEFINDER  Rangefinder - A Bivariate Boxplot
%
%   BOXP(X, LABS)
%   This function constructs a bivariate rangefinder boxplot. 
%   This shows the same information as a 2-D boxplot superimposed
%   on a scatterplot.
%
%   The input X is an n x 2 matrix. 
%   The optional argument LABS can be used to provide axis labels.
%

% Exploratory Data Analysis with MATLAB, 2nd Edition
% Wendy L. and Angel R. Martinez and Jeff Solka
% Example of constructing Rangefinder Boxplots

% Do some error-checking.
[n,p] = size(X);
if p ~= 2
    error('There must be 2 columns in the data matrix X.')
end

% Set up default axis labels, if none were given.
if nargin == 1
    labs = {'Variable 1','Variable 2'};
end

% Construct a scatterplot.
plot(X(:,1),X(:,2),'.')
xlabel(labs{1})
ylabel(labs{2})
title('Rangefinder Boxplot')
% Hold the plot, so we can add the lines.
hold on

% Find the quartiles for each variable.
qx1 = quartiles(X(:,1));
qx2 = quartiles(X(:,2));
% Find the interquartile ranges.
iqr1 = qx1(3) - qx1(1);
iqr2 = qx2(3) - qx2(1);

% Find the upper and lower limits.
LL1 = qx1(1) - 1.5*iqr1;
UL1 = qx1(3) + 1.5*iqr1;
LL2 = qx2(1) - 1.5*iqr2;
UL2 = qx2(3) + 1.5*iqr2;

% Now find the adjacent values.
Xs(:,1) = sort(X(:,1));
Xs(:,2) = sort(X(:,2));
ind1 = find(Xs(:,1) > LL1 & (Xs(:,1) < UL1));
adjv1 = [min(Xs(ind1,1)), max(Xs(ind1,1))];
ind2 = find(Xs(:,2) > LL2 & (Xs(:,2) < UL2));
adjv2 = [min(Xs(ind2,2)), max(Xs(ind2,2))];

% Place the cross at the medians.
plot([qx1(1),qx1(3)],[qx2(2),qx2(2)],'r')
plot([qx1(2),qx1(2)],[qx2(1),qx2(3)],'r')
% Plot a circle at the medians to check.
plot(qx1(2),qx2(2),'o')

% Plot the two vertical lines at the
% adjacent values for x_1.
plot([adjv1(1),adjv1(1)], [qx2(1),qx2(3)],'g')
plot([adjv1(2),adjv1(2)], [qx2(1),qx2(3)],'g')

% Plot the two horizontal lines at the
% adjacent values for x_2.
plot([qx1(1),qx1(3)], [adjv2(1),adjv2(1)],'g')
plot([qx1(1),qx1(3)], [adjv2(2),adjv2(2)],'g')




