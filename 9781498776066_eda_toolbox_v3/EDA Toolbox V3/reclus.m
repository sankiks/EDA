function reclus(cluslabs,trulabs,str,thresh)

% Rectangle cluster plot - any clustering method - any dimensionality of the data.
%
%       RECLUS(CLABS,TRULABS,STRENGTH,THRESH)
%
%   This can be used to plot the results of any clustering algorithm
%   (k-means, agglomerative, model-based clustering), where the
%   input is the cluster labels (CLABS) for each data point.
%
%   RECLUS(CLABS) plots the rectangles, where the area of each
%   rectangle represents the proportion of points falling into that
%   cluster. The data are plotted using their observation number.
%
%   RECLUS(CLABS,TRULABS) plots the rectangles as before, but the
%   position of the symbols as case labels matches the same position when
%   the true class labels are used as the plotting symbol - see the options below for 
%   3 or 4 arguments. This allows the user to see which cases correspond to specific 
%   symbols plotted with the true class label.
%
%   RECLUS(CLABS,TRULABS,STRENGTH) plots the rectangles as above, where each
%   symbol color represents a measure of the STRENGTH of cluster membership.
%   This could be the P(X|cluster) (obtained from MIXCLASS: 1 - ERR) or it could be
%   the silhouette value from SILHOUETTE. A colorbar is included to 
%   indicate the color scale. 
%
%   RECLUS(CLABS,TRULABS,STRENGTH,THRESH) plots the points as above. The value
%   THRESH is used to indicate which observations have a classification certainty
%   greater than THRESH; these values are plotted in bold. Thus, the color indicates
%   the probability that it belongs to the cluster on a continuous scale, and the bold
%   indicates a binary value - above or below THRESH - in the case of finite 
%   mixture clustering.

%   Model-based Clustering Toolbox, January 2003
%   Revised 4 - 2004 to include silhouette and probability values instead of 'error'.

%   Revised 8/13/02 to show the same position for cases in all views - whether plotted with
%   the case number or the class number. See lines 249 - 258.
%   Revised 8/14/02 because the other one did not work. Changed the 1 argument case back to
%   what it was before. The two argument case now plots as case labels, but with the same
%   positions as the plots with class labels (3 or 4 arguments).

% Algorithm:
% 0. Set up the parent rectangle. Note that we will split on the longer side of 
%   the rectangle according to the proportion that is in each group.
% 1. Find all of the points in each cluster and the corresponding proportion.
% 2. Order the proportions - ascending.

% FIRST FIND ALL OF THE RECTANGLES
% 3. Partition the proportions into 2 groups. If there are an odd number of clusters,
%   then put more of the clusters into the 'left/lower' group.
% 4. Based on the total proportion in each group, split the longer side of the parent
%   rectangle. We now have two children. 
% NOTE: We have to normalize the proportions based on the parent.
% 5. Get the coordinates of the child rectangles. If it is a rectangle with only one
%   class in it, then save the cluster label with it.
% 6. Repeat steps 3 through 5 until all rectangles represent only one cluster.

% NOW FIND THE POINTS IN EACH CLUSTER - PLOT
% 7. Find all of the points in each of the clusters.
% 8. Use meshgrid to find a regular mesh to plot them in. Plot the points in ascending
%   order of the labels or observation numbers.
% 9. Use 'text' to plot - save the handles. 

% NOW DO THE COLOR CODING.
% 10. The color will have to be mapped into the colormap.
%   We will have to manually create the colorbar and map the indices into the
%   color matrix. NOTE: We will use the default MATLAB color map (jet), but invert
%   it so red corresponds to highly uncertain and blue to highly certain (use flipud).
% 11. Then get the observations whose uncertainty is above the value in THRESH and 
%   change the fontweight to bold.

% START THE PROGRAMMING .....

% 0. Set up the parent rectangle. Note that we will split on the longer side of 
%   the rectangle according to the proportion that is in each group.
clus(1).x = 0;      % This is the x,y coordinates of the lower left corner of the rectangle
clus(1).y = 0;
clus(1).w = 100;
clus(1).h = 50;

