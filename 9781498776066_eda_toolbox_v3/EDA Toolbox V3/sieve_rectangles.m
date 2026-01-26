% function sieve_rectangles(x1,x2,ys,gap,Pr,a1,a2,data)
function sieve_rectangles(x1,x2,ys,gap,Pr,data)

% The argument Pr is the Pearson residuals.
% The argument a1 and a2 are the number of boxes
% on each side of the ij-th rectangle.
% 

if ~exist('gap','var')
    gap=0.01;
end

% The following works for the sieve plot.

g2=gap/2;

% keyboard

% Set the x values for the vertices of the rectangle.
% These are the same for each vertical box.
xtmp=[x1+g2, x2-g2, x2-g2, x1+g2, x1+g2];

% The width of the box is xtmp(2) - xtmp(1);
w = xtmp(2) - xtmp(1);

hold on;
for id=1:length(ys)-1
   
   ytmp=[ys(id)+g2, ys(id)+g2, ys(id+1)-g2, ys(id+1)-g2, ys(id)+g2];
   % The height is ytmp(3) - ytmp(2);
   h = ytmp(3) - ytmp(2);
   
%    a1R = round(a1);
%    a2R = round(a2);
%    
%    xg = linspace(xtmp(1),xtmp(2),a2R(id)+1);
%    yg = linspace(ytmp(2),ytmp(3),a1R(id)+1);

   
%    d = w/a1(id);
   
   % Find the larger value a1 or a2.   
   % Find the larget value h or w.
   % d is found using the larger ones.
   
%    if w > h
%        d = w/a1(id)
%    else
%        d = h/a2(id)
%    end
%    
%    if a1(id) > a2(id)
%        if w > h
%            d = w/a1(id);
%        else
%            d = h/a1(id);
%        end
%    else
%        if w > h
%            d = w/a2(id);
%        else
%            d = h/a2(id);
%        end
%    end
   


   % Get the grids in both directions.
   d = sqrt(w*h/data(id));
   
   xg = [xtmp(1):d:xtmp(2),xtmp(2)];
   yg = [ytmp(2):d:ytmp(3),ytmp(3)];

%    keyboard

%    xg = linspace(xtmp(1),xtmp(2),round(a2(id))+1);
%    dtmp = diff(xg);
%    d = dtmp(1);
%    yg = [ytmp(2):d:ytmp(3),ytmp(3)];
      
   if Pr(id) < 0
       plot(xtmp,ytmp,'r-');
       [X,Y] = meshgrid(xg,yg);
       plot(X,Y,'r--')
       [X,Y] = meshgrid(yg,xg);
       plot(Y,X,'r--')
   else
       plot(xtmp,ytmp,'b-')
       [X,Y] = meshgrid(xg,yg);
       plot(X,Y,'b-')
       [X,Y] = meshgrid(yg,xg);
       plot(Y,X,'b-')
   end

end
hold off



    

