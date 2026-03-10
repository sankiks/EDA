
%We use the oronsay data to illustrate the projection pursuit procedure, 
% which is implemented in the ppeda function provided with this text. 
% First we do some preliminaries, 
% such as loading the data and setting the parameter values.

clear; clc;
load("/MATLAB Drive/EDA Toolbox V3/oronsay.mat")
X = oronsay;
[n,p] = size(X);
%For m=5 random starts, find the N = 2
% best projection planes.
N = 2;
m = 5; 
% Set values for other constants. 
c = tan(80*pi/180);
half = 30;
% These will store the results for the 2 structures.
astar = zeros(p,N);
bstar = zeros(p,N);
ppmax = zeros(1,N);
%Next we sphere the data to obtain matrix Z.
muhat = mean(X);
[V,D] = eig(cov(X));
Xc = X - ones(n,1) *muhat;
Z = ((D)^(-1/2)V'Xc')';
% Now we find each of the desired number of structures using the ppeda
% function with the index argument set to the Posse chi-square index.

% Now do the PPEDA: Find a structure, remove it,
   % and look for another one.
Zt = Z;
for i = 1:N
    %find one structure
    [astar(:,i),bstar(:,i),ppmax(i)] = ...
        ppeda(Zt, c, half, m, 'chi');
    %Now remove the structure
    %Function comes with text. 
    Zt = csppstrtrem(Zt,astar(:,i),bstar(:,i));
end

% Now project and see the structure.
proj1 = [astar(:,1), bstar(:,1)];
proj2 = [astar(:,2), bstar(:,2)];
Zp1 = Zproj1;
Zp2 = Zproj2;
figure
plot(Zp1(:,1),Zp1(:,2),'y.'),title('Structure 1')
xlabel('\alpha'),ylabel('\beta')
figure
plot(Zp2(:,1),Zp2(:,2),'y.'),title('Structure 2')
xlabel('\alpha'),ylabel('\beta')