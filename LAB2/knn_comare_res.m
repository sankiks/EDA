function knn_comare_res(X,Y, k)


% High-D neighbors (use cosine for text; euclidean also possible)
idxHD = knnsearch(X, X, 'K', k+1, 'Distance', 'cosine');
idxHD = idxHD(:,2:end); % drop self

% Low-D neighbors (embedding)
idxLD = knnsearch(Y, Y, 'K', k+1);
idxLD = idxLD(:,2:end);

% "Trustworthiness-like" precision: how many low-D neighbors are true high-D neighbors
prec = mean(sum(ismember(idxLD, idxHD), 2) / k);

% "Continuity-like" recall: how many high-D neighbors are retained in low-D
rec  = mean(sum(ismember(idxHD, idxLD), 2) / k);

fprintf("kNN precision=%.3f, recall=%.3f (k=%d)\n", prec, rec, k);