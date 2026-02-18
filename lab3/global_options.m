% First the mixing coefficients will be equal.
pie1 = 0.5;
pie2 = 0.5;
% Let the means be -2 and 2.
mu1 = -2;
mu2 = 2;

% The standard deviation of the first term is 0.5 
% and the second one is 1.2.
sigma1 = 0.5;
sigma2 = 1.2;

% Now generate a domain over which to evaluate the 
% function.
x = linspace(-6, 6);

% The following is a Statistics Toolbox function.
y1 = normpdf(x,mu1,sigma1);
y2 = normpdf(x,mu2,sigma2);
% Now weight and add to get the final curve.
y = pie1*y1 + pie2*y2;
% Plot the final function.
plot(x,y)
xlabel('x'), ylabel('Probability Density Function')
title('Univariate Finite Mixture - Two Terms')