% 1. Find all of the points in each cluster and the corresponding proportion.
n = length(cluslabs);   % number of data points.
uniqlabs = unique(cluslabs);
nc = length(uniqlabs);  % get the number of clusters
prop = zeros(1,nc);     % find the proportion in each one
for i = 1:nc
    ind = find(cluslabs==uniqlabs(i));
    prop(i) = length(ind)/n;
end

% 2. Order the proportions - ascending.
[sprop,ind] = sort(prop);
% sort the uniqlabs according to this sort order, so we keep the correpondence between
% proportion and the cluster label.
uniqlabs = uniqlabs(ind);
% store these proportions in the rectangle.
clus(1).prop = sprop;
% This will contain all of the cluster labels corresponding to the proportions.
clus(1).label = uniqlabs;  
% Set up a vector of indices to rectangles that still need splitting.
% note that these point to the records in the structure.
spliti = 1;

% For later plotting, keep a vector of indices to the final rectangles
% in the structure.
frect = [];

% PARTITION THE RECTANGLES INTO CHILDREN
% 3. Partition the proportions into 2 groups. If there are an odd number of clusters,
%   then put more of the clusters into the 'left/lower' group.
while ~isempty(spliti)
    % Split the remaining rectangles into children.
    ns = length(spliti);
    newsplit = [];      % use to store indices of rectangles that still need splitting.
    for i = 1:ns
        % split each one. Get the indices to these new rectangles.
        Li = length(clus) + 1;  
        Ri = Li + 1;
        % get the index to the parent that we are splitting
        pari = spliti(i);
        % get the information about the parent.
        propp = clus(pari).prop;
        xp = clus(pari).x;
        yp = clus(pari).y;
        wp = clus(pari).w;
        hp = clus(pari).h;
        labp = clus(pari).label;
        % Split the proportions.
        nL = ceil(length(propp)/2);   % tells how many in the lower/left child
        clus(Li).prop = propp(1:nL);
        clus(Ri).prop = propp((nL+1):end);
        % put these into the structure fields.
        % NOTE: We have to normalize the proportions based on the parent!!
        propleft = sum(clus(Li).prop)/sum(propp);
        propright = sum(clus(Ri).prop)/sum(propp);
        clus(Li).label = labp(1:nL);
        clus(Ri).label = labp((nL+1):end);
        if length(clus(Li).prop) > 1
            % then will have to split on the next round.
            newsplit = [newsplit Li];
        else    % it is a final rectangle.
            frect = [frect Li];
        end
        if length(clus(Ri).prop) > 1
            % then have to split on next round.
            newsplit = [newsplit Ri];
        else    % it is a final rectangle.
            frect = [frect Ri];
        end
        % split based on the longer dimension
        if wp > hp
            % Then split on the x dimension.
            % Get the left child.
            % Lower left corner is the same.
            % Height is the same.
            clus(Li).x = xp;
            clus(Li).y = yp;
            clus(Li).h = hp;
            % width is proportional to the size
            clus(Li).w = wp*propleft;
            % Get the right child.
            % Lower left corner is offset in x from parent.
            % Height is the same. Y coordinate is the same.
            clus(Ri).x = xp+wp*propleft;
            clus(Ri).y = yp;
            clus(Ri).h = hp;
            % width is proportional to the size
            clus(Ri).w = wp*propright;
        else
            % Then split on the y dimension.
            % Get the left child.
            % Lower left corner is the same.
            % Width is the same.
            clus(Li).x = xp;
            clus(Li).y = yp;
            clus(Li).w = wp;
            % Height is proportional to the size
            clus(Li).h = hp*propleft;
            % Get the right child.
            % x coordinate is the same.
            clus(Ri).x = xp;
            % y is offset from left child.
            clus(Ri).y = yp + hp*propleft;
            % height is proportional to size
            clus(Ri).h = hp*propright;
            % width is the same
            clus(Ri).w = wp;
        end
    end         % For i equals the rectangles that need to be split.
    % reset the vector of pointers to the rectangles that need splitting.
    spliti = newsplit;

