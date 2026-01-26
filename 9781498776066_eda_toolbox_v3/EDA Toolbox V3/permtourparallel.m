function permtourparallel(X)
%   PERMTOURPARALLEL Permutes axes in parallel coordinates
%
%   PERMTOURPARALLEL(X)
%   This tour permutes the axes of a parallel coordinates plot. The user
%   must HIT ANY KEY TO CONTINUE through the tour. 
%   This uses Edward Wegman's minimal permutation tour, JASA, 1990.

[n,p] = size(X);
% Get the permutations - each row corresponds to a different one.
P = permweg(p);
[nP,pP] = size(P);
Hfig = figure('tag','figparatour','renderer','painters','DoubleBuffer','on','backingstore','off');
% Set up the line handles - need n of these
Hline = zeros(1,n);
for i = 1:n
    Hline(i) = line('xdata',nan,'ydata',nan,'linestyle','-');
end
% get the axes lines
ypos = linspace(0,1,p);
xpos = [0 1];
% THe following gets the axis lines.
% Save the text handles, so they can be permuted, too.
% Save the text strings, too.
Htext = zeros(1,p);
k = p;
for i=1:p            
    line(xpos,[ypos(i) ypos(i)],'color','k')
    Htext(i) = text(-0.05,ypos(i), ['x' num2str(k)]);
    k=k-1;
end
axis off
% parallel(Hline,X,Htext,1:p);
disp('HIT ANY KEY TO CONTINUE')

% Loop through all of the permutations.
for i = 1:nP
    % permute the columns by the row of the permutation matrix
    xP = X(:,P(i,:));
    parallel(Hline,xP,Htext,P(i,:));
    pause
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function parallel(Hline,x,Htext,P)

% If parallel coordinates, then change range.
% map all values onto the interval 0 to 1
% lines will extend over the range 0 to 1
md = min(x(:)); % find the min of all the data
rng = range(x(:));  %find the range of the data
xn = (x-md)/rng;
[n,p] = size(x);
ypos = linspace(0,1,p);
for i=1:n
    set(Hline(i),'xdata',xn(i,:),'ydata',fliplr(ypos))
end   
P = fliplr(P);
for i = 1:p            
    set(Htext(i),'string', ['x' num2str(P(i))]);
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