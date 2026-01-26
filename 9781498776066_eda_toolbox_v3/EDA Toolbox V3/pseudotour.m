function pseudotour(x,maxit)

% PSEUDOTOUR    Pseudo Grand Tour
%
% PSEUDOTOUR(X, MAXIT)
% This implements the pseudo grand tour of Wegman and Shen. The
% input is the data matrix X. MAXIT specifies the maximum number
% of iterations.

[n,p] = size(x);
if rem(p,2) ~= 0
    % Add zeros to the end.
    x = [x,zeros(n,1)];
    p = p+1;
end
% Set up vector of frequencies.
th = mod(exp(1:p),1);
% This is a small irrational number:
delt = exp(1)^(-5); 
cof = sqrt(2/p);
% Set up storage space for projection vectors.
a = zeros(p,1);
b = zeros(p,1);
z = zeros(n,2);
% Get an initial plot, so the tour can be implemented 
% using Handle Graphics.
ph = plot(z(:,1),z(:,2),'o','erasemode','normal');
axis equal, axis off
set(gcf,'backingstore','off','renderer','painters','DoubleBuffer','on')
H = uicontrol(gcf,'style','text',...
    'units','normalized',...
    'position',[0.01 0.01 0.2 0.1],...
    'string','Iteration: ');
iter = 1;
for t=0:delt:(delt*maxit)
		% Find the transformation vectors.
		for j=1:p/2
			a(2*(j-1)+1)=cof*sin(th(j)*t);
			a(2*j)=cof*cos(th(j)*t);
			b(2*(j-1)+1)=cof*cos(th(j)*t);
			b(2*j)=cof*(-sin(th(j)*t));
		end
		% Project onto the vectors.
		z(:,1)=x*a;
		z(:,2)=x*b;
		set(ph,'xdata',z(:,1),'ydata',z(:,2))
        set(H,'string',['Iteration: ',int2str(iter)])
        drawnow
        iter = iter + 1;
end