end     % while loop

% NOW FIND THE POINTS IN EACH CLUSTER - PLOT
% 7. Find all of the points in each of the clusters.
% 8. Use meshgrid to find a regular mesh to plot them in. Plot the points in ascending
%   order of the labels or observation numbers.
% 9. Use 'text' to plot - save the handles. 

% First find the regular mesh to plot the points.        
for i = 1:length(frect)
    flab = clus(frect(i)).label;
    xf = clus(frect(i)).x;
    yf = clus(frect(i)).y;
    wf = clus(frect(i)).w;
    hf = clus(frect(i)).h;
    % Find the number of points that are in this class.
    inds = find(cluslabs == flab);
    npts = length(inds);
    fac(1) = floor(sqrt(npts));
    fac(2) = ceil(npts/fac(1));  % this should give more points than what we need.
    % Put more points in the longer dimension.
    [mf,imax] = max(fac);
    [mf,imin] = min(fac);
    if wf > hf
        xpts = linspace(xf, xf + wf, fac(imax) + 2);
        ypts = linspace(yf, yf + hf, fac(imin) + 2);
    else
        xpts = linspace(xf, xf + wf, fac(imin) + 2);
        ypts = linspace(yf, yf + hf, fac(imax) + 2);
    end
    % now we need to throw out the first and last points - on the edges of the rectangle.
    xpts([1,end]) = [];
    ypts([1,end]) = [];
    % NOw get the meshgrid.
    [Xf, Yf] = meshgrid(xpts, ypts);
    Xf = flipud(Xf);
    Yf = flipud(Yf);
    % make them into column vectors and keep only npts of them.
    Xf = Xf(:);
    Yf = Yf(:);
    if length(Xf) > npts    
        Xf((npts+1):end) = [];
        Yf((npts+1):end) = [];
    end
    % store the stuff in there to plot later on.
    clus(frect(i)).xpts = Xf;
    clus(frect(i)).ypts = Yf;
    % store the indices to points that belong in the cluster.
    clus(frect(i)).inds = inds;
end

% NOW DO THE PLOTTING

switch nargin
    
case 1
    % this one is just to plot the symbols as text corresponding to the 
    % observation number.
    Htxt = [];
    t = (1:n)';
    plotsym = cellstr(num2str(t));  % creates a char array for plotting.
    % do the plotting
    figure
    axis([0 100 0 50])
    rectangle('Position',[clus(1).x clus(1).y clus(1).w clus(1).h])
    for i = 1:length(frect)
        ti = frect(i);
        rectangle('Position',[clus(ti).x clus(ti).y clus(ti).w clus(ti).h])
        text( clus(ti).xpts, clus(ti).ypts, plotsym(clus(ti).inds) );
    end
    set(gca,'ticklength',[0 0],'xticklabel','','yticklabel','')
    title('Case Numbers')
    
case 2
    % this one is just to plot the symbols as text corresponding to the 
    % observation number.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Revsions 8 - 14- 02
    % For the 2 argument case, plot as case numbers, but the posiitons
    % would correspond to the same ordering as the class label positions.
    Htxt = [];
    t = (1:n)';
    plotsym = cellstr(num2str(t));  % creates a char array for plotting.
    % do the plotting
    figure
    axis([0 100 0 50])
    rectangle('Position',[clus(1).x clus(1).y clus(1).w clus(1).h])
    for i = 1:length(frect)
        ti = frect(i);
        % Revise to have positions match with class labels and case labels
        % 8/13/02
        temp = trulabs(clus(ti).inds);   % true labels to plot here
        [ts,isort] = sort(temp);  % sort them
        rectangle('Position',[clus(ti).x clus(ti).y clus(ti).w clus(ti).h])  % not changed
        % changed inds to show the same sort order as the class labels.
        % old one: text( clus(ti).xpts, clus(ti).ypts, plotsym(clus(ti).inds) );
        text( clus(ti).xpts, clus(ti).ypts, plotsym(clus(ti).inds(isort) ) );
        % end of revision
    end
    set(gca,'ticklength',[0 0],'xticklabel','','yticklabel','')
    title('Case Numbers')

