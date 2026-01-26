function intour(X,t1,t2)
% INTOUR    Interpolation Tour
%
% INTOUR(X, T1, T2)
% This file implements the interpolation tour as explained in Young and
% Rheinagans: Visualizing Structure in High-Dimensional Multivariate Data. 
% It centers the data at the origin and normalizes according to the
% standard deviation. The tour rotates through 90 degrees to the target
% plane and then through another 270 degrees back to the starting plane.
% The first argument X is the data matrix. T1 is a 2 element vector
% containing column indices for the first plane. Similarly, T2 is a 2
% element vector containing indices for the target plane. These indices are
% for the principal components.

% standardize to have unit length and center at origin
[m,p] = size(X);
xc = X - repmat(sum(X)/m,m,1);  % Remove mean
for i = 1:p
    xc(:,i) = xc(:,i)/std(xc(:,i));
end
xs = [xc; eye(p)];
theta = (0:1:90)*pi/180;

% Find the PCs of the data set
[PC,D] = eig(cov(xc));
T1 = xs*PC(:,t1);
T2 = xs*PC(:,t2);
mx = max([T1(:,1);T2(:,1)]);
my = max([T1(:,2);T2(:,2)]);

ph = plot(T1(1:m,1),T1(1:m,2),'o','erasemode','normal');
title(['Start Axes: ',int2str(t1(1)), ' ', int2str(t1(2)), '; ',...
        'Target Axes: ',int2str(t2(1)), ' ', int2str(t2(2)),])
axis equal
axis([-mx mx -my my ])
axis off
hold on
Hax11 = plot([0 T1(m+1,1)*2],[0 T1(m+1,2)*2],'k');
Hax12 = plot([0 T1(m+2,1)*2],[0 T1(m+2,2)*2],'k');
Hax21 = plot([0 T2(m+1,1)*2],[0 T2(m+1,2)*2],'k');
Hax22 = plot([0 T2(m+2,1)*2],[0 T2(m+2,2)*2],'k');
hold off
shg
H = uicontrol(gcf,'style','text',...
    'units','normalized',...
    'position',[0.01 0.01 0.2 0.1],...
    'string','PAUSE: Hit Any Key to Continue');
pause
delete(H)
set(gcf,'backingstore','off','renderer','painters','DoubleBuffer','on')
for i = 2:length(theta)
    V = T1*diag(ones(1,2)*cos(theta(i)))+T2*diag(ones(1,2)*sin(theta(i)));
    set(ph,'Xdata',V(1:m,1),'Ydata',V(1:m,2));
    set(Hax11,'Xdata',[0 V(m+1,1)*2],'Ydata',[0 V(m+1,2)*2]);
    set(Hax12,'Xdata',[0 V(m+2,1)*2],'Ydata',[0 V(m+2,2)*2]);
    pause(0.05)
end
H = uicontrol(gcf,'style','text',...
    'units','normalized',...
    'position',[0.01 0.01 0.2 0.1],...
    'string','PAUSE: Hit Any Key to Continue');
pause
delete(H)
theta = (90:1:360)*pi/180;
for i = 2:length(theta)
    V = T1*diag(ones(1,2)*cos(theta(i)))+T2*diag(ones(1,2)*sin(theta(i)));
    set(ph,'Xdata',V(1:m,1),'Ydata',V(1:m,2));
    set(Hax11,'Xdata',[0 V(m+1,1)*2],'Ydata',[0 V(m+1,2)*2]);
    set(Hax12,'Xdata',[0 V(m+2,1)*2],'Ydata',[0 V(m+2,2)*2]);
    drawnow
    %pause(0.05)
end



