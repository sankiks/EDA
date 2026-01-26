function [dim] = localdim(x,xipd,k,method)
%x nxp featue matrix
%xipd ipd matrix in square form as produced by pdist
%k choice for k
%method dimensionality estimation method 
%dim vector of local dim estimates
[nr,nc]=size(x);
dim = zeros(nr,1);
[xipds,J] = sort(xipd,2);
for m = 1 : nr
    m
    dim(m,1) = intrinsic_dim(x(J(m,1:k),:));
end
