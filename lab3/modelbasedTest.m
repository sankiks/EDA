x = linspace(-6,6,250);
y = linspace(-6,6,250);
[X,Y] = meshgrid(x,y);

sigma = 2;  % isotropic -> circles
Z = (1/(2*pi*sigma^2)) * exp(-(X.^2 + Y.^2)/(2*sigma^2));

surf(X,Y,Z); shading interp
hold on
contour3(X,Y,Z,20,'k')   % these contour lines are circles
hold off
xlabel('x'); ylabel('y'); zlabel('pdf height');
view(45,30); grid on