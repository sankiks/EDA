load 'C:\Users\johan\Documents\Documents\School\EDA_course\nmfclustex'
addpath('C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3')
% Next we call the PLSA function with 2 topics and 
% 100 iterations of the algorithm.


for k=2:10
       idx=kmeans(nmfclustex,k,'Replicates',5,'MaxIter',1000)
       IDX(:,k)=idx(:);
       DunnI(k) = indexDN(nmfclustex,idx(:),'euclidean');
end
    

plot(idx,idx,'o')
ylabel('Dunn Index')