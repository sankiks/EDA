function isomapeda(action)

% ISOMAPEDA Exploratory Data Analysis GUI
%   This GUI allows one to perform EDA for the
%   isomap results. 

% This was revised in May 2003 to make it more general. The user must now
% load up the class variables that are in an array. These can be strings or
% numeric. The classes come with some pre-defined colors, but they can be
% changed to any color. Up to 10 groups can be specified.

if nargin < 1
   action = 'initialize';
end

if strcmp(action, 'initialize')
   h.fig = figure(...
      'Name','Isomap Dimensionality Reduction EDA',...
      'NumberTitle','off',...
      'units','normalized',...
      'menubar','none',...
      'Position',[0.1    0.1    0.4    0.8],...
      'tag','isomapgui');
  
  uicontrol('style','frame',...
      'backgroundcolor','k',...
      'units','normalized',...
      'position',[0.02,0.30,0.3,0.68])
     
   uicontrol('style','text',...
       'units','normalized',...
       'position',[0.05, 0.94, 0.25, 0.036],...
       'Horiz','center',...
       'Fontweight','bold',...
       'fontunits','normalized',...
       'foregroundcolor','w',...
       'backgroundcolor','k',...
       'string','LEGEND');
   
   h.help = uicontrol('style','text',...
       'units','normalized',...
       'position',[0.03, 0.5, 0.25, 0.4],...
       'fontweight','bold',...
       'fontunits','normalized',...
       'Horiz','left',...
       'foregroundcolor','w',...
       'backgroundcolor','k',...
       'string','TO START: Follow the numbered steps below...         Press the ''HELP'' button for information...');
   
   uicontrol('style','pushbutton',...
       'units','normalized',...
       'position',[0.04, 0.32 0.25 0.05],...
       'string','Change Color...',...
       'fontweight','bold',...
       'Callback','isomapeda(''changeclasscol'')',...
       'tooltipstring','Use this button to change the color for a class');
   
    uicontrol('style','pushbutton',...
       'units','normalized',...
       'position',[0.79, 0.09 0.20 0.05],...
       'string','Help',...
       'fontweight','bold',...
       'foregroundcolor','k',...
       'Callback','isomapeda(''help'')',...
       'tooltipstring','Use this button to get more information.');

   h.steps(4) = uicontrol('style','pushbutton',...
       'units','normalized',...
       'fontunits','normalized',...
       'position',[0.02, 0.11, 0.25, 0.04],...
       'string','4. Load Labels...',...
       'fontweight','bold',...
       'Callback','isomapeda(''loadlabels'')',...
       'tooltipstring','Use this button to specify the file that contains class labels.');
   
   h.poplabs = uicontrol('style','popupmenu',...
       'units','normalized',...
       'position',[0.42, 0.07, 0.35, 0.03],...
       'fontunits','normalized',...
       'string','No labels',...
       'backgroundcolor','w',...
       'callback','isomapeda(''loadlabs'')',...
       'Tooltipstring','Choose the variable from this list.');
   
   h.steps(5) = uicontrol('style','text',...
       'units','normalized',...
       'position',[0.02 0.07, 0.4, 0.03],...
       'fontweight','bold',...
       'horiz','left',...
       'string','5. Choose the labels:');
   
   h.steps(6)= uicontrol('style','text',...
       'units','normalized',...
       'position',[0.02, 0.02, 0.4, 0.03],...
       'fontunits','normalized',...
       'horiz','left',...
       'fontweight','bold',...
       'string','6. Number of dimensions:');
   %        'position',[0.05, 0.09, 0.5, 0.03],...

  h.popup = uicontrol('style','popupmenu',...
       'units','normalized',...
       'position',[0.42,0.02, 0.35, 0.03],...
       'backgroundcolor','w',...
       'string','Load Data First',...
       'tooltipstring','Select the number of dimensions to display in plots');
   
   uicontrol('style','pushbutton',...
       'units','normalized',...
       'position',[0.79, 0.02, 0.20, 0.05],...
       'fontunits','normalized',...
       'string','Close',...
       'fontweight','bold',...
       'Callback','close gcf');
   
   h.steps(1) = uicontrol('style','pushbutton',...
       'units','normalized',...
       'position',[0.02 0.25, 0.25, 0.04],...
       'fontunits','normalized',...
       'string','1. Load File...',...
       'fontweight','bold',...
       'horiz','left',...
       'Callback','isomapeda(''loaddata'')',...
       'foregroundcolor','r',...
       'tooltipstring','Use this button to specify the file.');
   %        'position',[0.01, 0.02, 0.22, 0.05],...

   uicontrol('style','pushbutton',...
       'units','normalized',...
       'position',[0.79, 0.16 0.20 0.05],...
       'fontunits','normalized',...
       'string','More Plots...',...
       'fontweight','bold',...
       'Callback','hidimgui',...
       'tooltipstring','Use this button to run GUI for Andrews curves and parallel coordinates.');
   
   h.steps(2) = uicontrol('style','text',...
       'units','normalized',...
       'position',[0.02 0.21, 0.5, 0.03],...
       'fontweight','bold',...
       'horiz','left',...
       'string','2. Choose the data:');

   h.popupvar = uicontrol('style','popupmenu',...
       'units','normalized',...
       'position',[0.42, 0.21, 0.35, 0.03],...
       'backgroundcolor','w',...  
       'string','You must load a file first',...
       'Callback','isomapeda(''loadvar'')');
               
   h.popupres2 = uicontrol('style','popupmenu',...
       'units','normalized',...
       'position',[0.42, 0.16, 0.35, 0.03],...
       'backgroundcolor','w',...  
       'string','You must load a file first',...
       'Callback','isomapeda(''loadres'')');
   
   h.steps(3) = uicontrol('style','text',...
       'units','normalized',...
       'position',[0.02 0.16, 0.4, 0.03],...
       'fontweight','bold',...
       'horiz','left',...
       'string','3. Choose the residuals:');
    
   h.filenametxt = uicontrol('style','text',...
       'units','normalized',...
       'position',[0.35, 0.965, 0.85 0.03],...
       'fontunits','normalized',...
       'string','DISPLAYING ...',...
       'horiz','left',...
       'fontweight','bold',...
       'foregroundcolor',[0 0 1]);
   
   % Do the first - part A plotting frame. Residuals
   uicontrol('style','frame',...
       'units','normalized',...
       'position',[0.35,0.88,0.63,0.075]);
   
   uicontrol('style','text',...
       'units','normalized',...
       'position',[0.38 0.91 0.3 0.04],...
       'fontunits','normalized',...
       'string','RESIDUAL PLOT',...
       'fontweight','bold',...
       'horiz','left')
   
   h.popupres = uicontrol('style','popupmenu',...
       'units','normalized',...
       'position',[0.38 0.88 0.3 0.04],...
       'fontunits','normalized',...
       'string',{'Single Plot','4 Residual Plots'},...
       'backgroundcolor','w');
   
   uicontrol('style','pushbutton',...
       'units','normalized',...
       'position',[0.75 0.89 0.17 0.05],...
       'string','Do Plot',...
       'fontunits','normalized',...
       'fontweight','bold',...
       'callback','isomapeda(''residualplot'')')
   
   % Do the first - part B plotting frame.
   uicontrol('style','frame',...
       'units','normalized',...
       'position',[0.35,0.80,0.63,0.075]);
   
   uicontrol('style','text',...
       'units','normalized',...
       'position',[0.37, 0.81, 0.5, 0.05],...
       'fontunits','normalized',...
       'string','SCATTERPLOT MATRIX',...
       'horiz','left',...
       'fontweight','bold',...
       'tooltipstring','Push button to display scatterplot matrix.')
   
   uicontrol('Style','pushbutton',...
       'units','normalized',...
       'fontunits','normalized',...
       'string','Do Plot',...
       'fontweight','bold',...
       'position',[0.75, 0.81, 0.17, 0.05],...
       'CallBack','isomapeda(''doplotmatrix'')',...
       'tooltipstring','Push button to display scatterplot matrix.')
   
   % Do the second plotting frame.
   
   uicontrol('style','frame',...
       'units','normalized',...
       'position',[0.35,0.54,0.63,0.25]);
   
   uicontrol('style','text',...
       'units','normalized',...
       'position',[0.4, 0.72, 0.5, 0.05],...
       'fontunits','normalized',...
       'string','CREATE A 2-D SCATTERPLOT',...
       'horiz','center',...
       'fontweight','bold',...
       'tooltipstring','Push button to display 2-D scatterplot matrix.')
   
   uicontrol('style','text',...
       'units','normalized',...
       'position',[0.37, 0.68, 0.5 0.05],...
       'fontunits','normalized',...
       'string','Enter the dimensions or click on the axis in the scatterplot matrix:',...
       'horiz','left',...
       'fontweight','bold')
   
   h.dim1 = uicontrol('style','edit',...
       'units','normalized',...
       'position',[0.38, 0.63, 0.3, 0.04],...
       'backgroundcolor','w',...
       'string','1');
   
   h.dim2 = uicontrol('style','edit',...
       'units','normalized',...
       'position',[0.38, 0.58, 0.3, 0.04],...
       'backgroundcolor','w',...
       'string','2');
   
   uicontrol('Style','pushbutton',...
       'units','normalized',...
       'fontunits','normalized',...
       'string','Do Plot',...
       'fontweight','bold',...
       'position',[0.75, 0.6, 0.17, 0.05],...
       'CallBack','isomapeda(''doscatterplotgui'')',...
       'tooltipstring','Push button to display scatterplot matrix.')
   
   % Do third frame - 3-d scatterplot
   
   uicontrol('style','frame',...
       'units','normalized',...
       'position',[0.35,0.30,0.63,0.23]);
   
   uicontrol('style','text',...
       'units','normalized',...
       'position',[0.4, 0.47, 0.5, 0.05],...
       'fontunits','normalized',...
       'string','CREATE A 3-D SCATTERPLOT',...
       'horiz','center',...
       'fontweight','bold',...
       'tooltipstring','Push button to display 3-D scatterplot matrix.')
   
   uicontrol('style','text',...
       'units','normalized',...
       'position',[0.37, 0.44, 0.5 0.05],...
       'fontunits','normalized',...
       'string','Enter the dimensions:',...
       'horiz','left',...
       'fontweight','bold')
   
   h.dim31 = uicontrol('style','edit',...
       'units','normalized',...
       'position',[0.38, 0.42, 0.3, 0.04],...
       'backgroundcolor','w',...
       'string','1');
   
   h.dim32 = uicontrol('style','edit',...
       'units','normalized',...
       'position',[0.38, 0.37, 0.3, 0.04],...
       'backgroundcolor','w',...
       'string','2');
   
   h.dim33 = uicontrol('style','edit',...
       'units','normalized',...
       'position',[0.38, 0.32, 0.3 0.04],...
       'backgroundcolor','w',...
       'string','3');
   
   uicontrol('Style','pushbutton',...
       'units','normalized',...
       'fontunits','normalized',...
       'string','Do Plot',...
       'fontweight','bold',...
       'position',[0.75, 0.32, 0.17, 0.05],...
       'CallBack','isomapeda(''do3dscatter'')',...
       'tooltipstring','Push button to display scatterplot matrix.')
 
   h.data = [];
   h.colflag = [1 0 0 0 0 0]; % non-zero one is red - current step
   h.legend = [];
   h.map = setmap;   % get the colors
   set(h.fig,'userdata',h)
  
