load 'C:\Users\johan\Documents\Documents\School\EDA_course\nmfclustex'
addpath('C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3') 

% 100 iterations of the algorithm.



   % rng(42,"twister");
    [~,S] = PLSA(nmfclustex,3,1000);
    [~,I] = max(S',[],2);
   
   
    DunnI = indexDN(S',I,'euclidean');


figure()
lab={'d1','d2','d3','d4','d5','d6','d7','d8','d9'};
plot(S(1,1:5),S(2,1:5), 'k*')
text(S(1,1:5)+.05, S(2,1:5),lab(1:5))
hold on
plot(S(1,6:9), S(2,6:9),'o')
text(S(1,6:9), S(2,6:9)+.05,lab(6:9))
xlabel('V1')
ylabel('V2')
hold off 
figure() 
 

[s,h]=silhouette(nmfclustex',I)
mean(s)
