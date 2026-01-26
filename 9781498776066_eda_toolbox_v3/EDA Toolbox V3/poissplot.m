function cspoissplot(k, n_k, mod_flag)
% POISSPLOT Construct a Poissonness plot.
%
%   POISSPLOT(K, NK,FLAG) Constructs a Poissonness plot, which
%   is used to graphically determine whether the observed
%   counts follow a Poisson distribution. The inputs to the
%   function are a vector of counts K and the frequency of
%   occurrence NK.
%
%   An optional input argument FLAG = 1 specifies a modified
%   Poissonness plot where the NK are modified to account for
%   variability in the individual values. One can think of this
%   as a robust version. The default is to construct the basic
%   unmodified version.
%
%   EXAMPLE:
%
%   k = 0:6;
%   n_k = [156 63 29 8 4 1 1];
%   poissplot(k,n_k)    % Plots the unmodified version.
%
%   poissplot(i,n)_k,1) % Plots the modified version.


%  Martinez, Martinez, and Solka, 6/20/2016
%   Exploratory Data Analysis Toolbox


if nargin == 2
    % Then there is no input flag, so do the basic verion.
    
    % poissoness plot - basic
    N=sum(n_k);
    % get vector of factorials
    fact=zeros(size(k));
    for i=k
        fact(i+1)=factorial(i);
    end
    % get phi(n_k) for plotting
    phik=log(fact.*n_k/N);
    % find the counts that are equal to 1
    % plot these with the symbol 1
    % plot rest with a symbol
    ind=find(n_k~=1);
    plot(k(ind),phik(ind),'o')
    ind=find(n_k==1);
    if ~isempty(ind)
        text(k(ind),phik(ind),'1')
    end
    % add some whitespace to see better
    axis([-0.5 max(k)+1 min(phik)-1 max(phik)+1])
    xlabel('Number of Occurrences - \it x')
    ylabel('\it \phi (n_x )')
    
else
    
    % do the modified version.
    % Poissonness plot - modified
    N = sum(n_k);
    phat = n_k/N;
    nkstar = n_k-0.67-0.8*phat;
    % Get vector of factorials.
    fact = zeros(size(k));
    for i = k
        fact(i+1) = factorial(i);
    end
    % Find the frequencies that are 1; nkstar=1/e.
    ind1 = find(n_k==1);
    nkstar(ind1)= 1/2.718;
    % Get phi(n_k) for plotting.
    phik = log(fact.*nkstar/N);
    ind = find(n_k~=1);
    plot(k(ind),phik(ind),'o')
    if ~isempty(ind1)
        text(k(ind1),phik(ind1),'1')
    end
    % Add some white space to see better.
    axis([-0.5 max(k)+1 min(phik)-1 max(phik)+1])
    xlabel('Number of Occurrences - \it x')
    ylabel('\it \phi (n^*_x )')
end