elseif strcmp('residualplot',action)
    
    h = get(findobj('tag','isomapgui'),'Userdata');
    flag = get(h.popupres,'value');
    dims = 1:length(h.residual);
    R = h.residual;
    if flag == 1
        % Then do the single plot.
        figure
        plot(dims,R,dims,R,'o')
        ylabel('Residual variance'); 
        xlabel('Isomap dimensionality'); 
        title(['Residual Plot for ' h.varname])
        axs = axis;
        axis([0 11 axs(3) axs(4)])

    elseif flag==2
        % Then do the four plots.
        figure
        subplot(2,2,1)
        plot(dims,R,dims,R,'o')
        title(['Residual Plot for ' h.varname])
        axs = axis;
        axis([0 11 axs(3) axs(4)])
        subplot(2,2,2)
        % plot the slope
        dy = diff(R)./diff(dims);
        xd = dims(2:end);
        plot(xd,dy,xd,dy,'x')
        title('Estimate of Slope')
        axs = axis;
        axis([0 11 axs(3) axs(4)])
        subplot(2,2,3)
        % Plot the percent difference
        perdel = diff(R)./R(1:(end-1));
        plot(xd,perdel,xd,perdel,'*')
        title('Percent Change in Residual')
        axs = axis;
        axis([0 11 axs(3) axs(4)])
        subplot(2,2,4)
        % Plot the ratio of successive terms.
        ratio = R(1:(end-1))./R(2:end);
        plot(xd,ratio,xd,ratio,'o')
        title('Ratio of R_i and R_{i+1}')
        axs = axis;
        axis([0 11 axs(3) axs(4)])
        tmpstr = strrep(h.fname,'.mat','');
        toptitle(['Results for ',h.varname, ' from ', tmpstr])
        
    end
           
