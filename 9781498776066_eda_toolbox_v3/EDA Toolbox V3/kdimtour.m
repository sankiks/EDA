function kdimtour(x,maxit,k,type)

% KDIMTOUR    Grand Tour in k Dimensions - Torus Winding Algorithm
%
% KDIMTOUR(X, MAXIT, K, TYPE)
% This implements the torus winding grand tour of Asimov. The
% input is the data matrix X. MAXIT specifies the maximum number
% of iterations. The input argument K specifies the number of dimensions. 
% The optional argument TYPE specifies the type of display:
%   'a' produces Andrews' curves
%   'p' produces parallel coordinate plots (default)

% Fixed bug - May 21, 2005. This did not really implement correctly for k less
% than p. 

if nargin == 3
    type = 'p';
end
[n,p] = size(x);
if k > p
    error('K must be less than the number of dimensions')
end
if k == 1
    error('K must be greater than 1')
end
% Set up vector of frequencies.
N = 2*p - 3;
lam = mod(exp(1:N),1);
% This is a small irrational number:
delt = exp(1)^(-3); 
% Get the indices to build the rotations.
J = 2:p;
I = ones(1,length(J));
I = [I, 2*ones(1,length(J)-1)];
J = [J, 3:p];
E = eye(p,k);   % Basis vectors

% Get the figure. 
figure
set(gcf,'backingstore','off','renderer','painters','DoubleBuffer','on')
H = uicontrol(gcf,'style','text',...
    'units','normalized',...
    'position',[0.01 0.01 0.2 0.075],...
    'string','Iteration: ');
% Set up the line handles - need n of these
Hline = zeros(1,n);
for i = 1:n
    Hline(i) = line('xdata',nan,'ydata',nan,'linestyle','-');
end
% Start the tour.
if strcmp(type,'p')
    % get the axes lines
    kk = k;
    ypos = linspace(0,1,kk);
    xpos = [0 1];
    for i=1:kk            
        line(xpos,[ypos(i) ypos(i)],'color','k')
        text(-0.05,ypos(i), ['x' num2str(kk)] )
        kk=kk-1;
    end
    axis off
    for K = 1:maxit
        % Find the rotation matrix.
        Q = eye(p);
        for j = 1:N
            dum = eye(p);
            dum([I(j),J(j)],[I(j),J(j)]) = cos(lam(j)*K*delt);
            dum(I(j),J(j)) = -sin(lam(j)*K*delt);
            dum(J(j),I(j)) = sin(lam(j)*K*delt);
            Q = Q*dum;
        end
        % Rotate basis vectors.
        A = Q*E;
        % Project onto the new basis vectors.
        z = x*A;    
        parallel(Hline,z);
        set(H,'string',['Iteration: ',int2str(K)])
        pause(0.075)
    end
else
    theta = -pi:0.1:pi;    %this defines the domain that will be plotted
    y = zeros(n,k);       %there will n curves plotted, one for each obs
    ang = zeros(length(theta),k);   %each row must be dotted w/ observation
    % Get the string to evaluate function.
    fstr = ['[1/sqrt(2) '];   %Initialize the string.
    for i = 2:k
        if rem(i,2) == 0
            fstr = [fstr,' sin(',int2str(i/2), '*i) '];
        else
            fstr = [fstr,' cos(',int2str((i-1)/2),'*i) '];
        end
    end
    fstr = [fstr,' ]'];
    kk=0;
    % evaluate sin and cos functions at each angle theta
    for i=theta
        kk=kk+1;
        ang(kk,:)=eval(fstr);
    end
    for K = 1:maxit
        % Find the rotation matrix.
        Q = eye(p);
        for j = 1:N
            dum = eye(p);
            dum([I(j),J(j)],[I(j),J(j)]) = cos(lam(j)*K*delt);
            dum(I(j),J(j)) = -sin(lam(j)*K*delt);
            dum(J(j),I(j)) = sin(lam(j)*K*delt);
            Q = Q*dum;
        end
        % Rotate basis vectors.
        A = Q*E;
        % Project onto the new basis vectors.
        z = x*A;    
        axis off
        andrews(Hline,z,theta,ang);
        set(H,'string',['Iteration: ',int2str(K)])
        pause(0.075)
    end
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function parallel(Hline,x)

% If parallel coordinates, then change range.
% map all values onto the interval 0 to 1
% lines will extend over the range 0 to 1
md = min(x(:)); % find the min of all the data
rng = range(x(:));  %find the range of the data
xn = (x-md)/rng;
[n,p] = size(x);
ypos = linspace(0,1,p);
for i=1:n
    %     line(x(i,:),fliplr(ypos),'color','k')
    set(Hline(i),'xdata',xn(i,:),'ydata',fliplr(ypos))
end    

