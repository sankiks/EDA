function qhat = quantileseda(x,p)
% QUANTILESEDA Sample quantiles.
%
%	QHAT = QUANTILESEDA(X,P) Returns the sample quantiles
%	for the probabilities given in P using the sample in
%	X.


if ~isempty(find(p <= 0 | p >1))
    error('Probabilities must be between 0 and 1')
    return
end
xs=sort(x);
qhat = zeros(size(p));
n=length(x);
phat = ((1:n)-0.5)/n;
% use linear interpolation to find the quantiles.
% think of the phat as the x's and the order statistics as the
% y's. We will use the definition that the j-th order statistic
% is an estimate of the (j-0.5)/n quantile. If we want some other
% quantile, then we can use linear interpolation.
qhat=interp1(phat,xs,p);
      