function mojenaplot(Z,nc)

% MOJENAPLOT    'Mojena Rule' plot for estimating the number of clusters
%
%   MOJENAPLOT(Z,NC) produces a plot corresponding to the graphical Mojena
%   rule for estimating the number of clusters from hierarchical
%   clustering. Z is the output from the LINKAGE function. NC is an
%   optional argument specifying the maximum number of clusters to include.
%   The default is 10.

% Reference: Everitt, Landau and Leese, Cluster Analysis, 4th Edition

if nargin == 1
    nc = 10;
end

% Flip the Z matrix - makes it easier.
Zf = flipud(Z);
for i = 1:nc
    abar(i) = mean(Zf(i:end,3));
    astd(i) = std(Zf(i:end,3));
end
yv = (Zf(1:nc,3) - abar(:))./astd(:);
xv = 1:nc;
plot(xv,yv,'-o')