function hidimgui(action)

% HIDIMGUI Exploratory Data Analysis GUI
%   This GUI allows one to perform EDA for the
%   isomap results. It is really set up for 16
%   topics for the dissertation. So it is not for
%   general use. This does the Andrews curves and
%   parallel coordinates. It must be used in 
%   conjunction with the ISOMAPEDA GUI.

% Check to see that the isomapeda gui is running.

Hisofig = findobj('Name','Isomap Dimensionality Reduction EDA');
% Note that this should be the handle to the figure with the data.

if isempty(Hisofig)
    errordlg('You must have the ISOMAPEDA GUI running to load the data for plotting.','GUI Error')
    return
end

if nargin < 1
   action = 'initialize';
end

if strcmp(action, 'initialize')
   h.fig = figure(...
      'Name','Hi-Dimensional Plots - Isomap',...
      'NumberTitle','off',...
      'menubar','none',...
      'units','normalized',...
      'Position',[0.05    0.05    0.45    0.2],...
      'tag','hidimgui');
       
  uicontrol('style','pushbutton',...
       'units','normalized',...
       'position',[0.40, 0.02, 0.17, 0.17],...
       'fontunits','normalized',...
       'string','Close GUI',...
       'fontweight','bold',...
       'Callback','close gcf');
   
   uicontrol('style','pushbutton',...
       'units','normalized',...
       'position',[0.8, 0.32, 0.17, 0.17],...
       'fontunits','normalized',...
       'string','Stop Tour',...
       'fontweight','bold',...
       'tooltipstring','Push this to stop the tour',...
       'Callback','h=get(gcbf,''userdata'');h.stopflag = 1;set(gcbf,''userdata'',h)');
   
   uicontrol('style','pushbutton',...
       'units','normalized',...
       'position',[0.8, 0.65, 0.17, 0.17],...
       'fontunits','normalized',...
       'string','Stop Tour',...
       'fontweight','bold',...
       'Tooltipstring','Push this to stop the tour',...
       'Callback','h=get(gcbf,''userdata'');h.stopflag = 1;set(gcbf,''userdata'',h)');

   uicontrol('Style','pushbutton',...
       'units','normalized',...
       'fontunits','normalized',...
       'string','Do Plot',...
       'fontweight','bold',...
       'position',[0.6, 0.32, 0.17, 0.17],...
       'CallBack','hidimgui(''doandrews'')',...
       'tooltipstring','Push button to display Andrews Curves plot or to start the tour.')
   
   uicontrol('Style','pushbutton',...
       'units','normalized',...
       'fontunits','normalized',...
       'string','Do Plot',...
       'fontweight','bold',...
       'position',[0.6, 0.65, 0.17, 0.17],...
       'CallBack','hidimgui(''doparallel'')',...
       'tooltipstring','Push button to display parallel coordinates plot or to start the tour.')

   h.popupandrews = uicontrol('style','popupmenu',...
       'units','normalized',...
       'position',[0.2 0.41 0.25 0.04],...
       'fontunits','normalized',...
       'string',{'Static - Single Plot','Static - Plot Matrix','Permutation Tour','Perm Tour - One class','Grand Tour'},...
       'tooltipstring','Use this to select the type of tour.',...
       'backgroundcolor','w');

   h.popupparallel = uicontrol('style','popupmenu',...
       'units','normalized',...
       'position',[0.2 0.77 0.25 0.04],...
       'fontunits','normalized',...
       'string',{'Static - Single Plot','Static - Plot Matrix','Permutation Tour','Perm Tour - One class','Grand Tour'},...
       'tooltipstring','Use this to select the type of tour.',...
       'backgroundcolor','w');
   
   h.editandrews = uicontrol('style','edit',...
       'units','normalized',...
       'position',[0.48 0.31 0.1 0.14],...
       'backgroundcolor','w',...
       'tooltipstring','These show the permutation number displayed in figure.',...
       'string','1');
   
   h.editpara = uicontrol('style','edit',...
       'units','normalized',...
       'position',[0.48 0.67 0.1 0.14],...
       'tooltipstring','These show the permutation number displayed in figure.',...
       'backgroundcolor','w',...
       'string','1');
   
   uicontrol('style','text',...
       'units','normalized',...
       'position',[0.48 0.87 0.1 0.1],...
       'fontunits','normalized',...
       'string','Step',...
       'fontweight','bold',...
       'horiz','center')

   uicontrol('style','text',...
       'units','normalized',...
       'position',[0.01 0.32 0.19 0.1],...
       'fontunits','normalized',...
       'string','Andrews Plot:',...
       'fontweight','bold',...
       'horiz','left')

   uicontrol('style','text',...
       'units','normalized',...
       'position',[0.01 0.7 0.19 0.1],...
       'fontunits','normalized',...
       'string','Parallel Plot:',...
       'fontweight','bold',...
       'horiz','left')
   
   h.stopflag = 0;
   
   % Save the data in the figure.
   set(h.fig,'userdata',h)
   
