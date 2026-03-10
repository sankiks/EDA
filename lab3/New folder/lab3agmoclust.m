load 'C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3\lungB.mat'
addpath 'C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3'

X=lungB' ;

X=log(X+1); %normalize data and reduce effect of outliers
A=zscore(X); % standarize to same same mean 0 and std 1

[coeff, score, ~, ~, explained] = pca(X); % reduce dim
k = find(cumsum(explained) >= 90, 1);   % get higest egienvalues with 90% variance

Y = score(:,1:k);                       % 156 × k
Z=linkage(Y,'ward','seuclidean');

T = cluster(Z,'maxclust',2);            % choose your number of clusters

d=pdist(Y, "seuclidean");
[c, d]=cophenet(Z,d)

%dendrogram(Z);

%cind = cluster(Z,2);
%S = silhouette(X,cind);
