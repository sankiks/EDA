% Make a sieve plot    sieve(data,flag)
%   sieve(data,flag)
%
% The SIEVE plot is a mosaic-type plot where the areas of 
% the boxes correspond to the EXPECTED frequencies.
%
% The OBSERVED frequencies are input as DATA.
%
% Providing any value to the optional FLAG argument adds box labels
% The default is to not label each box with the observed frequency.
%
% The Pearson residuals are calculated.
% If the residuals are negative, then the box(es) are shown as
% red dashed lines. If they are positive, then they are shown
% with blue solid lines.
% 
%

% This is based in part on the mosaic_plot function at MATLAb Central.

 
function [xm,ym] = sieve(data,flag)


if min(data(:)) < 0
    error('Input data has to be non-negative');
end

% Get the marginals. This will be used in the expected
% frequencies.
Jmarg = sum(data);  % column marginal
Imarg = sum(data,2);  % Row marginal

% convert to strings for labels.
% Plot the observed frequencies in 
% a sieve plot.
dataf = flipud(data);   % to get in the right format.
L = cellstr(int2str(dataf(:)));

% Get the expected frequencies
n = sum(sum(data));
[nr,nc] = size(data);
Ef = zeros(nr,nc);
for i=1:nr
    for j = 1:nc
        Ef(i,j) = Imarg(i)*Jmarg(j)/n;
    end
end

% Get the Pearson residuals
Pr = (data - Ef)./sqrt(Ef);
Prf = flipud(Pr);

% % Redo the marginals based on the box size.
% % I think I need to use the EXPECTED freqs here
% % Not the observed, because the dimensions of the
% % sub-boxes are from the expected frequencies.
% % The sides of the boxes are given by the marginals
% % which in this case are from the expected freqs.
% Jmarg = sum(Ef);  % column marginal
% Imarg = sum(Ef,2);  % Row marginal


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Grid preparation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the number of sub-boxes on each side.
% Use the large one for the sides of sub-boxes.
% The general formula is
%   a1 = sqrt(obs*Jmarg/Imarg)
%   a2 = sqrt(obs*Imarg/Jmarg)
% for i = 1:nr
%     for j = 1:nc
%         i,j
%         a1(i,j) = sqrt(data(i,j)*Jmarg(i)/Imarg(j));
%         a2(i,j) = sqrt(data(i,j)*Imarg(j)/Jmarg(i));
%     end
% end

for i = 1:length(Jmarg)
    for j = 1:length(Imarg)
        k = j;
        m = i;
        a1(i,j) = sqrt(data(k,m)*Jmarg(i)/Imarg(j));
        a2(i,j) = sqrt(data(k,m)*Imarg(j)/Jmarg(i));
    end
end

% Flip these two matrices.
a1 = flipud(a1);
a2 = flipud(a2);


% Get the stuff needed to create the cell boxes.
% This little piece was from the mosaic_plot function.
% xs=sum(data);
% xs=xs/sum(xs);
% ys=data*diag(1./sum(data));

% NOTE - SIEVE plot shows area of boxes as EXPECTED freqs
% xs=sum(Ef);
% xs=xs/sum(xs);
% ys=Ef*diag(1./sum(Ef));

Eff = flipud(Ef);

xs=sum(Eff);
xs=xs/sum(xs);
ys=Eff*diag(1./sum(Eff));

gap=min([xs(:); ys(:)])/4;
gap=min([gap,0.01]);

xs=[0 cumsum(xs)];
ys=cumsum(ys);
ys=[zeros(1,size(ys,2)); ys];



for id=1:length(xs)-1
   
   % This first loops over the column rectangles, builds
   % the boxes up by the bottom up.
   sieve_rectangles(xs(id),xs(id+1),ys(:,id),gap,Prf(:,id),...
       dataf(:,id)); 
end

% 
% for id=1:length(xs)-1
%    sieve_rectangles(xs(id),xs(id+1),ys(:,id),gap); 
% end

ym=diff(ys)/2+ys(1:end-1,:);
xm=diff(xs)/2+xs(1:end-1);
xm=ones(size(ym,1),1)*xm;


% Plot labels - observed frequencies.
if exist('flag','var')
    multi_text(xm(:),ym(:),L);
end