elseif strcmp(action,'doandrews')
    'Static - Single Plot','Static - Plot Matrix','Permutation Tour','Perm Tour - One class','Grand Tour'
    % Recall that when this function is called, we load up
    % the data structure from the isomapeda gui. This has
    % the color information and the data.
    % This is the structure stored in the isomapeda gui.
    % This has all of the data, color information, class labels etc.
    hiso = get(Hisofig,'userdata');
    %First get the handle information.
    Hhidimfig = findobj('tag','hidimgui');
    hhidim = get(Hhidimfig,'userdata');
    ndims = get(hiso.popup,'value') + 1;
    X = hiso.data{ndims};
    X = X';
    % Get the user's choice.
    flag = get(hhidim.popupandrews,'value');
    if flag == 1
        % Then it is the static plot
        Hfig = figure('renderer','zbuffer');
        staticandrews(X,hiso,hhidim,Hfig);
    elseif flag == 3
        % This is the permutation.
        % only valid for dims up to 5.
        % Otherwise it is too much. Put in a check
        if ndims >= 6
            errordlg('Too many dimensions. Only good for 1 - 5 dimensions','Plot Error')
            return
        end
        permtourandrews(X,hiso,hhidim,ndims);
    elseif flag == 5
        % Do the grand tour - placeholder.
        msgbox('Grand Tour is Coming Soon','Plot Message')
    elseif flag == 2
        % Do a plotmatrix andrews curves plot - one per plot area.
        Hfig = figure('renderer','zbuffer','units','normalized','position',[0.05 0.05 .9 .9]);
        plotmatrixandr(X,hiso,hhidim,ndims,Hfig);
    elseif flag ==4
        % Do the single class permutation tour.
        % This code added - May 2003 to do a single class permutation tour.
        % do a permutation grand tour.
        % only valied for dims up to 5.
        % This does a single class rather than all classs together.
        if ndims >= 6
            errordlg('Too many dimensions. Only good for 1 - 5 dimensions','Plot Error')
            return
        end
        % set up something to gather the information about what class to display.
        prompt  = {'Enter Class Number to Display:'};
        titl   = 'Input for Single Class Permutation Tour';
        lines= 1;
        def     = {'4'};
        answer  = inputdlg(prompt,titl,lines,def);
        if ~isempty(answer)
            answr = str2num(answer{1});
        else
            answr = 4;
        end
        classes = unique(hiso.classlabs);
        ind = find(classes == answr);
        if isempty(ind)
            errordlg('Class number not found','Invalid Class Number');
            return
        else
            permtourandrews(X,hiso,hhidim,ndims,answr);
        end

    end

