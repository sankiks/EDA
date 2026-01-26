function scattergui(varargin)
%   SCATTERGUI  Allows interactive identification of points in scatterplot
%
%   SCATTERGUI(X,NAMES) The input argument is the n x p data matrix X. The
%   second input argument is a cell array of strings containing the n case
%   labels or the n class labels. Alternatively, NAMES can be the numeric 
%   class label.
%
%   Right click in the plot to obtain a menu of highlight options. 
%
%   Use the usual Windows keys to select multiple cases and classes:
%   Ctrl-click for multiple choices, Shift-click for range of choices.
%
%   Default color/symbol is blue dots. The highlighted color/symbol will be
%   red/Xs.
%
%   To interactively delete cases, select option from contextmenu and
%   create bounding box around desired points.

warning off MATLAB:deblank:NonStringInput
if nargin==2
    x = varargin{1};
    [n,p] = size(x);
    arg2 = varargin{2};
    if isnumeric(arg2)
        % Then class labels.
        H.classlab = arg2;
        H.caselab = [];
    end
    if length(unique(arg2)) < n
        % Then it must be class labels.
        H.classlab = arg2;
        H.caselab = [];
    else
        H.caselab = arg2;
        H.classlab = [];
    end
    % Initial call of function.
    flag = 'init';
elseif nargin==1
    flag = varargin{1};
end

if strcmp(flag,'init')
    % init the gui.
    H.data = x;
    % Plot the data in a scatterplot - no highlights.
    H.line = plot(x(:,1),x(:,2),'b.');
    H.ax = gca;
    H.fig = gcf;
    set(gcf,'name','ScatterGUI')
    H.uim = uicontextmenu;
    set(H.ax,'uicontextmenu',H.uim);
    H.selclass = uimenu(H.uim,'Label','Select Class',...
        'CallBack','scattergui(''classlist'')');
    H.delclass = uimenu(H.uim,'Label','Delete Class',...
        'CallBack','scattergui(''delclass'')');
    H.selcase = uimenu(H.uim,'Label','Select Case',...
        'CallBack','scattergui(''caselist'')',...
        'Separator','on');
    H.delcase = uimenu(H.uim,'Label','Delete Case',...
        'CallBack','scattergui(''delcase'')');
    H.reser = uimenu(H.uim,'Label','Reset',...
        'CallBack','scattergui(''reset'')',...
        'Separator','on');
    % Plot the data in a scatterplot - no highlights.
    H.line = plot(x(:,1),x(:,2),'b.');
    % Save the user data.
    set(gcf,'UserData',H)
    
elseif strcmp(flag,'delcase')
    % Get the user input from the list box and delete selected class.
    tmpH = findobj('name','ScatterGUI');
    H = get(tmpH,'userdata');
    x = H.data;
    k = waitforbuttonpress;
    point1 = get(gca,'CurrentPoint');    % button down detected
    finalRect = rbbox;                   % return figure units
    point2 = get(gca,'CurrentPoint');    % button up detected
    point1 = point1(1,1:2);              % extract x and y
    point2 = point2(1,1:2);
    p1 = min(point1,point2);             % calculate locations
    offset = abs(point1-point2);         % and dimensions
    X = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
    Y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
    ind = find(inpolygon(x(:,1),x(:,2),X,Y));
    x(ind,:) = [];
    plot(x(:,1),x(:,2),'b.')
    
elseif strcmp(flag,'delclass')
    % Get the user input from the list box and delete selected class.
    tmpH = findobj('name','ScatterGUI');
    H = get(tmpH,'userdata');
    if ~isempty(H.classlab)
        x = H.data;
        [n,p] = size(x);
        axes(H.ax)
        clabs = unique(H.classlab);
        [select,v] = listdlg('PromptString','Select class to delete:',...
            'SelectionMode','Multiple',...
            'ListString',clabs,...
            'Name','Class Selection');
        % replot the selected points using different colors.
        if v
            if iscell(clabs)
                indsel = [];
                for i = 1:length(select)
                    % Get the selected class.
                    s = clabs{select(i)};
                    indsel = [indsel; strmatch(s,H.classlab,'exact')];
                end
                inddif = setdiff(1:n,indsel);
            end
            if isnumeric(clabs)
                indsel = [];
                for i = 1:length(select)
                    s = clabs(select(i));
                    indsel = [indsel; find(H.classlab==s)];
                end
                inddif = setdiff(1:n,indsel);
            end
            H.line = plot(x(inddif,1),x(inddif,2),'b.');
        end
    else
        error('Did not use class labels as input argument.')
    end
    set(H.fig,'userdata',H)
    
elseif strcmp(flag,'caselist')
    % Create a list box with cases.
    tmpH = findobj('name','ScatterGUI');
    H = get(tmpH,'userdata');
    if ~isempty(H.caselab)
        [select,v] = listdlg('PromptString','Select cases to highlight:',...
            'SelectionMode','Multiple',...
            'ListString',H.caselab,...
            'Name','Case Selection');
        % replot the selected points using different colors.
        x = H.data;
        [n,p] = size(x);
        axes(H.ax)
        if v ~=0
            inds = setdiff(1:n,select);
            H.line=plot(x(select,1),x(select,2),'rx',x(inds,1),x(inds,2),'b.');
        end
    else
        error('Did not use case labels as input argument.')
    end
    set(H.fig,'userdata',H)
elseif strcmp(flag,'classlist')
    % Create a list box with class labels.
    tmpH = findobj('name','ScatterGUI');
    H = get(tmpH,'userdata');
    if ~isempty(H.classlab)
        x = H.data;
        [n,p] = size(x);
        axes(H.ax)
        clabs = unique(H.classlab);
        [select,v] = listdlg('PromptString','Select class to highlight:',...
            'SelectionMode','Multiple',...
            'ListString',clabs,...
            'Name','Class Selection');
        % replot the selected points using different colors.
        if v
            if iscell(clabs)
                indsel = [];
                for i = 1:length(select)
                    % Get the selected class.
                    s = clabs{select(i)};
                    indsel = [indsel; strmatch(s,H.classlab,'exact')];
                end
                inddif = setdiff(1:n,indsel);
            end
            if isnumeric(clabs)
                indsel = [];
                for i = 1:length(select)
                    s = clabs(select(i));
                    indsel = [indsel; find(H.classlab==s)];
                end
                inddif = setdiff(1:n,indsel);
            end
            H.line = plot(x(indsel,1),x(indsel,2),'rx',x(inddif,1),x(inddif,2),'b.');
        end
    else
        error('Did not use class labels as input argument.')
    end
    set(H.fig,'userdata',H)
elseif strcmp(flag,'reset')
    % Reset to original points.
    H = get(gcf,'userdata');
    x = H.data;
    axes(H.ax)
    plot(x(:,1),x(:,2),'b.')
    
end

