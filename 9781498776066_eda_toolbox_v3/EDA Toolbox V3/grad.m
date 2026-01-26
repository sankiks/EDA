function [G] = grad(X,dist,disp,r)

% GRADIENT Gradient for Kruskal's Nonmetric MDS
%
% G = GRADIENT(X,DIST,DISP,R)
% Finding the gradient for Minkowski-R distance using
% Kruskal's original paper. The argument R determines the metric.
% Given the configuration of points X, which is nxd and the distances 
% or dissimilarities DIST, and the disparities, DISP. 
% The DIST and DISP are vectors containing the upper triangular part only. 

[K,L] = size(X);
G = zeros(K,L);
% Find these values, because they are the same for all K and L.
Sstar = sum(sum((dist - disp).^2));
Tstar = sum(sum(dist.^2));
stress = sqrt(Sstar/Tstar);

% Find the other values that do not depend on K and L.
T1 = (dist - disp)/Sstar;
T2 = dist/Tstar;
D1 = dist.^(r-1);
CON = ((T1 - T2)./D1);

% Get some other useful things.
p = (K-1):-1:2;
I = zeros(K*(K-1)/2,1);
I(cumsum([1 p])) = 1;
I = cumsum(I);
J = ones(K*(K-1)/2,1);
J(cumsum(p)+1) = 2-p;
J(1)=2;
J = cumsum(J);
N = length(I);

% Now find the gradient for each point.
for k = 1:K
    DI = zeros(1,N);
    DJ = zeros(1,N);
    indi = find(I == k);
    indj = find(J == k);
    DI(indi) = 1;
    DJ(indj) = 1;
    DX = (X(I,:) - X(J,:));
    P1 = (DI - DJ).*CON;
    P2 = abs(DX).^(r-1);
    P3 = sign(DX);
    tmp = repmat(P1',1,L).*P2.*P3;
    G(k,:) = sum(tmp)*stress;
end

        
    
    
    
    
    
    
    
    
    
    
    