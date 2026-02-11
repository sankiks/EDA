
load 'C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3\leukemia.mat'
y= leukemia
D = squareform(pdist(y.','seuclidean'));
[n,p] = size(D);

Q = -0.5*D.^2;

H = eye(n) - ones(n)/n;
B = H*Q*H;
[A,L] = eig(B);
[vals, inds] = sort(diag(L));
inds = flipud(inds);
vals = flipud(vals);
A = A(:,inds);
L = diag(vals);
figure();
semilogy(vals(1:10),'o')
figure();
X = A(:,1:2)*diag(sqrt(vals(1:2)));
A = find(strcmp(btcell,'T'));
B = find(strcmp(btcell,'B'));
NA = find(strcmp(btcell,'NA'));
plot(X(A,1),X(A,2),'X',X(B,1),X(B,2),'o',X(NA,1),X(NA,2),'.')
legend({'BTCELL A';'BTCELL B';'BTCELL NA'})
figure()
ALL=find(strcmp(cancertype,'ALL'));
AML=find(strcmp(cancertype,'AML'));

plot(X(ALL,1),X(ALL,2),'X',X(AML,1),X(AML,2),'o')
legend({'ALL';'AML'})

