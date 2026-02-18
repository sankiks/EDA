load 'C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3\lungB.mat'
addpath 'C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3'

X=lungB'
% Then call the function for agglomerative MBC.
Z=agmbclust(X);
% We can apply the silhouette procedure for this
% after we find a partition. Use 3 groups.
%dendrogram(Z);
cind = cluster(Z,2);
S = silhouette(X,cind);
