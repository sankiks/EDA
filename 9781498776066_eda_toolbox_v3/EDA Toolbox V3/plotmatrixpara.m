function plotmatrixpara(X,classlabs,map,titlestr);
%   PLOTMATRIXPARA  Plotmatrix of parallel coordinate plots.
%   
%   PLOTMATRIXPARA(X,CLASSLAB,MAP,TITLESTR)
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
%       plotmatrixpara(X,classlabs)     % Default colors, no title
%       plotmatrixpara(X,classlabs,[],'My Plot')   % Default colors, with title
%       plotmatrixpara(X,classlabs,{'k','m'})   % No title, colors black and magenta are used

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
% map all values 0nto the interval 0 to 1
% lines will extend over the range 0 to 1
md = min(X(:)); % find the min of all the data
rng = range(X(:));  %find the range of the data
xn = (X-md)/rng;
ypos = linspace(0,1,p);
xpos = [0 1];
% Get the layout of the subplots.
nr = round(sqrt(nclass));
nc = ceil(nclass/nr);

for cc = 1:nclass
    % plot the rest of them
    cls = classes(cc);
    inds = find(classlabs==cls);
    % Has to be the scaled data.   
    subplot(nr,nc,cc)
    axis equal
    axis off
    k=p;
    % THe following gets the axis lines.
    for i=1:p            
        line(xpos,[ypos(i) ypos(i)],'color','k')
        k=k-1;
    end
    if isnumeric(map)
        % Then it must be the rgb matrix.
        parallel(xn(inds,:),map(cc,:),ypos);
    elseif iscell(map)
        parallel(xn(inds,:),map{cc},ypos);
    end
    line(xpos,[0 + .004 0+.004],'color','k')
    line(xpos,[1-.004 1-.004],'color','k')
    %         title(['Class ', strgclass{cc}],'color','w')
    if isnumeric(classes)
        title(['Class ', int2str(classes(cc))],'color','k')
    elseif iscell(classes)
        title(['Class ',classes{cc}],'color','k')
    end
end

if ~isempty(titlestr)
    % Put a title around the whole thing.
    toptitle(titlestr)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       PARALLEL COORDINATES PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function parallel(x,cl,ypos)

[n,p] = size(x);
for i=1:n
   line(x(i,:),fliplr(ypos),'color',cl)
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