elseif strcmp(action,'doparallel')
    
    % Recall that when this function is called, we load up
    % the data structure from the isomapeda gui. This has
    % the color information and the data.
    % This is the structure stored in the isomapeda gui.
    hiso = get(Hisofig,'userdata');
    %First get the handle information.
    Hhidimfig = findobj('tag','hidimgui');
    hhidim = get(Hhidimfig,'userdata');
    ndims = get(hiso.popup,'value') + 1;
    X = hiso.data{ndims};
    X = X';
    % Get the user's choice.
    flag = get(hhidim.popupparallel,'value');
    if flag == 1
        % Then it is the static plot
        Hfig = figure('renderer','zbuffer');
        staticparallel(X,hiso,hhidim,Hfig);
    elseif flag == 3
        % This is the permutation grand tour.
        % only valid for dims up to 5.
        % Otherwise it is too much. Put in a check
        if ndims >= 6
            errordlg('Too many dimensions. Only good for 1 - 5 dimensions','Plot Error')
            return
        end
        permtourparallel(X,hiso,hhidim,ndims);
    elseif flag == 5
        % Do the grand tour - placeholder.
        msgbox('Grand Tour is Coming Soon','Plot Message')
    elseif flag == 2
        % Do a static plotmatrix of parallel coordinate curves - one per class
        Hfig = figure('renderer','zbuffer','units','normalized','position',[0.05 0.05 .9 .9]);
        plotmatrixpara(X,hiso,hhidim,ndims,Hfig);
    elseif flag == 4
        % This code added - August 8, 2002 to do a single class permutation tour.
        % do a permutation grand tour.
        % only valied for dims up to 5.
        % This does a single class rather than all classs together.
        if ndims >= 6
            errordlg('Too many dimensions. Only good for 1 - 5 dimensions','Plot Error')
            return
        end
        % set up something to gather the information about what class to display.
        prompt  = {'Enter Class Number to Display:'};
        titl   = 'Input for Single Class Permutation Tour';
        lines= 1;
        def     = {'4'};
        answer  = inputdlg(prompt,titl,lines,def);
        if ~isempty(answer)
            answr = str2num(answer{1});
        else
            answr = 4;
        end
        classes = unique(hiso.classlabs);
        ind = find(classes == answr);
        if isempty(ind)
            errordlg('Class number not found','Invalid Class Number');
            return
        end
        permtourparallel(X,hiso,hhidim,ndims,answr);
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       PLOTMATRIXANDR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
function plotmatrixandr(X,hiso,hhidim,ndims,Hfig)
if ~isempty(hiso.data)
    % then do the curves
    map = hiso.map;
    % Get the class labels for all points.
    classes = unique(hiso.classlabs);
    nclass = length(classes);
    classlabs = hiso.classlabs;
    % Get the data.
    ndims = get(hiso.popup,'value') + 1;
    % access the figure
    figure(Hfig)
    bigax = axes;
    set(bigax,'Visible','off','color','none')
    % plot the rest of them
    for cc = 1:nclass
        cls = classes(cc);
        inds = find(classlabs==cls);
        subplot(4,4,cc)
        andrews(X(inds,:),'-',map(cc,:));
        set(gca,'color','k','xticklabel','','yticklabel','')
        xlabel(''),ylabel('')
        axs = axis;
        axis([-3 3 axs(3) axs(4)])
        if isnumeric(classes)
            title(['Class ', int2str(classes(cc))],'color','w')
        elseif iscell(classes)
            title(['Class ',classes{cc}],'color','w')
        end
    end
    % Put a title around the whole thing.
    uicontrol('style','text',...
        'units','normalized',...
        'fontsize',10,...
        'position',[0.35 0.97 0.3 0.03],...
        'string',['Andrews Curves for ',int2str(ndims),' Dimensions'])
else
    errordlg('You must load some data first.','Plot Data Error')
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       PLOTMATRIXPARA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotmatrixpara(X,hiso,hhidim,ndims,Hfig);
if ~isempty(hiso.data)
    % then do the curves
    map = hiso.map;
    % Get the class labels for all points.
    classes = unique(hiso.classlabs);
    nclass = length(classes);
    classlabs = hiso.classlabs;
    % Get the data.
    ndims = get(hiso.popup,'value') + 1;

    [n,p]=size(X);
    % map all values 0nto the interval 0 to 1
    % lines will extend over the range 0 to 1
    md = min(X(:)); % find the min of all the data
    rng = range(X(:));  %find the range of the data
    xn = (X-md)/rng;
    ypos = linspace(0,1,p);
    xpos = [0 1];
    % Get the data.
    ndims = get(hiso.popup,'value') + 1;
    for cc = 1:nclass
    % plot the rest of them
        cls = classes(cc);
        inds = find(classlabs==cls);
        % Has to be the scaled data.   
        subplot(4,4,cc)
        axis equal
        axis off
        k=p;
        % THe following gets the axis lines.
        for i=1:p            
            % Note: 4/11/02 changed the following color to 'w' from 'k'
            line(xpos,[ypos(i) ypos(i)],'color','w')
            k=k-1;
        end
        parallel(xn(inds,:),map(cc,:),ypos);
        % Note: 4/11/02 changed the following color to 'w' from 'k'
        line(xpos,[0 + .004 0+.004],'color','w')
        line(xpos,[1-.004 1-.004],'color','w')
