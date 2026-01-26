function csandrews(data, Ls,colr)
% CSANDREWS Andrews Curves
%
%   CSANDREWS(X,LINESTYLE,COLOR) This function will plot the
%   Andrews curves for a set of data given in X. X is an n x d
%   matrix, where each row corresponds to an observation.
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
%
%   NOTE: If you want to specify a color, then you must also 
%   specify the linestyle.
%
%   Examples:   csandrews(X) plots solid black lines.
%               csandrews(X,':') plots dotted black lines.
%               csandrews(X,'-','r') plots red solid lines.
%
%   See also CSSTARS, CSPARALLEL

%   W. L. and A. R. Martinez, 9/15/01
%   Computational Statistics Toolbox 


if nargin == 1
     Ls = '-';
     colr = 'k';
 elseif nargin ==2
     colr = 'k';
end

theta = -pi:0.1:pi;    %this defines the domain that will be plotted
[n,p] = size(data);
y = zeros(n,p);       %there will n curves plotted, one for each obs
%
% Now find the functional form depending on the parameter p
%

ang = zeros(length(theta),p);   %each row must be dotted w/ observation
% Get the string to evaluate function.
fstr = ['[1/sqrt(2) '];   %Initialize the string.
for i = 2:p
    if rem(i,2) == 0
        fstr = [fstr,' sin(',int2str(i/2), '*i) '];
    else
        fstr = [fstr,' cos(',int2str((i-1)/2),'*i) '];
    end
end
fstr = [fstr,' ]'];
            
k=0;
% evaluate sin and cos functions at each angle theta
for i=theta
   k=k+1;
   ang(k,:)=eval(fstr);
end

% Now generate a y for each observation
%
for i=1:n     %loop over each observation
  for j=1:length(theta)
    y(i,j)=data(i,:)*ang(j,:)'; 
  end
end

for i=1:n
  line(theta,y(i,:),'Linestyle',Ls,'color',colr)
end
title('Andrews Curves')
xlabel('Theta')
ylabel('Andrews Function')

