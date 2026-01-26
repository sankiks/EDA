function plotmatrixandr(X,classlabs,map,titlestr)
%   PLOTMATRIXANDR  Plotmatrix of Andrews' curves plots.
%   
%   PLOTMATRIXANDR(X,CLASSLAB,MAP,TITLESTR)
%   This constructs a plotmatrix with p plots for an n x p matrix X. The
%   vector CLASSLAB contains n numeric class labels. The MAP is an optional
%   input argument that is either a colormap matrix (3 columns - RGB
%   values) or a cell array of strings containing the usual
%   Matlab color code (see PLOT for more information). If this is not
%   provided, then the default colors are used (up to 7 of them). Also
%   optional is the input variable TITLESTR that provides a title for the
%   plot. Use the empty matrix [] as in input argument, if you do
%   necessary.
%
%   Example:
%
%       plotmatrixandr(X,classlabs)     % Default colors, no title
%       plotmatrixandr(X,classlabs,[],'My Plot')   % Default colors, with title
%       plotmatrixandr(X,classlabs,{'k','m'})   % No title, colors black and magenta are used

[n,p] = size(X);
if nargin == 2  
    titlestr = [];
    map = {'b','g','r','c','m','y','k'};
elseif (nargin==4 & isempty(map))
    map = {'b','g','r','c','m','y','k'};
elseif nargin == 3 & isnumeric(map)
    [nn, mp] = size(map);
    if mp ~= p
        error('Not enough entries in the colormap')
        return
    end
elseif length(map) ~= p
    error('Not enough entries in the colormap')
    return
end
if nargin == 3
    titlestr = [];
end

% then do the curves
% Get the class labels for all points.
classes = unique(classlabs);
nclass = length(classes);
% Get the layout of the subplots.
nr = round(sqrt(nclass));
nc = ceil(nclass/nr);
% Keep the axes limits, so we can put them all on the same ones.
AXs3 = zeros(1,nclass);
AXs4 = zeros(1,nclass);

% plot the rest of them
for cc = 1:nclass
    cls = classes(cc);
    inds = find(classlabs==cls);
    subplot(nr,nc,cc);
    if isnumeric(map)
        % Then it must be the rgb matrix.
        andrews(X(inds,:),'-',map(cc,:));
    elseif iscell(map)
        andrews(X(inds,:),'-',map{cc});
    end
    axs = axis;
    axis([-pi pi axs(3) axs(4)]);
    AXs3(cc) = axs(3);
    AXs4(cc) = axs(4);
    if isnumeric(classes)
        title(['Class ', int2str(classes(cc))],'color','k');
    elseif iscell(classes)
        title(['Class ',classes{cc}],'color','k');
    end
end
% Loop through and put them all on the same axes.
axmin = min(AXs3);
axmax = max(AXs4);
for cc = 1:nclass
    subplot(nr,nc,cc);
    axis([-pi pi axmin axmax]);
end
% Put a title around the whole thing.
if ~isempty(titlestr)
    toptitle(titlestr)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       ANDREWS CURVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function andrews(data, Ls,colr)

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
  line(theta,y(i,:),'Linestyle',Ls,'color',colr);
end

function toptitle(string)
% TOPTITLE
%
% Places a title over a set of subplots.
% Best results are obtained when all subplots are
% created and then toptitle is executed.
%
% Usage:
%            h = toptitle('title string')
%          

% Patrick Marchand (prmarchand@aol.com)

titlepos = [.5 1]; % normalized units.

ax = gca;
set(ax,'units','normalized');
axpos = get(ax,'position');

offset = (titlepos - axpos(1:2))./axpos(3:4);

text(offset(1),offset(2),string,'units','normalized',...
     'horizontalalignment','center','verticalalignment','middle');

% Make the figure big enough so that when printed the
% toptitle is not cut off nor overlaps a subplot title.
h = findobj(gcf,'type','axes');
set(h,'units','points');
set(gcf,'units','points')
figpos = get(gcf,'position');
set(gcf,'position',figpos + [0 0 0 15])
set(gcf,'units','pixels');
set(h,'units','normalized');


