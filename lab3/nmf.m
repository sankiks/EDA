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
for k=2 : 10
[U,VT]=nnmf(termdoc,3,"algorithm",'mult');

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

% First we set up a cell array of labels, so
% we can use these in the plot.
%{  
lab={'d1','d2','d3','d4','d5','d6','d7','d8','d9'};
plot(V(1:5,1),V(1:5,3), 'k*')
text(V(1:5,1)+.05, V(1:5,3),lab(1:5))
hold on
plot(V(6:9,1), V(6:9,3),'ko')
text(V(6:9,1), V(6:9,3)+.05,lab(6:9))
xlabel('V1')
ylabel('V2')
hold off 
figure()
% Here we extract the axes corresponding to 


% each document.
[Y,I] = max(V,[],2);
% View the contents of I, which is the column where
% the maximum value occurred.
I'
silhouette(V, I)
DunnI = indexDN(V,I,'euclidean');
%}

