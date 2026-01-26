function multiwayplot(x,laby,labx,subtitle,sublocs)

%   MULTIWAYPLOT    Mutli-panel dotplot - useful for grouped data
%
%   MULTIWAYPLOT(X,LABY,LABX,SUBTITLE,SUBLOCS)
%   Constructs a multiway dotchart, where each panel corresponds to a group.
%   The input argument X is a matrix with N rows and G columns (number of
%   groups). Each panel has a subtitle given by SUBTITLE, which is a cell 
%   array of titles. LABY is a cell array of N strings. LABX is a string
%   for the single xlabel. SUBLOCS is an optional argument specifying the
%   position of the panels. It is a cell array containing the layout of the
%   plots. The first element of the array is a two-element vector
%   containing the number of rows and the number of columns. The second
%   element of the cell array contains the order of the groups, counting
%   left to right and top to bottom. For example:
%
%   sublocs{1} = [2,2]; sublocs{2} = [1, 3, 4, 2];
%
%   would construct a 2 by 2 matrix of dotcharts, with group 1 in the upper
%   left corner, group 3 in the upper right corner, group 4 in the lower
%   left and group 2 in the lower right.

[n,G] = size(x);  % Number of groups

if nargin == 4
    % Get the layout ourselves. 
    nr = round(sqrt(G));
    nc = ceil(G/nr);
    p = 1:G;
else
    nr = sublocs{1}(1);
    nc = sublocs{1}(2);
    p = sublocs{2};
    if length(p) ~= G
        error('Number of Sublocations does not match the number of groups.')
    end
end

%  get common axis limits
naxis = [floor(min(x(:))) ceil(max(x(:))) 0 n+1];

%  make room for ylabels
pos = get(gcf,'DefaultAxesPosition');
oldPos = pos;
shift = 1.3;
pos(1) = shift*pos(1);
pos(3) = pos(3)-(shift-1)*oldPos(1);
set(gcf,'DefaultAxesPosition',pos)

%  make the subplots
%  make selective labels and tick marks

for ii = 1:G
   subplot(nr,nc,p(ii))
   dotchart(x(:,ii),laby,'a')
   axis(naxis)
   title((subtitle(ii)))
   if rem(p(ii),nc)~=1
       % Not in the first column, then get rid of the y labels.
      set(gca,'YTickLabel',[])
   end
   if p(ii) <= (nr-1)*nc
       % If not the last row. 
       set(gca,'XTickLabel',[])
   end
   %  make plots slightly bigger than default
   pos = get(gca,'Position');
   pos(3) = 1.15*pos(3);
   pos(4) = 1.10*pos(4);
   pos(2) = 0.95*pos(2);
   set(gca,'Position',pos)
   set(gca,'FontSize',8)
end
% hx = xlabel(labx);
% 
% set(hx, 'Units', 'Normalized',...
%     'Position', [0.5, -0.05, 0]);
% mtit(labx)
toptitle(labx)


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

ht = text(offset(1),offset(2),string,'units','normalized',...
     'horizontalalignment','center','verticalalignment','middle');
 
%  keyboard

% Make the figure big enough so that when printed the
% toptitle is not cut off nor overlaps a subplot title.
h = findobj(gcf,'type','axes');
set(h,'units','points');
set(gcf,'units','points')
figpos = get(gcf,'position');
set(gcf,'position',figpos + [0 0 0 25])
set(gcf,'units','pixels');
% May 2017 - added the following text so the 'title'
% would appear as a label at the bottom of the figure.
% The previous funciton had the title overlapping the plots.
ht.Position = [-0.6718 -0.0753 0];
set(h,'units','normalized');


