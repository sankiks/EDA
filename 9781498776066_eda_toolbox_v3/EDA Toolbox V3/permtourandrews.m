function permtourandrews(X,flag)
%   PERMTOURANDREWS Permutes variable order in Andrews' curves
%
%   PERMTOURANDREWS(X,FLAG)
%   This tour permutes the variable order in an Andrews' curves plot. 
%   The user must HIT ANY KEY TO CONTINUE through the tour. The default
%   tour is to use ALL p! permutations. To get a partial tour, use any 
%   value for the optional input argument FLAG.

[n,p] = size(X);
if nargin == 2
    % Get the Wegman partial tour
    % Get the permutations - each row corresponds to a different one.
    P = permweg(p);
else
    P = perms(1:p);
end
[nP,pP] = size(P);
Hfig = figure('tag','figparatour','renderer','painters','DoubleBuffer','on','backingstore','off');
% Set up the line handles - need n of these
Hline = zeros(1,n);
for i = 1:n
    Hline(i) = line('xdata',nan,'ydata',nan,'linestyle','-');
end

% THe following gets the axis lines.
% Save the text handles, so they can be permuted, too.
% Save the text strings, too.
axis off
theta = -pi:0.1:pi;    %this defines the domain that will be plotted
y = zeros(n,p);       %there will n curves plotted, one for each obs
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

disp('HIT ANY KEY TO CONTINUE')

% Loop through all of the permutations.
for i = 1:nP
    % permute the columns by the row of the permutation matrix
    xP = X(:,P(i,:));
    andrews(Hline,xP,theta,ang);
    pause
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       ANDREWS CURVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function andrews(Hline,data,theta,ang)
[n,p] = size(data);

% Now generate a y for each observation
%
for i=1:n     %loop over each observation
  for j=1:length(theta)
    y(i,j)=data(i,:)*ang(j,:)'; 
  end
end

for i=1:n
  set(Hline(i),'xdata',theta,'ydata',y(i,:));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function P = permweg(p)
% This gets a smaller number of permutations to get all possible ones.

N = ceil((p-1)/2);
% Get the first sequence.
P(1) = 1;
for k = 1:(p-1)
    tmp(k) = (P(k) + (-1)^(k+1)*k);
    P(k+1) = mod(tmp(k),p);
end
% To match our definition of 'mod':
P(find(P==0)) = p;

for j = 1:N;
    P(j+1,:) = mod(P(j,:)+1,p);
    ind = find(P(j+1,:)==0);
    P(j+1,ind) = p;
end