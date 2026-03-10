x = linspace(-6,6,250);
y = linspace(-6,6,250);
[X,Y] = meshgrid(x,y);
mu1=2;
mu2=-2;

sigma1 = 0.5;
sigma2 = 1.2;

y1 = normpdf(x,mu1,sigma1);
y2 = normpdf(x,mu2,sigma2);
ys=y1+y2;
sigma = 2;  % isotropic -> circles
%Z = (1/(2*pi*sigma^2)) * exp(-(X.^2 + Y.^2)/(2*sigma^2));
Z= ys'* y;
surf(X,Y,Z); 
hold on
contour3(X,Y,Z)   % these contour lines are circles
hold off
xlabel('x'); ylabel('y'); zlabel('pdf height');
view(45,30); grid on