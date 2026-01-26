function torustour(x,maxit)

% TORUSTOUR    Grand Tour - Torus Winding Algorithm
%
% TORUSOTOUR(X, MAXIT)
% This implements the torus winding grand tour of Asimov. The
% input is the data matrix X. MAXIT specifies the maximum number
% of iterations.

[n,p] = size(x);
% Set up vector of frequencies.
N = 2*p - 3;
lam = mod(exp(1:N),1);
% This is a small irrational number:
delt = exp(1)^(-5); 
% Get the indices to build the rotations.
J = 2:p;
I = ones(1,length(J));
I = [I, 2*ones(1,length(J)-1)];
J = [J, 3:p];
E = eye(p,2);   % Basis vectors

% Get an initial plot.
z = zeros(n,2);
ph = plot(z(:,1),z(:,2),'o','erasemode','normal');
axis equal, axis off
set(gcf,'backingstore','off','renderer','painters','DoubleBuffer','on')
H = uicontrol(gcf,'style','text',...
    'units','normalized',...
    'position',[0.01 0.01 0.2 0.1],...
    'string','Iteration: ');
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
    % Project onto the new basis vectors.
    z = x*A;
    set(ph,'xdata',z(:,1),'ydata',z(:,2))
    set(H,'string',['Iteration: ',int2str(k)])
    drawnow
%     pause(0.02)
end
