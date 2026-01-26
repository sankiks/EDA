function dotchart(x,cases,varargin)
%   DOTCHART   Create a dot chart
%
%   Basic syntax:
%       DOTCHART(X,'CASES')
%   Creates a dot chart as described in Cleveland, 1984. 
%   X contains the data values. 'CASES' is a cell array of strings or a
%   string matrix containing the labels. If this is not given, then a
%   default set of names will be used. If no other flags are given, then
%   the default is to plot lines just to the dots.
%
%   The following capabilities are implemented:
%
%   1. Dot chart without lines: DOTCHART(...,'NL')
%   2. Dot chart with lines extending to end: DOTCHART(...,'ALL')
%   3. Dot chart with symmetric error bars: DOTCHART(...,'ERR',E). E is a
%   vector of error values.
%   4. Dot chart with scale break: DOTCHART(...,'BRK',I). I is the INDEX of
%   the start of the break - only one allowed.
%   5. Add cumulative distribution information to right axis:
%   DOTCHART(...,'CD')
%   NOTE: it is sufficient on the string arguments (other than the labels)
%   to just have the first letter.
%
%   EXAMPLES


% Reference:
% 'Graphical methods for data presentation: Full scale breaks, dot charts
% and multibased logging' The American Statistician, Vol 38, No 4, 1984, pp
% 270 - 280.

x = x(:);
n = length(x);
% Get the labels made up if necessary.
if nargin == 1
    % Then names were not given.
    cases = cell(1,n);
    for i = 1:n
        cases{i} = ['X_' int2str(i)];
    end
elseif nargin == 3 & isempty(cases)
    % Then names were not given, either. 
    cases = cell(1,n);
    for i = 1:n
        cases{i} = ['X_' int2str(i)];
    end
end
% Get the right flags out of the varargin array.
ks = 0;
kd = 0;
strflag = [];
numflag = [];
for i = 1:length(varargin)
    if ischar(varargin{i})
        % Then it is one of the string flags.
        ks = ks + 1;
        strflag{ks} = varargin{i};
    elseif isnumeric(varargin{i})
        % Then it is numeric.
        kd = kd + 1;
        numflag{kd} = varargin{i};
    end
end

if isempty(strmatch('a',strflag)) & isempty(strmatch('n',strflag))
    % Set it to default - lines to dots.
    dotline = 1;
else 
    dotline = 0;
end
strflag = lower(strflag);

% Now get the numeric information.
if ~isempty(numflag)
    for i = 1:length(numflag)
        if length(numflag{i}) == 1
            % Then it must be the break index.
            brki = numflag{i};
        elseif length(numflag{i}) == n
            % Then it must be error bar information.
            errs = numflag{i};
        else
            error('Incorrect numeric input')
        end
    end
end

xs = x;

% sort the data, just in case.
% [xs,ind] = sort(x);
% cases = cases(ind);
% if ~isempty(strmatch('e',strflag))
%     % Resort the errors, too.
%     errs = errs(ind);
% end
% Create the plot.

