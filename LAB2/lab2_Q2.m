load nips12raw_str602.mat

Xco=full(counts);
%Xco=counts';

d = 2;
dpca = 3;
perp = 30;
ydata = tsne(Xco', 'numDimensions' , d,'NumPCAComponents', dpca,'Perplexity', perp);
scatter(ydata(:,1), ydata(:,2), 10, 'filled');
title('t-SNE of NIPS papers');
xlabel('Dim 1'); ylabel('Dim 2');

% label a few points (labeling all 1740 will be unreadable)
idx = randperm(size(ydata,1), 25);
text(ydata(idx,1), ydata(idx,2), anames(idx), 'FontSize', 8);
figure();
snedata=sne(Xco',d,perp);
scatter(snedata(:,1), snedata(:,2));
title('SNE of NIPS papers');
xlabel('Dim 1'); ylabel('Dim 2');
idx = randperm(size(snedata,1), 25);
text(snedata(idx,1), snedata(idx,2), anames(idx), 'FontSize', 8);