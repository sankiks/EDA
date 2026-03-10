load("C:\Users\johan\Documents\Documents\School\EDA_course\LAB2\isomap.mat")
X=double(images');
[n,p]=size(X);
[idx,dist]=knnsearch(X,X,'K',7); % 6 neigbhors plus one self points
idx(:,1)=[];% remove the self idx
dist(:,1)=[];% remove the self distances
W=zeros(n);
W(1:n+1:n*n) = 0;
for i=1:n
    W(i,idx(i,:))=dist(i,:);
end
W=max(W,W');
Ggraph=graph(W);
Dg=distances(Ggraph);
if any(isinf(Dg(:)))
    error("Graph disconnected: increase K or remove outliers/keep giant component.");
end
Q=-0.5 * Dg.^2;

I=eye(n);
one=ones(n,1);
H=I - 1/n * one * one';
B=H*Q*H;
[V,D]=eig(B);
[d,ind] = sort(diag(D),"descend");
D=D(ind, ind);
V=V(:,ind);
y=V*D.^(1/2);

scatter(y(:,1),y(:,2),12,'filled');






