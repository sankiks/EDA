load("C:\Users\johan\Documents\Documents\School\EDA_course\LAB2\isomap.mat")

X=double(images'); % make sure we have them in double otherwise we will get rounded integers at later stages
[n,p]=size(X);

%get distances
D=squareform(pdist(X, 'euclidean'));

k=6;
[idx,dist] = knnsearch(X,X,"K", k+1);
idx = idx(:,2:end);
dist = dist(:,2:end);
W = inf(n);

for i = 1:n
   W(i,idx(i,:))=dist(i,:); % at row i take index of idx and fill them with distances  
end
W = min(W, W'); % symetric matrix dij=dji
W(1:n+1:end) = 0; % diagonal=0

Ggraph = graph(W);
Dg = distances(Ggraph);


H=eye(n)-(1/n) *ones(n);
G=-1/2 * Dg.^2;
B=H*G*H;
B = (B + B')/2; 

[v,l]=eig(B);

lam = real(diag(l));
[lam_sorted, order]=sort(lam,'descend');
v_sorted = v(:,order);

pos = find(lam_sorted > 1e-9);
d = 2;
use = pos(1:d);


Y = v_sorted(:,1:2) * diag(sqrt(lam_sorted(use)));

scatter(Y(:,1), Y(:,2), 10, 'filled');