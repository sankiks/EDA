function genmix(arg)

% GUI FOR GENERATING MULTIVARIATE RANDOM VARIABLES FROM MIXTURE
% 
%    GENMIX
% 
%  This GUI will generate random variables using a
%  finite mixture model. The user can pick between
%  several models:
%           SPHERICAL FAMILY (DIAGONAL COVARIANCE, SAME VARIANCES FOR VARIABLES/DIMENSIONS):
%           1. COV are of form lambda*I       (clusters have equal covariances)
%           2: COV are of form lambda_k*I     (clusers have unequal covariances)
%
%           DIAGONAL FAMILY (DIAGONAL COVARIANCE, DIFFERENT VARIANCES FOR VARIABLES/DIMENSIONS):
%           3. COV are of form lambda*B       (clusters have equal covariances)
%           4. COV are of form lambda*B_k     (clusters have same volume, unequal shape)
%           5. COV are of form lambda_k*B_k   (clusters have unequal volume, unequal shape)
%           where B = diag(b_1,...,b_d); B is a diagonal matrix with different values and
%           det(B) = 1.
%           
%           GENERAL FAMILY (FULL COVARIANCE, OFF-DIAGONAL ELEMENTS ARE NON-ZERO)
%           6. COV are of form lambda*D*A*D'          (clusters have equal covariance)
%           7. COV are of form lambda*D_k*A*(D_k)'    (clusters have different orientation)
%           8. COV are of form lambda*D_k*A_k*(D_k)'  (clusters have different orientation and shape)
%           9. COV are of form SIGMA_k_hat            (unconstrained, all aspects vary)
%           where lambda represents the volume, D governs the orientation, and A is a diagonal matrix
%           that describes the shape.
%
% 
%  The user can save the random variables to a text file (saved in
%  row (observations) and column (variables) format. The data can also
%  be saved to the MATLAB Workspace with a user-assigned variable name.

%   Model-based Clustering Toolbox, January 2003
%   Revised April 2003 to include expanded set of models. These models can
%   be used with the new expanded finite mixtures code.

 
if nargin == 0
    % Then initialize the GUI.
    arg = 'initgui';
end

if strcmp(arg,'initgui')
    % Then initialize the GUI.
    H.fig = figure('units','normalized',...
        'position',[ 0.153 0.168 0.692 0.746],...
        'Name','Generate Random Variables from a Finite Mixture',...
        'NumberTitle','off',...
        'Toolbar','none');
	
    uicontrol(H.fig,'style','text',...
        'units','normalized',...
        'position',[ 0.10 0.91 0.8 0.075],...
        'horizontal','left',...
        'string',['This GUI will generate random variables from a finite mixture model.',...
            '  Enter the required data and hit the button to generate the data set.',...
            '  The data can be saved to the MATLAB workspace or written to a text file.'],...
        'fontweight','bold');
    
    uicontrol(H.fig,'style','text',...
        'units','normalized',...
        'position',[0.10 0.85 0.3 0.04],...
        'String','Step 1: Choose the number of dimensions:',...
        'horizontal','left');
    
    uicontrol(H.fig,'style','text',...
        'units','normalized',...
        'position',[0.10 0.78 0.3 0.04],...
        'String','Step 2: Enter the number of observations:',...
        'horizontal','left');
    
    uicontrol(H.fig,'style','text',...
        'units','normalized',...
        'position',[0.1 0.71 0.3 0.04],...
        'string','Step 3: Choose the number of components:',...
        'horizontal','left');
    
    uicontrol(H.fig,'style','text',...
        'units','normalized',...
        'position',[0.1 0.64 0.3 0.04],...
        'string','Step 4: Choose the model:',...
        'horizontal','left');
    
    uicontrol(H.fig,'style','frame',...
        'units','normalized',...
        'position',[ 0.35 0.53 0.645 0.147]);
    
    uicontrol(H.fig,'style','text',...
        'units','normalized',...
        'position', [0.1 0.45 0.3 0.06],...
        'String','Step 5: Enter the component weights, separated by commas or blanks:',...
        'horizontal','left');
    
    uicontrol(H.fig,'style','text',...
        'units','normalized',...
        'position',[0.1 0.36 0.3 0.06],...
        'String','Step 6: Enter the means for each component - push button:',...
        'horizontal','left');
    
    uicontrol(H.fig,'style','text',...
        'units','normalized',...
        'position',[0.1 0.27 0.3 0.06],...
        'String','Step 7: Enter the covariance matrices for each component - push button:',...
        'horizontal','left');
    
    uicontrol(H.fig,'style','text',...
        'units','normalized',...
        'position',[0.1 0.18 0.3 0.06],...
        'String','Step 8: Push button to generate random variables:',...
        'horizontal','left');
	
	H.plot = uicontrol(H.fig,'style','pushbutton',...
		'units','normalized',...
		'position',[0.1 0.07 0.15 0.065],...
		'String','Plot Data',...
		'Callback','genmix(''plotdata'')');
	
    H.saveworkspace = uicontrol(H.fig,'style','pushbutton',...
        'units','normalized',...
        'position',[0.3 0.07 0.15 0.065],...
        'String','Save to Workspace',...
        'Callback','genmix(''saveworkspace'')');
    
    H.savefile = uicontrol(H.fig,'style','pushbutton',...
        'units','normalized',...
        'position',[0.5 0.07 0.15 0.065],...
        'String','Save to File',...
        'CallBack','genmix(''savefile'')');
    
    H.close = uicontrol(H.fig,'style','pushbutton',...
        'units','normalized',...
        'position',[0.7 0.07 0.15 0.065],...
        'String','Close',...
        'CallBack','close(gcf)');
    
    H.dims = uicontrol(H.fig,'style','popup',...
        'units','normalized',...
        'position',[0.45 0.85 0.1 0.04],...
        'String','2|3|4|5|6|7|8|9|10',...
        'Backgroundcolor','w');
    
    H.nobs = uicontrol(H.fig,'style','edit',...
        'units','normalized',...
        'position',[0.45 0.78 0.1 0.04],...
        'String','1000',...
        'Backgroundcolor','w');
    
    H.ncomp = uicontrol(H.fig,'style','popup',...
        'units','normalized',...
        'position',[0.45 0.71 0.1 0.04],...
        'String','1|2|3|4|5|6|7|8|9|10',...
        'Backgroundcolor','w',...
		'Value',2);
        
    H.model(1) = uicontrol(H.fig,'style','radio',...
        'units','normalized',...
        'position',[0.37 0.62 0.2 0.047],...
        'String','Spherical - Model 1',...
        'Value',1,...
        'CallBack','genmix(''model'')');
    
    H.model(2) = uicontrol(H.fig,'style','radio',...
        'units','normalized',...
        'position',[0.37 0.55 0.2 0.047],...
        'String','Spherical - Model 2',...
        'CallBack','genmix(''model'')');
    
    H.model(3) = uicontrol(H.fig,'style','radio',...
        'units','normalized',...
        'position',[0.56 0.62 0.2 0.047],...
        'String','Diagonal - Model 3',...
        'CallBack','genmix(''model'')');
    
    H.model(4) = uicontrol(H.fig,'style','radio',...
        'units','normalized',...
        'position',[0.56 0.55 0.2 0.047],...
        'String','Diagonal - Models 4 & 5',...
        'CallBack','genmix(''model'')');
    
    H.model(5) = uicontrol(H.fig,'style','radio',...
        'units','normalized',...
        'position',[0.78 0.62 0.2 0.047],...
        'String','General - Model 6',...
        'CallBack','genmix(''model'')');
    
    H.model(6) = uicontrol(H.fig,'style','radio',...
        'units','normalized',...
        'position',[0.78 0.55 0.2 0.047],...
        'String','General - Models 7, 8, & 9',...
        'CallBack','genmix(''model'')');

    
    H.pies = uicontrol(H.fig,'style','edit',...
        'units','normalized',...
        'position',[ 0.45 0.46 0.4 0.04],...
        'String','0.5, 0.5',...
        'backgroundcolor','w',...
        'horizontal','left',...
        'CallBack','genmix(''checkpies'')');
    
    H.mus = uicontrol(H.fig,'style','pushbutton',...
        'units','normalized',...
        'position',[0.45 0.36 0.2 0.065],...
        'String','Enter means...',...
        'CallBack','genmix(''entermeans'')');
    
    uicontrol(H.fig,'style','text',...
        'units','normalize',...
        'position', [0.65 0.41 0.3, 0.05],...
        'String','Press to view in command window:');
    
    uicontrol(H.fig,'style','pushbutton',...
        'units','normalized',...
        'position',[0.7 0.36 0.2 0.065],...
        'String','View Current Means',...
        'Tooltipstring','View current means in command window.',...
        'CallBack','genmix(''viewmeans'') ');
    
    H.covs = uicontrol(H.fig,'style','pushbutton',...
        'units','normalized',...
        'position',[0.45 0.27 0.2 0.065],...
        'String','Enter covariance matrices...',...
        'CallBack','genmix(''entercovs'')');
    
    uicontrol(H.fig,'style','pushbutton',...
        'units','normalized',...
        'position',[0.7 0.27 0.2 0.065],...
        'String','View Current Covariances',...
        'Tooltipstring','View current covariances in command window.',...
        'CallBack',' genmix(''viewcovs'')');
    
    H.genrv = uicontrol(H.fig,'style','pushbutton',...
        'units','normalized',...
        'position',[0.45 0.18 0.2 0.065],...
        'String','Generate RV''s ...',...
        'CallBack','genmix(''genrvs'')');

	% Initialize parameters
	H.weights = [0.5, 0.5];
	H.means = [3, -3; 3, -3];
	H.covms(:,:,1) = eye(2);
	H.covms(:,:,2) = eye(2);
	H.data = [];
    
    set(gcf,'userdata',H);
    
elseif strcmp(arg,'genrvs')
    % Generate the random variables.
    H = get(gcf,'userdata');
    genrvs(H);
    
elseif strcmp(arg,'model')
    % Make the model choices mutually exclusive.
    H = get(gcf,'userdata');
    % Get the handle for the callback object
    Hon = gcbo;
    % Get the handles for the radio buttons.
    Hmods = H.model;
    set(Hmods,'Value',0)
    set(Hon,'Value',1)
            
elseif strcmp(arg,'checkpies')
    % write some code to make sure the pies are ok. 
    % should check number of pies, also must be < 1, must sum to 1.
	H = get(gcf,'userdata');
	strg = get(H.pies,'string');
	nc = get(H.ncomp,'value');
	eval(['pies = [' strg '];']);
	
	if length(pies) ~= nc
		errordlg('The number of weights is incorrect.','Entry Error')
		return
	end
	% Save the pies
	H.weights = pies;
	set(H.fig,'userdata',H)
    
elseif strcmp(arg,'entermeans')
    % write the code to enter the means - use inputdlg box.
    H = get(gcf,'userdata');
    entermeans(H)
    
elseif strcmp(arg,'entercovs')
    % write code to enter the covariances - use inputdlg box.
    H = get(gcf,'userdata');
    entercovs(H);
	
elseif strcmp(arg,'plotdata')
	% write code to plot the data.
	H = get(gcf,'userdata');
	plotdata(H);
    
elseif strcmp(arg,'saveworkspace')
    H = get(gcf,'userdata');
    saveworkspace(H)
    
elseif strcmp(arg,'savefile')
    H = get(gcf,'userdata');
    savefile(H)
    
elseif strcmp(arg,'viewmeans')
    H = get(gcf,'userdata');
    viewmeans(H);
    
elseif strcmp(arg,'viewcovs')
    H = get(gcf,'userdata');
    viewcovs(H);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ENTER THE MEANS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function entermeans(H)

ndim = get(H.dims,'value')+1;
ncomp = get(H.ncomp,'value');
title = 'Input for Component Means';
prompt = cell(ncomp,1);
def = cell(ncomp,1);
% Get a temporary matrix for display purposes.
for i = 1:ncomp
	% Set up the strings for the dialog box.
	prompt{i} = ['Enter the ' int2str(ndim) '-dimensional mean for component ' int2str(i) ', separate values by commas or blanks:'];
	tmp = mat2str(i*ones(1,ndim));
	n = length(tmp);
	def{i} = tmp(2:(n-1));
end
answer  = inputdlg(prompt,title,1,def); 

if ~isempty(answer)
	mus = zeros(ndim,ncomp);
	for i = 1:ncomp
		eval(['tmp = [' answer{i} '];'])
		if length(tmp)==ndim
			eval(['mus(:,i) = [' answer{i} ']'';']);
		else
			errordlg('The number of entries in the mean is incorrect.','Dimensionality Error')
			return
		end
	end
else
	% If the user pushes cancel, then set the means to the current value.
	mus = H.means;
end

H.means = mus;
set(H.fig,'userdata',H)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ENTER THE COVARIANCE MATRICES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Just until I get it debugged. New function can also be found in
% 'entercovs.m'
% April 17 - added other cases.
function entercovs(H)
ndim = get(H.dims,'value')+1;
ncomp = get(H.ncomp,'value');
title='Input for Covariance Matrices';
model = get(H.model,'Value');
M = [model{:}];
flag = find(M);

% Note that the covariance matrices will be kept in a
% 3-D array - each dxd page is a covariance matrix for a component.
switch flag
case 1
    % lambda*I
    % Spherical and equal
	% Model 1 - common diagonal covariance matrices.
	% equal variance across terms.
	covs = zeros(ndim, ndim, ncomp);
	def = {'1'};
	prompt = {'Enter the variance for the components:'};
	answer = inputdlg(prompt,title,1,def);
	if ~isempty(answer)
		for i = 1:ncomp
			covs(:,:,i) = str2num(answer{1})*eye(ndim);
		end
	else
		% Reset to current value.
		covs = H.covms;
	end
case 2
    % lambda_k*I
    % spherical, unequal
	% Model 2 - spherical - unequal - sigma_k*I
	covs = zeros(ndim,ndim,ncomp);
	prompt = cell(ncomp,1);
	def = cell(ncomp,1);
	for i = 1:ncomp
		% Set up the strings for the dialog box.
		prompt{i} = ['Enter the variance for component ' int2str(i)];
		def{i} = '1';
	end
	answer  = inputdlg(prompt,title,1,def); 
	
	if ~isempty(answer)
		% Now set up the covariance matrices.
		for i = 1:ncomp
			covs(:,:,i) = str2num(answer{i})*eye(ndim);
		end
	else
		% Reset to current value.
		covs = H.covms;
	end
case 3
    % lambda*B
    % Diagonal family
    covs = zeros(ndim, ndim, ncomp);
	def(1) = {'1'};
    def(2) = {'1, 2'};
	prompt(1) = {'Enter lambda (a scalar value representing volume)'};
    prompt(2) = {'Enter diagonal elements of B, separated by commas or blanks'};
	answer = inputdlg(prompt,title,1,def);
	if ~isempty(answer)
		for i = 1:ncomp
            lam = str2num(answer{1});
            dg = eval(['[ ' answer{2} '];']);
            % check to make sure the determinant of B is 1
            if det(diag(dg)) ~= 1 
                errordlg('The determinant of the diagonal matrix must be 1.','Data Entry Error')
                return
            end
			covs(:,:,i) = lam*diag(dg);
		end
       
	else
		% Reset to current value.
		covs = H.covms;
	end
   
case 4
    % lambda_k*B or lambda_k*B_k
    % Diagonal family
    covs = zeros(ndim, ndim, ncomp);
	def(1) = {'1'};
    def(2) = {'1, 2'};
	prompt(1) = {'Enter lambda (a scalar value representing volume)'};
    prompt(2) = {'Enter diagonal elements of B, separated by commas or blanks'};
    
    for i = 1:ncomp
        tle = ['Input for Covariance Matrix, Component' int2str(i)];
        answer = inputdlg(prompt,tle,1,def);
        if ~isempty(answer)
            lam = str2num(answer{1});            
            dg = eval(['[ ' answer{2} '];']);
            % check to make sure the determinant of B is 1
            if det(diag(dg)) ~=1 
                errordlg('The determinant of the diagonal matrix must be 1.','Data Entry Error')
                return
            end

            covs(:,:,i) = lam*diag(dg);
        else
            % Reset to current value.
            covs = H.covms;
        end
        
    end
    
case 5
    % General family, lambda*D*A*D'
	% Model 3 - same covariance (full) matrix for each component
	covs = zeros(ndim,ndim,ncomp);
	prompt = cell(ndim,1);
	def = cell(ndim,1);
	title = 'Enter the covariance matrix ...';
	% set up strings for dialog box.
	tmpcov = eye(ndim);

	for i = 1:ndim
		prompt{i} = ['Enter the elements of row ' int2str(i) ' of the covariance matrix, separated by commas or blanks:'];
		tmp = mat2str(tmpcov(i,:));
		n = length(tmp);
		def{i} = tmp(2:(n-1));
	end
	answer = inputdlg(prompt,title,1,def);
	
	if ~isempty(answer)
		tmp = zeros(ndim,ndim);
		for i = 1:ndim
			eval(['tmp(i,:) = [' answer{i} '];']);
		end
		for i = 1:ncomp
			covs(:,:,i) = tmp;
		end
	else
		% Reset to current value.
		covs = H.covms;
	end
	
otherwise
    % General family, can accomodate models 7 - 9 of our notation

	% unconstrained model
	covs = zeros(ndim,ndim,ncomp);
	prompt = cell(ndim,1);
	def = cell(ndim,1);
	% set up strings for dialog box.
   
    tmpcov = eye(ndim);
    for j = 1:ndim
        prompt{j} = ['Enter the elements of row ' int2str(j) ' of the covariance matrix, separated by commas or blanks:'];
        tmpm = mat2str(tmpcov(j,:));
        n = length(tmpm);
        def{j} = tmpm(2:(n-1));
    end
    
    for i = 1:ncomp
        tmp = zeros(ndim,ndim);
        
        answer = inputdlg(prompt,['Enter covariance matrix ' int2str(i)'], 1, def);
        if ~isempty(answer)
            for j = 1:ndim
                eval(['tmp(j,:) = [' answer{j} '];']);
            end
            covs(:,:,i) = tmp;
        else
            % Reset to current value.
            covs = H.covms;
        end
    end		
end

H.covms = covs;
set(H.fig,'userdata',H)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   GENERATE RANDOM VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function genrvs(H)
% Write the function to generate the required random variables.
% First get the parameters.
pies = H.weights;
mus = H.means;
covs = H.covms;
n = str2num(get(H.nobs,'string'));
ndim = get(H.dims,'value')+1;
ncomp = get(H.ncomp,'value');

if length(pies) ~= ncomp
    % Then number of elements is not correct.
    errordlg('The number of weights is incorrect.','Data Entry Error')
	return
end

[nd,nc] = size(mus);
if nd~=ndim | nc~=ncomp
    errordlg('The number of means is incorrect.','Data Entry Error')
    return
end

% Now find out how many are in each term.
r = rand(1,n);
N = zeros(ncomp,1);
cpies = cumsum(pies);
N(1) = length(find(r < cpies(1)));
for i = 2:(ncomp-1)
	N(i) = length(find(r >= cpies(i-1) & r < cpies(i)));
end
N(ncomp) = n - sum(N);

% Now call the function that many times. 
data = zeros(n,ndim);
cN = cumsum(N);
data(1:N(1),:) = csmvrnd(mus(:,1),covs(:,:,1),N(1));
for i = 2:ncomp
	data(cN(i-1)+1:cN(i),:) = csmvrnd(mus(:,i),covs(:,:,i),N(i));
end
	
H.data = data;
set(gcf,'userdata',H);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SAVE TO THE WORKSPACE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function saveworkspace(H)
% Write function to save the data set to the workspace.

if isempty(H.data)
	errordlg('You have not generated any variables yet.','GUI Error')
	return
end

prompt = {'Enter the name for the variable:'};
title = 'Set Variable Name';
def = {'data'};
answer = inputdlg(prompt,title,1,def);
if ~isempty(answer)
	assignin('base',answer{1},H.data)
else
	assignin('base','data,H.data')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SAVE TO A FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savefile(H)
% Write a function to save the data set to a text file.

if ~isempty(H.data)
    data = H.data;
else
    errordlg('You have not generated any variables yet.','GUI Error')
	return
end

[filename,pathname] = uiputfile('*.txt','Save As Text File');

if filename ~= 0
	eval(['save ' [pathname, filename] ' data -ascii'])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	PLOT THE DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotdata(H)
figure

if ~isempty(H.data)
    plotmatrix(H.data);
else
    errordlg('You have not generated any variables yet.','GUI Error')
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	GENERATE THE RV'S FOR A TERM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = csmvrnd(mu,covm,n)
% CSMVRND Generate multivariate normal random variables.
%
%   R = CSMVRND(MU,COVM,N) Generates a sample of size N
%   random variables from the multivariate normal 
%   distribution. MU is the d-dimensional mean as a 
%   column vector. COVM is the d x d covariance matrix.
%
%   W. L. and A. R. Martinez, 9/15/01
%   Computational Statistics Toolbox 
if det(covm) <=0
    % Then it is not a valid covariance matrix.
    errordlg('The covariance matrix must be positive definite','Covariance Error')
	return
end

if ~isequal(covm,covm')
	% Then it is not symmetric
	errordlg('The covariance matrix must be symmetric.','Covariance Error')
	return
end

mu = mu(:); % Just in case it is not a column vector.
d = length(mu);
% get cholesky factorization of covariance
R = chol(covm);
%R = sqrt(covm);
% generate the standard normal random variables
Z = randn(n,d);
X = Z*R + ones(n,1)*mu';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	VIEW CURRENT MEANS IN COMMAND WINDOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function viewmeans(H)
mus = H.means;
[ndim,ncomp] = size(mus);

for i = 1:ncomp
    disp('HIT ANY KEY TO CONTINUE...')
    disp(['The mean for component ' int2str(i) ' is:'])
    disp(mus(:,i)')
    pause
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	VIEW CURRENT COVARIANCES IN COMMAND WINDOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function viewcovs(H)
covs = H.covms;
ncomp = get(H.ncomp,'value');

for i = 1:ncomp
    disp('HIT ANY KEY TO CONTINUE ...')
    disp(['The covariance for component ' int2str(i) ' is:'])
    disp(covs(:,:,i))
    pause
end