%         title(['Class ', strgclass{cc}],'color','w')
        if isnumeric(classes)
            title(['Class ', int2str(classes(cc))],'color','w')
        elseif iscell(classes)
            title(['Class ',classes{cc}],'color','w')
        end
    end
    
    % 4/11/02 changed figure color
    set(gcf,'color','k')

    % Put a title around the whole thing.
    uicontrol('style','text',...
        'units','normalized',...
        'fontsize',10,...
        'position',[0.35 0.97 0.3 0.03],...
        'string',['Parallel Coordinates for ',int2str(ndims),' Dimensions'])
else
    errordlg('You must load some data first.','Plot Data Error')
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       PERMTOURPARALLEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function permtourparallel(X,hiso,hhidim,p,classnum)

% Get the permutations - each row corresponds to a different one.
P = perms(1:p);
[n,pp] = size(P);
Htmp = findobj('tag','figparatour');
h = get(hhidim.fig,'userdata');
hedit = hhidim.editpara;

if isempty(Htmp)
    % Then this is a new tour.
    Hfig = figure('tag','figparatour','renderer','painters','DoubleBuffer','on','backingstore','off');
    step = 1;
    h.stopflag = 0;
    set(hhidim.fig,'userdata',h)
else 
    % set the current figure to the parallel tour one.
    Hfig = Htmp;
    figure(Hfig)
    h.stopflag = 0;
    % Get the current step.
    step = str2num(get(hedit,'string'));
    set(hhidim.fig,'userdata',h)
end
   
if nargin == 4
    % Do the all class tour
    % Loop through all of the permutations.
    for i = step:n
        % permute the columns by the row of the permutation matrix
        xp = X(:,P(i,:));
        set(hedit,'string',int2str(i))
        h = get(hhidim.fig,'userdata');
        if h.stopflag ~= 1
            cla
            staticparallel(xp,hiso,hhidim,Hfig);
            % Change the step in the edit box.
            pause(1)
        else
            break
            return
        end
    end
    
else
    % Do the single class tour
    % Loop through all of the permutations.
        for i = step:n
        % permute the columns by the row of the permutation matrix
        xp = X(:,P(i,:));
        set(hedit,'string',int2str(i))
        h = get(hhidim.fig,'userdata');
        if h.stopflag ~= 1
            cla
            staticparallel(xp,hiso,hhidim,Hfig,classnum);
            % Change the step in the edit box.
            pause(1)
        else
            break
            return
        end
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       PERMTOURANDREWS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function permtourandrews(X,hiso,hhidim,p,classnum)

% Get the permutations - each row corresponds to a different one.
P = perms(1:p);
[n,pp] = size(P);
Htmp = findobj('tag','figandrtour');
h = get(hhidim.fig,'userdata');
hedit = hhidim.editandrews;

if isempty(Htmp)
    % Then this is a new tour.
    Hfig = figure('tag','figandrtour','renderer','zbuffer');
    step = 1;
    h.stopflag = 0;
    set(hhidim.fig,'userdata',h)
else 
    % set the current figure to the permutation tour one.
    Hfig = Htmp;
    figure(Hfig)
    h.stopflag = 0;
    % Get the current step.
    step = str2num(get(hedit,'string'));
    set(hhidim.fig,'userdata',h)
end
   
if nargin == 4
    % Loop through all of the permutations.
    for i = step:n
        % permute the columns by the row of the permutation matrix
        xp = X(:,P(i,:));
        set(hedit,'string',int2str(i))
        h = get(hhidim.fig,'userdata');
        if h.stopflag ~= 1
            cla
            staticandrews(xp,hiso,hhidim,Hfig)
            % Change the step in the edit box.
            pause(1)
        else
            break
            return
        end
    end
else 
    % do the single class tour
    % Loop through all of the permutations.
    ind = find(hiso.classlabs == classnum);
    X = X(ind,:);   % first get those points that belong to the class of interest
    for i = step:n
        % permute the columns by the row of the permutation matrix
        xp = X(:,P(i,:));
        set(hedit,'string',int2str(i))
        h = get(hhidim.fig,'userdata');
        if h.stopflag ~= 1
            cla
            staticandrews(xp,hiso,hhidim,Hfig,classnum);
            % Change the step in the edit box.
            pause(1)
        else
            break
            return
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       STATICPARALLEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function staticparallel(X,hiso,hhidim,Hfig,classnum)

