%function [idx, Y,ri]=spectral_cluster(X)
load 'C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3\FastICA\oronsay.mat'
addpath('C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3\Spectral\algos')


%{ 

% Get the affinity matrix using a sigma of 1.
A = AffinitySimilarityMatrix(X',1);
% Get the cluster ID's according to the spectral
% clustering according to Ng, Jordan and Weiss and
% also using k-means.
cids = cluster_spectral_general(A,2,'njw_gen','njw_kmeans');
%}
X=oronsay;
A=AffinitySimilarityMatrix(X',1);

% define matrix D fuck mitt liv

D=diag(sum(A,2));
d=diag(D);
DinvSqrt = 1./sqrt(d);
Dsq=diag(DinvSqrt);
L=Dsq*A* Dsq;
[eigvec,eigval]=eig(L);
%take higest beacuse L=DAD, if L=I-DAD then take lowest
[EVALs indx]=sort(diag(eigval),'descend');

eigval=diag(EVALs);
eigvec=eigvec(:,indx);
eigvalk3=diag(eigval(1:3,1:3));
eigveck3=eigvec(:,1:3);

Us = sqrt(sum(eigveck3.^2,2));
Y=eigveck3./Us;

[idx, c]=kmeans(Y,3,'Replicates',20,'MaxIter',1000)

gscatter(Y(:,1),Y(:,2));


idx_ones=find(idx==1);
idx_twos=find(idx==2);
idx_threes=find(idx==3);
bd0=find(beachdune==0);
bd1=find(beachdune==1);
bd2=find(beachdune==2);
%n=size(idx,1);
TP=0;TN=0;FP=0;FN=0;
ri=randind(beachdune,idx);