elseif strcmp('loaddata',action)
    
   h = get(findobj('tag','isomapgui'),'Userdata');
   loaddata(h);  % call the function to read in the data
   
elseif strcmp('loadlabels',action)
    
   h = get(findobj('tag','isomapgui'),'Userdata');
   getlabs(h);  % call the function to read in the labels
   
elseif strcmp('changeclasscol',action)
   h = get(findobj('tag','isomapgui'),'Userdata');
   changecol(h);
   
elseif strcmp('help',action)
    s = which('edaguihelp.htm');
    web(['file:' s ], '-browser')
  
elseif strcmp('doplotmatrix',action)
   
    h = get(findobj('tag','isomapgui'),'Userdata');   
   % Get which record or number of dimensions selected in the popupmenu.
   ndims = get(h.popup,'value') + 1;
   if ~isempty(h.data)
       X = h.data{ndims};
       X = X';
       classlabs = h.classlabs;
       if isempty(classlabs)    % then plot as all one color - white
           % make them all class 1
           [n,d] = size(X);
           classlabs = ones(n,1);
       end
       [h.ax,h.BigAx,patches,h.pax]= plotmatrixclass(X,classlabs',h.map); % call the function to do the plotmatrix.
       title([h.varname, ' in ', h.fname])
       
       % Set all of the 'buttondownfcn of the axes to call the 2-D scatterplot.
       set(h.ax,'buttondownfcn','isomapeda(''doscatterplotaxes'')');
       
       % Save the stuff in the handle structure.
       set(h.fig,'userdata',h)
   else
       errordlg('You must load some data first.','Plot Data Error')
   end
   
elseif strcmp('doscatterplotgui',action)
    
    % This one does the 2-d scatterplot based on the entries in the edit boxes.
    h = get(findobj('tag','isomapgui'),'Userdata');  
    dim1 = str2num(get(h.dim1,'string'));
    dim2 = str2num(get(h.dim2,'string'));

    % Get which record or number of dimensions selected in the popupmenu.
   
    ndims = get(h.popup,'value') + 1;
    if ~isempty(h.data)
       X = h.data{ndims};
       X = X';
%        classlabs = loadcl;
       classlabs = h.classlabs;
       if isempty(classlabs)    % then plot as all one color - white
           % make them all class 1
           [n,d] = size(X);
           classlabs = ones(n,1);
       end
       scatter2d(X,classlabs,dim1,dim2,h.map)
       title([ h.varname, ' in ', h.fname])
       xlabel(num2str(dim1))
       ylabel(num2str(dim2))
   else
       errordlg('You must load some data first.','Plot Data Error')
   end
   
elseif strcmp('doscatterplotaxes',action)
    
    % This one does the 2-d scatterplot based on a user-click on the plotmatrix.
    h = get(findobj('tag','isomapgui'),'Userdata');
    
    % find the dimensions that the person clicked on.
    ha = gca;
    [dim2,dim1] = find(h.ax == ha);
    
    ndims = get(h.popup,'value') + 1;
    
    if ~isempty(h.data)
       X = h.data{ndims};
       X = X';
       classlabs = h.classlabs;
       if isempty(classlabs)    % then plot as all one color - white
           % make them all class 1
           [n,d] = size(X);
           classlabs = ones(n,1);
       end
       scatter2d(X,classlabs,dim1,dim2,h.map)
       title([ h.varname, ' in ', h.fname])
       xlabel(num2str(dim1))
       ylabel(num2str(dim2))
    else
       errordlg('You must load some data first.','Plot Data Error')
    end
    
elseif strcmp('loadvar',action)
    
    % Load the selected variable.
    h = get(findobj('tag','isomapgui'),'Userdata');
    loadvar(h);
    
elseif strcmp('loadlabs',action)
    % Load the selected variable.
    h = get(findobj('tag','isomapgui'),'Userdata');
    loadlabs(h);
    
elseif strcmp('loadres',action)
    
    % Load the selected variable.
    h = get(findobj('tag','isomapgui'),'Userdata');
    loadres(h);

elseif strcmp('do3dscatter',action)
    h = get(findobj('tag','isomapgui'),'Userdata');
    
    dim1 = str2num(get(h.dim31,'string'));
    dim2 = str2num(get(h.dim32,'string'));
    dim3 = str2num(get(h.dim33,'string'));

    % Get which record or number of dimensions selected in the popupmenu.
   
    ndims = get(h.popup,'value') + 1;
    
    if ndims <= 2
        errordlg('You must select a higher dimensionality in the popupmenu.','Plot Data Error')
        return
    end
    
    if ~isempty(h.data)
       X = h.data{ndims};
       X = X';
       classlabs = h.classlabs;
       if isempty(classlabs)    % then plot as all one color - white
           % make them all class 1
           [n,d] = size(X);
           classlabs = ones(n,1);
       end
       scatter3d(X,classlabs,dim1,dim2,dim3,h.map)
       title([ h.varname, ' in ', h.fname])
       xlabel(num2str(dim1))
       ylabel(num2str(dim2))
       zlabel(num2str(dim3))
   else
       errordlg('You must load some data first.','Plot Data Error')
   end
  
end         % of elseif statements

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           FUNCTION SCATTER3D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function scatter3d(x,classlabs,dim1,dim2,dim3,map)

% Get the unique classes.
classes = unique(classlabs);
nclass = length(classes);
figure
% Here is where we add the different colors for the classes.
% Get the first one started.
cls = classes(1);
inds = find(classlabs==cls);
hh = plot3(x(inds,dim1),x(inds,dim2),x(inds,dim3),'.');
set(hh,'color',map(1,:));
hold on    

for cc = 2:nclass
    cls = classes(cc);
    inds = find(classlabs==cls);
    hh = plot3(x(inds,dim1),x(inds,dim2),x(inds,dim3),'.')';
    set(hh,'color',map(cc,:));
end
hold off

grid on
set(gca,'color','k','xcolor','w','ycolor','w','zcolor','w')
grid on



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%           FUNCTION SCATTER2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function scatter2d(x,classlabs,dim1,dim2,map)

% Get the unique classes.
classes = unique(classlabs);
nclass = length(classes);
figure
% Here is where we add the different colors for the classes.
% Get the first one started.
cls = classes(1);
inds = find(classlabs==cls);
hh = plot(x(inds,dim1),x(inds,dim2),'.');
set(hh,'color',map(1,:));
hold on    

for cc = 2:nclass
    cls = classes(cc);
    inds = find(classlabs==cls);
    hh = plot(x(inds,dim1),x(inds,dim2),'.')';
    set(hh,'color',map(cc,:));
end
hold off
set(gca,'color','k')

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           FUNCTION - LOADDATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loaddata(h)

% Delete the help string from the legend box
if ~isempty(h.help)
    delete(h.help)
    h.help = [];
    loadlabs(h)
end
% reload the h information because it was changed.
h = get(findobj('tag','isomapgui'),'Userdata');

[h.fname, h.pname] = uigetfile('*.mat;*.txt', 'Load Data File for Display');
if h.fname == 0   % person hit cancel button
    return
end
eval(['s = load(''' h.pname, h.fname, ''');'])
names = fieldnames(s);

% Load up only those variables that are structures.
ind = zeros(size(names));
indr = zeros(size(names));
for i = 1:length(names)
eval([ 'if isstruct(s.' names{i} '), ind(i) = 1;end'])
eval([ 'if isnumeric(s.' names{i} ') & min(size(s.' names{i} '))==1, indr(i) = 1;end'])
end
% now get the possible structures from isomap
strg = names(find(ind));
h.names = strg;
set(h.popupvar,'string',strg);

% now get the possible residual variables
strgr = names(find(indr));

h.resnames = strgr;
set(h.popupres2,'string',strgr);

% Set the next steps 2&3 to red.
set(h.steps(find(h.colflag)),'foregroundcolor','k')
h.colflag = [0 1 0 0 0 0];
set(h.steps(find(h.colflag)),'foregroundcolor','r')

set(h.fig,'userdata',h)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       FUNCTION - LOADVAR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function loadvar(h)
% Get the selected value.
val = get(h.popupvar,'value');
answer = h.names(val);

eval(['load ' h.pname h.fname ' ' answer{1}])
% Then get the file name.
% Note that with isomap, this will be a structure.
eval(['tmp = ' answer{1} '.coords;'])
% Display the variable and filename in the text box.
set(h.filenametxt,'string',['DISPLAYING ',answer{1}, ' from ', h.fname])
% This is the structure containing the output from isomap.
% Actually, it is the 'coords' part of the structure only.
% Note that these records are ndims x N (size of data set), so we must transpose later.
h.data = tmp;
h.varname = answer{1};

% Find the number of dimensions that are available. This is found as the
% length of the field 'coords'
eval( ['numdim = length(' answer{1} '.coords);'])
for is = 2:numdim
    tmps{is-1} = int2str(is);
end
set(h.popup,'string',tmps);

% change the color for the popumenu
set(h.steps([2]),'foregroundcolor','k')
h.colflag([2]) = 0;
h.colflag(3) = 1;
set(h.steps(3),'foregroundcolor','r')
    
set(h.fig,'userdata',h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           FUNCTION LOADRES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loadres(h)
% Get the selected value.

% Now get the residual data.
val = get(h.popupres2,'value');
answer = h.resnames(val);
eval(['load ' h.pname h.fname ' ' answer{1}])
eval(['h.residual = ' answer{1} ';'])

% reset the string colors for next steps
% ind = find(h.colflag);
% change the color for the popumenu
set(h.steps([3]),'foregroundcolor','k')
h.colflag([3]) = 0;
h.colflag(4) = 1;
set(h.steps(4),'foregroundcolor','r')
    
set(h.fig,'userdata',h);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           FUNCTION SETMAP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function map = setmap;
map = [1.0000    1.0000    1.0000
    1.0000    1.0000         0
    1.0000         0    1.0000
    1.0000         0         0
         0    1.0000    1.0000
         0    1.0000         0
         0         0    1.0000
    0.9500    0.8500    0.6600
    0.5500    0.2200    0.7900
    0.2000    0.5300    0.5100
    0.8300    0.6300    0.0900
    0.3100    0.5700    0.3500
    0.8800    0.5500    0.4200
    0.2900    0.2500    0.0900
    0.7200    0.6800    0.3500
    0.9700    0.4000    0.2500];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           FUNCTION - CHANGE CLASS LABEL COLOR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function changecol(h)
% create input box to get the users preference
prompt={'Choose the class label to change:'};
if isnumeric(h.classlabs)
    classes = unique(h.classlabs);
    def = {int2str(h.classlabs(2))};
    dlgTitle = 'Input for Changing Class Color';
    lineNo = 1;
    answer=inputdlg(prompt,dlgTitle,lineNo,def);
    try
        if ~isempty(answer)
            ind = str2num(answer{1});
            indc = find(ind == classes);
            h.map(indc,:) = uisetcolor(h.legend(indc));
        end
    catch
        errordlg('Error made in choosing color','Change Color Error')
    end
else
    % they are strings
    classes = unique(h.classlabs);
    def = h.classlabs(1);
    dlgTitle = 'Input for Changing Class Color';
    lineNo = 1;
    answer=inputdlg(prompt,dlgTitle,lineNo,def);
end
set(h.fig,'userdata',h)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           FUNCTION GETLABS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function getlabs(h)
% just allows the user to select the file that contains class labels
[h.cfname, h.cpname] = uigetfile('*.mat;*.txt', 'Load Class Labels');
if h.cfname == 0   % person hit cancel button
    return
end
eval(['s = load(''' h.cpname, h.cfname, ''');'])
names = fieldnames(s);
% Load up only those variables that are structures.
indr = zeros(size(names));
for i = 1:length(names)
eval([ 'if (isnumeric(s.' names{i} ') & min(size(s.' names{i} '))==1) | iscell(s.' names{i} ') , indr(i) = 1;end'])
end
set(h.steps(5),'foregroundcolor','r')

strgr = names(find(indr));
h.classnames = {'No Labels', strgr{:}};
set(h.steps(find(h.colflag(1:4))),'foregroundcolor','k')
set(h.poplabs,'string',h.classnames);

set(h.fig,'userdata',h)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%           FUNCTION LOADLABS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
function loadlabs(h)
% Load the selected variable once the user clicks on the popupmenu
% Get the selected value.
val = get(h.poplabs,'value');
if val ~= 1     % if 1, then no class labels are used
    answer = h.classnames(val);
    eval(['load ' h.cpname h.cfname ' ' answer{1}])
    eval(['h.classlabs = ' answer{1} ';'])
    map = h.map;
    strgclass = unique(h.classlabs);
    h.strgclass = strgclass;
    numclass = length(strgclass);
    % If legend information exists, clear it first
    if ~isempty(h.legend)
        delete(h.legend)
    end
    if numclass > 16
        error('The number of classes cannot exceed 16.');
    elseif isnumeric(h.classlabs)
        % then the labels are numbers
        for i = 1:numclass
            h.legend(i) = uicontrol('style','text',...
                'units','normalized',...
                'position',[0.05, 0.9 - (i-1)*.035, 0.2, 0.036],...
                'fontweight','bold',...
                'Horiz','left',...
                'string',['Class ', int2str(strgclass(i))],...
                'backgroundcolor','k',...
                'foregroundcolor',map(i,:),...
                'fontunits','normalized');
        end
    elseif iscell(h.classlabs)
        for i = 1:numclass
            h.legend(i) = uicontrol('style','text',...
                'units','normalized',...
                'position',[0.05, 0.9 - (i-1)*.035, 0.2, 0.034],...
                'fontweight','bold',...
                'Horiz','left',...
                'string',['Class ', strgclass{i}],...
                'backgroundcolor','k',...
                'foregroundcolor',map(i,:),...
                'fontunits','normalized');
        end
    else
        error('Loaded variable is not of the right type')
    end
else
    if ~isempty(h.legend)
        delete(h.legend)
    end
    map = h.map;
    h.classlabs = [];      % no class labels use only one color - white
    h.legend = uicontrol('style','text',...
        'units','normalized',...
        'position',[0.05, 0.8, 0.2, 0.1],...
        'fontweight','bold',...
        'Horiz','left',...
        'string','No class labels',...
        'backgroundcolor','k',...
        'foregroundcolor',map(1,:),...
        'fontunits','normalized');
end

set(h.steps(1),'foregroundcolor','r')
set(h.steps(5),'foregroundcolor','k')
h.colflag = [1 0 0 0 0 0];
set(h.fig,'userdata',h)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           DOPLOTMATRIX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ax,BigAx,patches,pax] = plotmatrixclass(varargin)
%PLOTMATRIXCLASS  Scatter plot matrix.
%   PLOTMATRIXCLASS(X,CLASSLABS) scatter plots the columns of X pairwise.
%   The variable CLASSLABS contains the class labels for X. This version
%   will do up to 16 classes (or colors).

%   This was revised December, 2001 to allow the user to input class
%   labels so each class will be displayed with a different color.

% Set color map. First 7 colors are the 'built-in' ones in MATLAB.
map =    varargin{3};
sym = '.'; % Default scatter plot symbol.

% Changed the code here to reflect that we will only do
% a plotmatrix of one data set.
rows = size(varargin{1},2); cols = rows;
x = varargin{1}; y = varargin{1};
dohist = 1;
classlabs = varargin{2};
% find the number of distinct classes.
classes = unique(classlabs);
nclass = length(classes);

patches = [];
pax = [];
if length(classlabs) ~= size(x,1)
    error('The number of rows in X must match the number of class labels.');
end

% for the gui, always create a new figure.
figure

% Create/find BigAx and make it invisible
BigAx = newplot;
next = lower(get(BigAx,'NextPlot'));
hold_state = ishold;
set(BigAx,'Visible','off','color','none')
units = get(BigAx,'units');
set(BigAx,'units','pixels');
pos = get(BigAx,'Position');
set(BigAx,'units',units);
markersize = max(1,min(15,round(15*min(pos(3:4))/max(1,size(x,1))/max(rows,cols))));

% Create and plot into axes
ax = zeros(rows,cols);
pos = get(BigAx,'Position');
width = pos(3)/cols;
height = pos(4)/rows;
space = .02; % 2 percent space between axes
pos(1:2) = pos(1:2) + space*[width height];
[m,n,k] = size(y);
xlim = zeros([rows cols 2]);
ylim = zeros([rows cols 2]);
for i=rows:-1:1,
  for j=cols:-1:1,
    axPos = [pos(1)+(j-1)*width pos(2)+(rows-i)*height ...
             width*(1-space) height*(1-space)];
    findax = findobj(gcf,'Type','axes','Position',axPos);
    if isempty(findax),
      ax(i,j) = axes('Position',axPos);
      set(ax(i,j),'visible','on');
    else
      ax(i,j) = findax(1);
    end
    
    % Here is where we add the different colors for the classes.
    % Get the first one started.
    cls = classes(1);
    inds = find(classlabs==cls);
    hh = plot(x(inds,j,:),y(inds,i,:),sym);
    set(hh,'markersize',markersize,'color',map(1,:));
    hold on    
    for cc = 2:nclass
        cls = classes(cc);
        inds = find(classlabs==cls);
        hh = plot(x(inds,j,:),y(inds,i,:),sym)';
        set(hh,'markersize',markersize);
        set(hh,'color',map(cc,:));
    end
    hold off
    set(ax(i,j),'xlimmode','auto','ylimmode','auto','xgrid','off','ygrid','off')
    xlim(i,j,:) = get(gca,'xlim');
    ylim(i,j,:) = get(gca,'ylim');
  end
end

xlimmin = min(xlim(:,:,1),[],1); xlimmax = max(xlim(:,:,2),[],1);
ylimmin = min(ylim(:,:,1),[],2); ylimmax = max(ylim(:,:,2),[],2);

% Try to be smart about axes limits and labels.  Set all the limits of a
% row or column to be the same and inset the tick marks by 10 percent.
inset = .15;
for i=1:rows,
  set(ax(i,1),'ylim',[ylimmin(i,1) ylimmax(i,1)])
  dy = diff(get(ax(i,1),'ylim'))*inset;
  set(ax(i,:),'ylim',[ylimmin(i,1)-dy ylimmax(i,1)+dy])
end
for j=1:cols,
  set(ax(1,j),'xlim',[xlimmin(1,j) xlimmax(1,j)])
  dx = diff(get(ax(1,j),'xlim'))*inset;
  set(ax(:,j),'xlim',[xlimmin(1,j)-dx xlimmax(1,j)+dx])
end

set(ax(1:rows-1,:),'xticklabel','')
set(ax(:,2:cols),'yticklabel','')
set(BigAx,'XTick',get(ax(rows,1),'xtick'),'YTick',get(ax(rows,1),'ytick'), ...
          'userdata',ax,'tag','PlotMatrixBigAx')

% Put a histogram on the diagonal
for i=rows:-1:1,
    histax = axes('Position',get(ax(i,i),'Position'));
    [nn,xx] = hist(reshape(y(:,i,:),[m k]));
    patches(i,:) = bar(xx,nn,'hist','w');
    set(histax,'xtick',[],'ytick',[],'xgrid','off','ygrid','off');
    set(histax,'xlim',[xlimmin(1,i)-dx xlimmax(1,i)+dx])
    pax(i) = histax;  % ax handles for histograms
end
patches = patches';
% Make BigAx the CurrentAxes
set(gcf,'CurrentAx',BigAx)
if ~hold_state,
   set(gcf,'NextPlot','replace')
end
% Also set Title and X/YLabel visibility to on and strings to empty
set([get(BigAx,'Title'); get(BigAx,'XLabel'); get(BigAx,'YLabel')], ...
 'String','','Visible','on')
% Set all of the scatterplot axes to black.
set(ax,'color','k')
set(pax,'color','k')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   TOPTITLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
% downloaded from ftp.mathworks.com

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
