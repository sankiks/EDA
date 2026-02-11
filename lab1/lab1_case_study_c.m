% First, generate a helix data set and plot it.
% The first argument specifies the type of data set.
% The second argument is the number of points, and
% the third governs the amount of noise.
[X] = generate_data('helix',2000,0.01);
plot3(X(:,1),X(:,2),X(:,3),'.')
grid on
% Now find the estimates of intrinsic dimensionality
% that were described in the last three sections.

d_pack = intrinsic_dim(X,'PackingNumbers');

d_pack