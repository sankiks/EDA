function [X,S,dhats] = nmmds(dissim,d,r)

% NMDS  Kruskal's Non-Metric MDS
%
% [X, STRESS,DHAT] = NMMDS(DISSIM,D,R)
% Implements the non-metric MDS from Kruskal's orignal 1964 paper. The
% inputs are a vector of dissimilarities (DISSIM), containing the upper
% triangular part of an interpoint distance matrix, similar to what one
% would get from PDIST. The R specifies the Minkowski metric to be used. A
% value of R = 1 gives city-block distance, and R = 2 yields Euclidean. The
% DHAT argument contains the disparaties. D is the number of dimensions in
% the lower-dimensional space.

% Get the sample size, knowing what the length of DISSIM is.
% Let N = length(dissim); We know that we have (p^2 - p)/2 elements, so
% solving for p, we get p^2 - p - 2N = 0. The ROOTS function gives the
% answer. We also know that we must have a positive and negative answer,
% and the one we want is the positive one. :-)
rts = roots([1 -1 -2*length(dissim)]);
n = round(max(rts));
% First check to see if there are any equal dissimilarities. 
[dissim,ind] = sort(dissim);
% Save these indices, because they will be used later on.
disdiff = diff(dissim);
tmpi = find(disdiff==0);
if isempty(tmpi)
    ties = 0;
else
    ties = 1;
end
maxiter = 1000;
tol = 10^(-3);

% Now, depending on the presence of ties, do one of the following.
switch ties
    case 0      % No ties
        % Get an initial configuration and starting stress.
        X = unifrnd(-2,2,n,d);
        alpha = 1;    %0.2;
        X = normalize(X,n);
        % Get the distances
        dists = pdist(X,'minkowski',r);
        % Now impose the same order as dissim's on the distances.
        dists = dists(ind);
        % Get the disparities or dhats
        dhats = isoreg(dists);
        S(1) = stress(dists,dhats);
        % Get the gradient
        Gnew = grad(X,dists,dhats,r);
        GOld = Gnew;    % Just to get started.
        % Terminate when the magG gets to be 2% of this value:
        magG0 = sqrt(sum(Gnew(:).^2)/n);
        % Now start 5 iterations of this
        for i = 2:6
            X = normalize(X,n);
            % Get the distances
            dists = pdist(X,'minkowski',r);
            % Now impose the same order as dissim's on the distances.
            dists = dists(ind);
            % Get the disparities or dhats
            dhats = isoreg(dists);
            S(i) = stress(dists,dhats);
            % Get the gradient
            GOld = Gnew;
            Gnew = grad(X,dists,dhats,r);
            magG = sqrt(sum(Gnew(:).^2)/n);
            alphaold = alpha;
            alpha = alphaup(alphaold,S(1),S(i-1),S(i),Gnew(:),GOld(:));
            % Get a new configuration.
            X = X - alpha*Gnew/magG;
        end
        % Now start the rest of the iterations.
        % Repeat the iterations until one reaches the maximum number of
        % iterations or until the magnitude of the gradient reaches 2% of
        % its original value.
%         dG = magG/magG0;
        dstress = S(i) - S(i-1);
        while i <= maxiter & magG > tol  & dstress ~= 0
            i = i + 1
            X = normalize(X,n);
            % Get the distances
            dists = pdist(X,'minkowski',r);
            % Now impose the same order as dissim's on the distances.
            dists = dists(ind);
            % Get the disparities or dhats
            dhats = isoreg(dists);
            S(i) = stress(dists,dhats);
            % Get the gradient
            Gnew = grad(X,dists,dhats,r);
            magG = sqrt(sum(Gnew(:).^2)/n);
%             dG = magG/magG0;
            dstress = S(i) - S(i-1);
            alphaold = alpha;
            alpha = alphaup(alphaold,S(i-5),S(i-1),S(i),Gnew(:),GOld(:));
            % Get a new configuration.
            X = X - alpha*Gnew/magG;
        end
     
    case 1      % Presence of ties
        % get the indices for blocks where there are ties.
        % Only need to get this one time.
        tieblocks = eqdissim(dissim);
        % Get an initial configuration
        X = unifrnd(-2,2,n,d);
        X = normalize(X,n);
        alpha = 1;    %0.2;
        % Get the distances
        dists = pdist(X,'minkowski',r);
        % Now impose the same order as dissim's on the distances.
        dists = dists(ind);
        % Re-arrange the dists in each tie-block - each iteration.
        for j = 1:length(tieblocks)
            dists(tieblocks{j}) = sort(dists(tieblocks{j}));
        end
        % Get the disparities or dhats
        dhats = isoreg(dists);
        S(1) = stress(dists,dhats);
        % Get the gradient
        Gnew = grad(X,dists,dhats,r);
        GOld = Gnew;    % Just to get started.
        % Terminate when the magG gets to be 2% of this value:
        magG0 = sqrt(sum(Gnew(:).^2)/n);
        % Now start 5 iterations of this
        for i = 2:6
            X = normalize(X,n);
            % Get the distances
            dists = pdist(X,'minkowski',r);
            % Now impose the same order as dissim's on the distances.
            dists = dists(ind);
            % Re-arrange the dists in each tie-block - each iteration.
            for j = 1:length(tieblocks)
                dists(tieblocks{j}) = sort(dists(tieblocks{j}));
            end
            % Get the disparities or dhats
            dhats = isoreg(dists);
            S(i) = stress(dists,dhats);
            % Get the gradient
            GOld = Gnew;
            Gnew = grad(X,dists,dhats,r);
            magG = sqrt(sum(Gnew(:).^2)/n);
            alphaold = alpha;
            alpha = alphaup(alphaold,S(1),S(i-1),S(i),Gnew(:),GOld(:));
            % Get a new configuration.
            X = X - alpha*Gnew/magG;
        end
        % Now start the rest of the iterations.
        % Repeat the iterations until one reaches the maximum number of
        % iterations or until the magnitude of the gradient reaches 2% of
        % its original value.