if ~isempty(hiso.data)
    % then do the curves
    % First get the handle information.
    Hhidimfig = findobj('tag','hidimgui');
    hhidim = get(Hhidimfig,'userdata');
    map = hiso.map;
    % Get the class labels for all points.
    classes = unique(hiso.classlabs);
    nclass = length(classes);
    classlabs = hiso.classlabs;
    % Get the data.
    ndims = get(hiso.popup,'value') + 1;

    % Get the data.
    ndims = get(hiso.popup,'value') + 1;
    hold on
    % The following code was taken from the function.
    % This should be the part to set up the figure.
    [n,p]=size(X);
    %figure('units','norm')
    Hax = axes('units','norm');        
    axis equal
    axis([-0.1 1.05 0 1])
    axis off
    % map all values 0nto the interval 0 to 1
    % lines will extend over the range 0 to 1
    md = min(X(:)); % find the min of all the data
    rng = range(X(:));  %find the range of the data
    xn = (X-md)/rng;
    % set up the lines
    ypos = linspace(0, 1,p);
    xpos = [0 1];
    k=p;
    for i=1:p            
        line(xpos,[ypos(i) ypos(i)],'color','k')
        text(-0.05,ypos(i), ['x' num2str(k)] )
        k=k-1;
    end
    % end of code extracted from function.
    line(xpos,[1-.004 1-.004],'color','k')
    
    if nargin == 4
        % plot the rest of them
        for cc = 1:nclass
            cls = classes(cc);
            inds = find(classlabs==cls);
            % Has to be the scaled data.   
            parallel(xn(inds,:),map(cc,:),ypos);
        end
        
    else
        % plot the single class parallel coordinates.
        inds = find(classlabs == classnum);
        ccnum = find(classes == classnum);
        parallel(xn(inds,:),map(ccnum,:),ypos);
    end
            
    hold off
    title(['Parallel Coordinates for ',int2str(ndims),' Dimensions'])
    haxes = findobj(Hfig,'type','axes');
    set(haxes,'visible','off')
    
else
    errordlg('You must load some data first.','Plot Data Error')
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       STATICANDREWS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function staticandrews(X,hiso,hhidim,Hfig,classnum)

if ~isempty(hiso.data) & nargin == 4
    % then do the curves
    % Get the unique classes.
    map = hiso.map;
    % then do the full plot - all classes
    % Get the class labels for all points.
    classes = unique(hiso.classlabs);
    nclass = length(classes);
    classlabs = hiso.classlabs;
    % Get the data.
    ndims = get(hiso.popup,'value') + 1;
    % access the figure
    figure(Hfig)
    % Here is where we add the different colors for the classes.
    % Get the first one started.
    cls = classes(1);
    inds = find(classlabs==cls);
    andrews(X(inds,:),'-',map(1,:));
    hold on    
    % plot the rest of them
    for cc = 2:nclass
        cls = classes(cc);
        inds = find(classlabs==cls);
        andrews(X(inds,:),'-',map(cc,:));
    end
    hold off
    set(gca,'color','k')
    axs = axis;
    axis([-3 3 axs(3) axs(4)])
    title(['Andrews Curves for ',int2str(ndims),' Dimensions'])
elseif ~isempty(hiso.data) & nargin == 5
    % then do one class tour
    map = hiso.map;
    classes = unique(hiso.classlabs);
    ind = find(classes == classnum);
    % Get the data.
    ndims = get(hiso.popup,'value') + 1;
    % access the figure
    figure(Hfig)
    andrews(X,'-',map(ind,:));
    set(gca,'color','k')
    axs = axis;
    axis([-3 3 axs(3) axs(4)])
    title(['Andrews Curves for ',int2str(ndims),' Dimensions'])
else
    errordlg('You must load some data first.','Plot Data Error')
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       PARALLEL COORDINATES PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function parallel(x,cl,ypos)

[n,p] = size(x);
for i=1:n
   line(x(i,:),fliplr(ypos),'color',cl)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       ANDREWS CURVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function andrews(data, Ls,colr)

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
xlabel('Theta')
ylabel('Andrews Function')
