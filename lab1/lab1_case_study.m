A=genLDdata;
% Estimate the global intrinsic dimensionality.
% The default is the MLE.
ID = intrinsic_dim(A,'NearNbDim');


% Get the pairwise interpoint distances.
% We use the default Euclidean distance.
Ad = squareform(pdist(A));
% Get the dimensions of the data.
[nr,nc] = size(A);
Ldim = zeros(nr,1);
Ldim2 = Ldim;
[Ads,J] = sort(Ad,2);
% Set the neighborhood size.
k = 100;
for m = 1 : nr
  Ldim(m,1) = ...
    intrinsic_dim(A(J(m,1:k),:));
end
% We map all local dimensions greater
% than 3 to 4 and convert to integers.
Ldim(Ldim > 3) = 4;
Ldim = ceil(Ldim);
% Tabulate them.
tabulate(Ldim)

% The following code constructs a 
% scatterplot with colors mapped to
% the estimated local dimension.
ind1 = find(Ldim == 1);
ind2 = find(Ldim == 2);
ind3 = find(Ldim == 3);
ind4 = find(Ldim == 4);
scatter3(A(ind1,1),A(ind1,2),A(ind1,3),'r.')
hold on
scatter3(A(ind2,1),A(ind2,2),A(ind2,3),'g.')
scatter3(A(ind3,1),A(ind3,2),A(ind3,3),'b.')
scatter3(A(ind4,1),A(ind4,2),A(ind4,3),'k.')
hold off