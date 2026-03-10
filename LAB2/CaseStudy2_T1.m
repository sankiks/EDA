% Use the Leukemia data, using the genes (columns)
% as the observations.

load 'C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3\leukemia.mat'
y = leukemia';
% Get the interpoint distance matrix.
% pdist gets the interpoint distances.
% squareform converts them to a square matrix.
D = squareform(pdist(y,'euclidean'));
[n,p] = size(D);
% Turn off this warning... :
warning off MATLAB:divideByZero

% Get the first term of stress.
% This is fixed - does not depend on the configuration.
stress1 = sum(sum(D.^2))/2;  
% Now find an initial random configuration.
d = 2;
% This function is part of Statistics Toolbox,
% but one can use the function rand and scale them.
rng(42); % Set seed to 42
Z = unifrnd(-2,2,n,d);
% Find the stress for this.
DZ = squareform(pdist(Z));
stress2 = sum(sum(DZ.^2))/2;
stress3 = sum(sum(D.*DZ));
oldstress = stress1 + stress2 - stress3;

% Iterate until stress converges.
tol = 10^(-6);
dstress = realmax;
numiter = 1;
dstress = oldstress;
while dstress > tol & numiter <= 100000
    numiter = numiter + 1;
    % Now get the update.
    BZ = -D./DZ;
    for i = 1:n
        BZ(i,i) = 0;
        BZ(i,i) = -sum(BZ(:,i));
    end
    X = n^(-1)*BZ*Z;
    Z = X;     
    % Now get the distances.
    % Find the stress.



    DZ = squareform(pdist(Z));
    stress2 = sum(sum(DZ.^2))/2;
    stress3 = sum(sum(D.*DZ));
    newstress = stress1 + stress2 - stress3;
    dstress = oldstress - newstress;
    oldstress = newstress;
end

T=find(strcmp(btcell,'T'));
B=find(strcmp(btcell,'B'));
NA=find(strcmp(btcell,'NA'));
figure()
scatter(X(T,1),X(T, 2),'o',"red")
hold on
scatter(X(B,1),X(B, 2), 'x',"g");
scatter(X(NA,1),X(NA, 2), '.','blue');
hold off
legend({'T-cell','B-cell','Unlabeled'})
xlabel('MDS Dimension 1')
ylabel('MDS Dimension 2')
title('SMACOF MDS (2D)')

figure()
ALL=find(strcmp(cancertype,'ALL'));
AML=find(strcmp(cancertype,'AML'));

scatter(X(ALL,1),X(ALL, 2),'o',"red")
hold on
scatter(X(AML,1),X(AML, 2), 'x',"g");
hold off
legend({'ALL','AML'})
xlabel('MDS Dimension 1')
ylabel('MDS Dimension 2')
title('SMACOF MDS (2D)')
