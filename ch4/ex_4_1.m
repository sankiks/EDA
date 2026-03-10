addpath('C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3')
load yeast

[n,p] = size(data);
%set up vector of frequencies
N= 2*p -3;

%use second option from above
lam=mod(exp(1:N),1);
% This is a small irrational number:
delt = exp(-5);
% Get the indices to build the rotations.
% As in step 1 of the torus method.
J = 2:p;
I = ones(1,length(J));
I = [I, 2*ones(1,length(J)-1)];
J = [J, 3:p];
E = eye(p,2);   % Basis vectors
% Just do the tour for some number of iterations.
maxit = 2150;
% Get an initial plot.
z = zeros(n,2);
ph = plot(z(:,1),z(:,2),'o','erasemode','normal');
axis equal, axis off
% Use some Handle Graphics to remove flicker.
set(gcf,'backingstore','off','renderer',...
'painters','DoubleBuffer','on')
% Start the tour.
for k = 1:maxit
    % Find the rotation matrix.
    Q = eye(p);
    for j = 1:N
        dum = eye(p);
        dum([I(j),J(j)],[I(j),J(j)]) = cos(lam(j)*k*delt);
        dum(I(j),J(j)) = -sin(lam(j)*k*delt);
        dum(J(j),I(j)) = sin(lam(j)*k*delt);
        Q = Q*dum;
    end
    % Rotate basis vectors.
    A = Q*E;
    
%Project onto the new basis vectors.
z= data*A;
% Plot the transformed data.
    set(ph,'xdata',z(:,1),'ydata',z(:,2))
% Forces Matlab to plot the data.
    pause(0.02)
end