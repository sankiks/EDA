function [y,theta] = andrewsvals(data)
% ANDREWSVALS Values for Andrews Curves
%
%   ANDREWSVALS(X) This function will return the values of the
%   Andrews curves for a set of data given in X. X is an n x d
%   matrix, where each row corresponds to an observation.
%
%
%   See also CSANDREWS

%   W. L. and A. R. Martinez, 7/12/10
%   EDA Toolbox 

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


