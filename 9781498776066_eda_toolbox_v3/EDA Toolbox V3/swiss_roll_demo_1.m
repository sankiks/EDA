function swiss_roll_demo_1

% SWISS_ROLL_DEMO_1 uses Isomap, Hessian LLE, LLE to embed a non-convex (but
%   connected) set of 3D swiss roll data in 2D
%   Demo script, no documentation
%   C. Grimes and D. Donoho, March 2003
%   Version 1.0


N=800;
K=12;
d=2; 



tt = (3*pi/2)*(1+2*rand(1,2*N));  height = 21*rand(1,2*N);
kl = repmat(0,1,2*N);
for ii = 1:2*N
    if ( (tt(ii) > 9)&(tt(ii) < 12))
        if ((height(ii) > 9) & (height(ii) <14))
            kl(ii) = 1;
        end;
    end;
end;
kkz = find(kl==0);
tt = tt(kkz(1:N));
height = height(kkz(1:N));
X = [tt.*cos(tt); height; tt.*sin(tt)];

%Run algorithms
% vanilla LLE
Y=lle(X,K,d);
% Hessian LLE
Y2 = HLLE(X,K,d);

%Isomap
options.dims = 1:10;
options.display = 0;

Dsm = L2_distance(X,X,1);
[Ysm, Rsm, Esm] = Isomap(Dsm, 'k', 7, options);

%figure of output
figure;
colormap jet; %set(gcf,'Position',[200,400,620,200]);

subplot(2,2,1);
scatter3(X(1,:),X(2,:),X(3,:),12,tt,'o', 'filled');
title('Original Data');

subplot(2,2,2);
cla;
scatter(Y(1,:),Y(2,:),12,tt,'+');
title('Regular LLE');
axis equal;

subplot(2,2,3);
cla;
scatter(Y2(1,:),Y2(2,:),12,tt,'+');
title('Hessian LLE');
axis equal;

subplot(2,2,4);
cla;
scatter(Ysm.coords{2}(1,:), Ysm.coords{2}(2,:), 12, tt, '+');
title('ISOMAP');
axis equal;