if strmatch('b',strflag)
    % Then do with scale break.
    % First get the amount in each part - based on the number of points.
    % The following is the position, where the units are normalized -
    % default.
    pos = get(gca,'pos');
    delete(gca);
    % Get the percentage of the axes real estate for the left set.
    nL = length(1:(brki-1));
    LperH = nL/n;
    postmp = pos;
    % Left axes starts in same place, but with different width.
    postmp(3) = pos(3)*LperH-0.01;
    Hax1 = axes('pos',postmp);
    % Right axes starts 
    postmp(1) = pos(1) + 0.01 + postmp(3);
    postmp(3) = pos(3)*(1-LperH);
    Hax2 = axes('pos',postmp);
    % Now call this function with the required axes handles.
    if ~isempty(strmatch('e',strflag))
        error('Cannot do the plot with error bars and the break.')
    end
    if strmatch('a',strflag)
        axes(Hax1)
        inds = 1:(brki-1);
        plot(xs(inds), inds, 'ko')
        % Now plot the rest of them.
        hold on
        amin = .95*xs(1); amax = 1.05*xs(inds(end));
        plot(repmat([amin;amax],1,n),repmat(1:n,2,1),':k')
        hold off
        setax(n,cases)
        axis([amin amax 0 n+1])
        set(gca,'ticklength',[0 0])
        % Now do the second axis
        inds = brki:n;
        axes(Hax2)
        amin = 0.85*xs(inds(1)); amax = 1.05*xs(end);
        plot(xs(inds),inds,'ko')
        hold on
        axis([amin amax 0 n+1])
        plot(repmat([amin;amax],1,n),repmat(1:n,2,1),'k:')
        set(gca,'YTick',1:n,...
            'YTickLabel','',...
            'ticklength',[0 0],...
            'fontsize',8)
        hold off
        return
    end
    if strmatch('n',strflag)
        axes(Hax1)
        inds = 1:(brki-1);
        plot(xs(inds), inds, 'ko')
        % Now plot the rest of them.
        hold on
        amin = .95*xs(1); amax = 1.05*xs(inds(end));
        hold off
        setax(n,cases)
        axis([amin amax 0 n+1])
        set(gca,'ticklength',[0 0])
        % Now do the second axis
        inds = brki:n;
        axes(Hax2)
        amin = 0.85*xs(inds(1)); amax = 1.05*xs(end);
        plot(xs(inds),inds,'ko')
        hold on
        axis([amin amax 0 n+1])
        set(gca,'YTick',1:n,...
            'YTickLabel','',...
            'ticklength',[0 0],...
            'fontsize',8)
        hold off
        return
        
    end

    if dotline
        axes(Hax1)
        inds = 1:(brki-1);
        plot(xs(inds), inds, 'ko')
        % Now plot the rest of them.
        hold on
        amin = .95*xs(1); amax = 1.05*xs(inds(end));
        % Plot lines to dots.
        plot([amin*ones(1,length(inds));xs(inds)'],repmat(1:length(inds),2,1),':k')
        % The following plots the upper ones.
        plot(repmat([amin;amax],1,n-brki+1),repmat(brki:n,2,1),'k:')
        hold off
        setax(n,cases)
        axis([amin amax 0 n+1])
        set(gca,'ticklength',[0 0])
        % Now do the second axis
        inds = brki:n;
        axes(Hax2)
        amin = 0.85*xs(inds(1)); amax = 1.05*xs(end);
        plot(xs(inds),inds,'ko')
        hold on
        axis([amin amax 0 n+1])
        plot([amin*ones(1,n-brki+1);xs(inds)'],repmat(brki:n,2,1),':k')
%         plot(repmat([amin;amax],1,n-brki+1),repmat(brki:n,2,1),'k:')
        set(gca,'YTick',1:n,...
            'YTickLabel','',...
            'ticklength',[0 0],...
            'fontsize',8)
        hold off
        return    
    end
end
if strmatch('e',strflag) & strmatch('n',strflag)
    % Plot with the error bars and no lines.
    plot(xs, 1:n, 'o'), hold on
    plot([xs(:)'-errs(:)' ; xs(:)'+errs(:)'], repmat(1:n,2,1),'.-k')
    hold off
    setax(n,cases)
    if strmatch('c',strflag)
        addcum(gca,n,cases)
    end
    return
end
if strmatch('e',strflag) & dotline
    % Plot with the error bars and lines to the dots.
    plot(xs, 1:n, 'ko')
    hold on
    % Use zero here as baseline, since going to dot should have meaningful
    % zero baseline per Cleveland. Actually some other baseline COULD be
    % used, but not implemented here.
    plot([zeros(1,n);xs'],repmat(1:n,2,1),':k')
    plot([xs(:)' - errs(:)' ; xs(:)' + errs(:)'], repmat(1:n,2,1),'.-k')
    hold off
    setax(n,cases)
    if strmatch('c',strflag)
        addcum(gca,n,cases)
    end
    return
end
if strmatch('n',strflag)
    plot(xs, 1:n, 'o')
    setax(n,cases)
    if strmatch('c',strflag)
        addcum(gca,n,cases)
    end
    return
end
if strmatch('a',strflag)
    % Lines extend to end.
    plot(xs, 1:n, 'ko')
    hold on
    amin = .99*min(xs); amax = 1.01*max(xs);
    plot(repmat([amin;amax],1,n),repmat(1:n,2,1),':k')
    hold off
    setax(n,cases)
    if strmatch('c',strflag)
        addcum(gca,n,cases)
    end
    return
end
if dotline
    % Lines extend to dot.
    plot(xs, 1:n, 'ko')
    hold on
    plot([zeros(1,n);xs'],repmat(1:n,2,1),':k')
    hold off
    setax(n,cases)
    if strmatch('c',strflag)
        addcum(gca,n,cases)
    end
    return
end

function addcum(hax1,n,cases)
% Then add the cumulative dist to the right axis.
%     hax1 = gca;
axes(hax1)
ax = axis;
axis([ax(1), ax(2), 0 n+1])
set(gca,'YTick',1:n,...
    'YTickLabel',cases,...
    'tickDir','out',...
    'fontsize',8)
pos = get(gca,'position');
% Create second axes in same place.
hax2 = axes('position',pos);
set(hax2,'YAxisLocation','right','color','none', ...
    'xgrid','off','ygrid','off','box','off','xtick',[]);
% get the cdf for scale on right.
cdfn = ((1:n) - 0.5)/n;
for i = 1:length(cdfn)
    yL{i} = num2str(cdfn(i),'%0.2f');
end
% Set limits the same.
axis([ax(1), ax(2), 0 n+1])
set(hax2,'YTick',1:n,...
    'YTickLabel',yL,...
    'tickDir','out',...
    'fontsize',8)


function setax(n,cases)
% The following can be used for above plots.
ax = axis;
axis([ax(1), ax(2), 0 n+1])
set(gca,'YTick',1:n,...
    'YTickLabel',cases,...
    'tickDir','out',...
    'fontsize',8)