%         dG = magG/magG0;
        dstress = S(i) - S(i-1);
        while i <= maxiter & magG > tol  & dstress ~= 0
            i = i + 1
            X = normalize(X,n);
            % Get the distances
            dists = pdist(X,'minkowski',r);
            % Now impose the same order as dissim's on the distances.
            dists = dists(ind);
            % Re-arrange the dists in each tie-block - each iteration.
            for j = 1:length(tieblocks)
                dists(tieblocks{j}) = sort(dists(tieblocks{j}));
            end
            % Get the disparities or dhats
            dhats = isoreg(dists);
            S(i) = stress(dists,dhats);
            % Get the gradient
            Gnew = grad(X,dists,dhats,r);
            magG = sqrt(sum(Gnew(:).^2)/n);
%             dG = magG/magG0;
            dstress = S(i) - S(i-1);
            alphaold = alpha;
            alpha = alphaup(alphaold,S(i-5),S(i-1),S(i),Gnew(:),GOld(:));
            % Get a new configuration.
            X = X - alpha*Gnew/magG;
        end
        
end

function alpha = alphaup(A0,S0,S1,S2,G2,G1);
% S0 is stress 5 iterations ago
% S1 is previous stress
% S2 is present stress
% G2 is present gradient
% G1 is previous gradient
% A0 is previous alpha;
costheta = G2'*G1/(sqrt(G2'*G2)*sqrt(G1'*G1));
angfac = 4^(costheta^3);
step5 = min([1,S2/S0]);
gf = min([1,S2/S1]);
rf = 1.3/(1 + step5^5);
alpha = A0*angfac*rf*gf;


function s = stress(dist,dhats)
Sstar = sum(sum((dist - dhats).^2));
Tstar = sum(sum(dist.^2));
s = sqrt(Sstar/Tstar);

function X = normalize(X,n)
% Normalize the configuration to have mean 0 and mean square distance of 1.
X = X - repmat(mean(X),n,1);
x = X(:);
A = sqrt(sum(x.^2)/n);
X = X/A;

% Check...
% The sum of the squares of these should equal n.
% sum(X(:).^2)

function dispars = isoreg(dists)
% This implements isotonic regression as explained in Cox and Cox.
% It assumes the inputs are ordered previously.

N = length(dists);
% Now find the cumulative sums of the distances.
D = cumsum(dists);
% Add the origin as the first point.
D = [0 D];

% Now find the slope of these.
slope = D(2:end)./(1:N);
% Find the points on the convex minorant by looking
% for smallest slopes.
i = 1;
k = 1;
while i <= N
    val = min(slope(i:N));
    minpt(k) = find(slope == val);
    i = minpt(k) + 1;
    k = k + 1;
end

% So far, we've implemented the algorithm in Cox and Cox. However, several
% experiments showed that just looking at the slope does not yield the
% correct partition. So, we also find the convex hull of the points using
% Matlab's function. This also gives points on the 'top' of the curve,
% which we do not need. So, we will find the intersection of the two. The
% vector minpt has some extra points that are not really on the convex
% hull, and K gives us extra points that are on the top. The intersection
% gives us the correct answer.
K = convhull(D, 0:N);
minpt = intersect(minpt+1,K) - 1;

% Now that we have all of the minorant points that divide into blocks, 
% the disparities are the averages of the distances over those blocks.
j = 1;
for i = 1:length(minpt)
    dispars(j:minpt(i)) = mean(dists(j:minpt(i)));
    j = minpt(i) + 1;
end


function tieblocks = eqdissim(dissim)

% EQDISSIM  Finds the indices to tie blocks when some dissimilarities are equal
%
% This is a pre-processing step before isotonic regression in Kruskal's
% nonmetric MDS. If there are equal dissimilarities, then the distances
% must be ordered in a special way. Add a pre-processing step where
% dissimilarities within a tie-block are ordered such that the distances
% within that block are increasing. This function returns the indices to
% the tie-blocks. The tie-blocks do not change during the algorithm, but
% the distances need to be re-ordered based on these at each stage.
% Reference: Kruskal, 1964.

% Sort the dissimilarities
% Now re-order the dissimilarities.
[dissim,ind] = sort(dissim);
% Get the differences between successive elements of the dissim's.
disdiff = diff(dissim);
tmpi = find(disdiff==0);    % This should be indices of equal ones.
tmpi = unique([tmpi, tmpi + 1]);
% Find all of the indices to the tie blocks.
tmpd = diff(tmpi);
tpd = find(tmpd ~= 1);
k = 1; beg = 1;
for i = 1:length(tpd)
    dind{k} = tmpi(beg:tpd(i));
    beg = tpd(i) +1;
    k = k+1;
end
% Now get the last one.
dind{k} = tmpi(beg:end);
tieblocks = dind;

