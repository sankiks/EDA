rng('default') % For reproducibility
X = [1,1,1;3,3,3;2,2,2;4,4,4;5,5,5]
D = pdist(X)
[idx,dist]=knnsearch(X,X,'K',3)