case 3
    % Plot with the true class labels.
    if length(cluslabs) ~= length(trulabs)
        error('Length of cluslabs must equal length of trulabs')
    end
	% get the colormap - 16 colors.
	map = jet(16);
	map = flipud(map);

    % do the plotting.
    figure
    axis([0 100 0 50])
	axis off
    set(gcf,'color',[.70 .7 .5])
    rectangle('Position',[clus(1).x clus(1).y clus(1).w clus(1).h])
    if isempty(find(str < 0))
        % then there are no negative values
        cmin = 0; cmax = 1;
    else
        cmin = -1; cmax = 1;
    end
    for i = 1:length(frect)
        ti = frect(i);
        % sort the true cluster labels.
        temp = trulabs(clus(ti).inds);   % true labels to plot here
        tmperr = str(clus(ti).inds);
       
        % sort them by true class labels.
        [ts,indsort] = sort(temp);  
        % sort the error based on this.
        tmp = tmperr(fliplr(indsort));
        
        plotsym = cellstr(num2str(ts(:)));
        rectangle('Position',[clus(ti).x clus(ti).y clus(ti).w clus(ti).h])
        h = text( clus(ti).xpts, clus(ti).ypts, plotsym );
        % Change the colors according to the strength
        indc = fix((tmp - cmin)*16/(cmax-cmin));
        indc(find(indc <= 0)) = 1;
        indc(find(indc >= 16)) = 16; 
        % Loop through all text objects and change the color.
        for j = 1:length(h)
            set(h(j), 'color', map(indc(j),:))
        end
        
    end
    H = colorbar;
    colormap(flipud(jet))
	L = linspace(cmin,cmax,8);
	Ls = cellstr(num2str(L','%0.1f'));
	Ls([1,end]) = [];
	set(H,'yticklabel',Ls)
    title({'True Class Label'})
    
case 4
    % Plot with the color bar and the error threshold.

	    % Plot with the true class labels.
    if length(cluslabs) ~= length(trulabs)
        error('Length of cluslabs must equal length of trulabs')
    end
	% get the colormap - 16 colors.
	map = jet(16);
	map = flipud(map);
    % do the plotting.
    figure
    axis([0 100 0 50])
    axis off
    set(gcf,'color',[.70 .7 .5])
    rectangle('Position',[clus(1).x clus(1).y clus(1).w clus(1).h])
    if isempty(find(str < 0))
        % then there are no negative values
        cmin = 0; cmax = 1;
    else
        cmin = -1; cmax = 1;
    end
    for i = 1:length(frect)
        ti = frect(i);
        % sort the true cluster labels.
        temp = trulabs(clus(ti).inds);   % true labels to plot here
        tmperr = str(clus(ti).inds);
%         tmperr = 1 - str(clus(ti).inds);
        
        % sort them by true class labels.
        [ts,indsort] = sort(temp); %added
        tmp = tmperr(fliplr(indsort));
        
        plotsym = cellstr(num2str(ts(:)));
        rectangle('Position',[clus(ti).x clus(ti).y clus(ti).w clus(ti).h])
        h = text( clus(ti).xpts, clus(ti).ypts, plotsym );
		% Change the colors according to the strength
        % Change the colors according to the strength
        indc = fix((tmp - cmin)*16/(cmax-cmin));
        indc(find(indc <= 0)) = 1;
        indc(find(indc >= 16)) = 16; 
		% Loop through all text objects and change the color.
		for j = 1:length(h)
			set(h(j), 'color', map(indc(j),:))
			if tmp(j) >= thresh
                set(h(j),'fontweight','bold','color','k')
            end
		end
    end
	H = colorbar;
	colormap(flipud(jet))
	L = linspace(cmin,cmax,8);
	Ls = cellstr(num2str(L','%0.1f'));
	Ls([1,end]) = [];
	set(H,'yticklabel',Ls)
    title({['True Class Label - Thresh is ' num2str(thresh)]})
	
otherwise
    error('Incorrect number of input arguments')
    
end












