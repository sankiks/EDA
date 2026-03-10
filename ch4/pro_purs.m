addpath('C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3')
load oronsay
X=oronsay;
[n,p]=size(X);
 % For m=5 random starts, find the N = 2
 %best projection planes.

 N=2;
 m=5;
 %Set values for other constants.
 c= tan(89*pi/180);
 half=30;
 %These will store the results for the
 % 2structure.

 astar=zeros(p,N);
 bstar=zeros(p,N);
 ppmax=zeros(1,N);

 %sphere the data.
muhat=mean(X);
[V,D]=eig(cov(X));
%center the data 
Xc = X - muhat;
Z = ((D)^(-1/2)*V'*Xc')';

% Now do the PPEDA: Find a structure, remove it,
% and look for another one.
Zt=Z;
for i = 1:N;
    % find one structure
    [astar(:,i),bstar(:,i),ppmax(i)]=ppeda(Zt,c,half,m,'chi');
    %now remove the structure.
    %Function comes with text.
    Zt=csppstrtrem(Zt,astar(:,i),bstar(:,i));
end

%how to project data
proj1=[astar(:,1),bstar(:,1)];
proj2=[astar(:,2),bstar(:,2)];

Zp1=Z*proj1;
Zp2=Z*proj2;

figure
plot(Zp1(:,1),Zp1(:,2),'k.'),title('Structure 1')
xlabel('\alpha*'),ylabel('\beta*')

figure
plot(Zp2(:,1),Zp2(:,2),'k.'),title('Structure 2')
xlabel('\alpha*'),ylabel('\beta*')