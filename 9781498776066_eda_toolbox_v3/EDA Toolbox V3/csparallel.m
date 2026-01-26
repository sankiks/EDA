function csparallel(x,cl,colr)
% CSPARALLEL Parallel coordinates plot.
%
%   CSPARALLEL(X,LINESTYLE,COLOR) Constructs a parallel coordinates
%   plot for the data in X. 
%
%   The user has the option of specifying the LINESTYLE via the input 
%   argument. These are the usual MATLAB linestyles. The default
%   LINESTYLE is the solid line.
%
%   The user has the option of specifying the COLOR via the input
%   argument. This can be a 3 element RGB vector or one of the
%   MATLAB predefined colors. The default color is black.
%
%   See HELP on PLOT for information on the available LINESTYLES
%   and a list of the predefined colors.
%   NOTE: If you want to specify a color, then you must also 
%   specify the linestyle.
%
%   Examples:   csparallel(X) plots solid black lines.
%               csparallel(X,':') plots dotted black lines.
%               csparallel(X,'-','r') plots red solid lines.
%
%   See also CSSTARS, CSANDREWS


%   W. L. and A. R. Martinez, 9/15/01
%   Computational Statistics Toolbox 


[n,p]=size(x);

if nargin == 1
     cl = '-';
     colr = 'k';
 elseif nargin ==2
     colr = 'k';
end

%figure('units','norm')
axes('units','norm')
axis equal
axis([-0.1 1.05 0 1])
axis off

% set up the lines
ypos = linspace(0.1, 0.9,p);
xpos = [0 1];
k=p;
for i=1:p
   line(xpos,[ypos(i) ypos(i)],'color','k')
   text(-0.05,ypos(i), ['x' num2str(k)] )
   k=k-1;
end

% map all values 0nto the interval 0 to 1
% lines will extend over the range 0 to 1
md = min(x(:)); % find the min of all the data
rng = range(x(:));  %find the range of the data
xn = (x-md)/rng;

for i=1:n
   line(xn(i,:),fliplr(ypos),'linestyle',cl,'color',colr)
end

