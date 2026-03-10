load 'C:\Users\johan\Documents\Documents\School\EDA_course\nmfclustex'
% 1-term-document matrix
%2- normalize column vector to unit vector
%3-  apply update equation
%4-  normalize U and V
%5-  use the V matrix to cluster each document
rng(42,"twister");
%normalize
[n,p]=size(nmfclustex);
for i = 1:p
        termdoc(:,i)=nmfclustex(:,i)/... % continuation operation /... means coninue with the rest of operation on next line
            (norm(nmfclustex(:,i)));
end

%apply update equation but they do here X-UVT
for k=2 : 9
[U,VT]=nnmf(termdoc,k,"algorithm",'mult');

V=VT';

% normnalize u and v
% normalizinf V entries
[nu,pu]=size(U);
[nv,pv]=size(V);

for i= 1:nv
    for  j =1:pv
        V(i,j)=V(i,j)*norm(U(:,j));
    end
end

%normalizinf U entries
for j= 1:pu
    U(:,j)= U(:,j)/(norm(U(:,j)));
end

[Y,I] = max(V,[],2);
DunnI(k) = indexDN(V,I,'euclidean');
end