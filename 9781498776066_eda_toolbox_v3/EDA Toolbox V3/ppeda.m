function [as,bs,ppm] = ppeda(Z,c,half,m,ppi)
% PPEDA Projection pursuit exploratory data analysis.
%
%   [ALPHA,BETA,PPM] = PPEDA(Z,C,HALF,M,PPI)
%
%   This function implements projection pursuit exploratory
%   data analysis using the chi-square index. 
%
%   Z is an n x p matrix of sphered observations.
%   C is the size of the starting neighborhood for each search.
%   HALF is the number of steps without an increase in the index,
%   at which time the neighborhood is halved.
%   M is the number of random starts.
%   PPI tells which index to use: 'CHI' for chi-square index and 'MOM' for
%   moment index.
%
%   This uses the method of Posse. See the M-file for the references.
%
%   See also CSPPSTRTREM

%   References: 
%   Christian Posse. 1995. 'Projection pursuit explortory
%   data analysis,' Computational Statistics and Data Analysis, vol. 29,
%   pp. 669-687.
%   Christian Posse. 1995. 'Tools for two-dimensional exploratory
%   projection pursuit,' J. of Computational and Graphical Statistics, vol 4
%   pp. 83-100

% get the necessary constants
[n,p]=size(Z);
maxiter = 1500;
cs=c;
cstop = 0.0001;
as = zeros(p,1);	% storage for the information
bs = zeros(p,1);
ppm = realmin;

% find the probability of bivariate standard normal over
% each radial box.
fnr=inline('r.*exp(-0.5*r.^2)','r');
ck=ones(1,40);
ck(1:8)=quadl(fnr,0,sqrt(2*log(6))/5)/8;
ck(9:16)=quadl(fnr,sqrt(2*log(6))/5,2*sqrt(2*log(6))/5)/8;
ck(17:24)=quadl(fnr,2*sqrt(2*log(6))/5,3*sqrt(2*log(6))/5)/8;
ck(25:32)=quadl(fnr,3*sqrt(2*log(6))/5,4*sqrt(2*log(6))/5)/8;
ck(33:40)=quadl(fnr,4*sqrt(2*log(6))/5,5*sqrt(2*log(6))/5)/8;

switch ppi
    case 'chi'
        for i=1:m  % m 
            % generate a random starting plane
            % this will be the current best plane
            a=randn(p,1);
            mag=sqrt(sum(a.^2));
            astar=a/mag;
            b=randn(p,1);
            bb=b-(astar'*b)*astar;
            mag=sqrt(sum(bb.^2));
            bstar=bb/mag;
            clear a mag b bb
            % find the projection index for this plane
            % this will be the initial value of the index
            ppimax = csppind(Z,astar,bstar,n,ck);
            % keep repeating this search until the value c becomes 
            % less than cstop or until the number of iterations exceeds maxiter
            mi=0;		% number of iterations
            h = 0;	% number of iterations without increase in index
            c=cs;
            while (mi < maxiter) & (c > cstop)	% Keep searching
                disp(['Iter=' int2str(mi) '  c=' num2str(c) '  Index=' num2str(ppimax) '   i= ' int2str(i)])
                % generate a p-vector on the unit sphere
                v=randn(p,1);
                mag=sqrt(sum(v.^2));
                v1=v/mag;
                % find the a1,b1 and a2,b2 planes
                t=astar+c*v1;
                mag = sqrt(sum(t.^2));
                a1=t/mag;
                t=astar-c*v1;
                mag = sqrt(sum(t.^2));
                a2 = t/mag;
                t = bstar-(a1'*bstar)*a1;
                mag = sqrt(sum(t.^2));
                b1 = t/mag;
                t = bstar-(a2'*bstar)*a2;
                mag = sqrt(sum(t.^2));
                b2 = t/mag;
                ppi1 = csppind(Z,a1,b1,n,ck);
                ppi2 = csppind(Z,a2,b2,n,ck);
                [mp,ip]=max([ppi1,ppi2]);
                if mp > ppimax	% then reset plane and index to this value
                    eval(['astar=a' int2str(ip) ';']);
                    eval(['bstar=b' int2str(ip) ';']);
                    eval(['ppimax=ppi' int2str(ip) ';']);
                else
                    h = h+1;	% no increase 
                end
                mi=mi+1;
                if h==half	% then decrease the neighborhood
                    c=c*.5;
                    h=0;
                end
            end
            if ppimax > ppm
                % save the current projection as a best plane
                as = astar;
                bs = bstar;
                ppm = ppimax;
            end
        end
    case 'mom'
                for i=1:m  % m 
            % generate a random starting plane
            % this will be the current best plane
            a=randn(p,1);
            mag=sqrt(sum(a.^2));
            astar=a/mag;
            b=randn(p,1);
            bb=b-(astar'*b)*astar;
            mag=sqrt(sum(bb.^2));
            bstar=bb/mag;
            clear a mag b bb
            % find the projection index for this plane
            % this will be the initial value of the index
            Za = Z*astar;
            Zb = Z*bstar;
            ppimax = pimom(Za,Zb);
            % keep repeating this search until the value c becomes 
            % less than cstop or until the number of iterations exceeds maxiter
            mi=0;		% number of iterations
            h = 0;	% number of iterations without increase in index
            c=cs;
            while (mi < maxiter) & (c > cstop)	% Keep searching
                disp(['Iter=' int2str(mi) '  c=' num2str(c) '  Index=' num2str(ppimax) '   i= ' int2str(i)])
                % generate a p-vector on the unit sphere
                v=randn(p,1);
                mag=sqrt(sum(v.^2));
                v1=v/mag;
                % find the a1,b1 and a2,b2 planes
                t=astar+c*v1;
                mag = sqrt(sum(t.^2));
                a1=t/mag;
                t=astar-c*v1;
                mag = sqrt(sum(t.^2));
                a2 = t/mag;
                t = bstar-(a1'*bstar)*a1;
                mag = sqrt(sum(t.^2));
                b1 = t/mag;
                t = bstar-(a2'*bstar)*a2;
                mag = sqrt(sum(t.^2));
                b2 = t/mag;
                ppi1 = pimom(Z*a1,Z*b1);
                ppi2 = pimom(Z*a2,Z*b2);
                [mp,ip] = max([ppi1,ppi2]);
                if mp > ppimax	% then reset plane and index to this value
                    eval(['astar=a' int2str(ip) ';']);
                    eval(['bstar=b' int2str(ip) ';']);
                    eval(['ppimax=ppi' int2str(ip) ';']);
                else
                    h = h+1;	% no increase 
                end
                mi=mi+1;
                if h==half	% then decrease the neighborhood
                    c=c*.5;
                    h=0;
                end
            end
            if ppimax > ppm
                % save the current projection as a best plane
                as = astar;
                bs = bstar;
                ppm = ppimax;
            end
        end
    otherwise
        error('PPI must be ''mom'' or ''chi''')
end

function pim = pimom(zalpha, zbeta)

% PIMOM     Projection Pursuit - Moment Index
% 
% PIM = PIMOM(ZALPHA, ZBETA)
% This function calculates the moment index for projection pursuit
% exploratory data analysis. The inputs ZALPHA and ZBETA are vectors that
% contain the observations projected onto the alpha and beta coordinates.
% The output is the value of the projection pursuit index.

n = length(zalpha);
% Get the values raised to the needed powers.
za2 = zalpha.^2;
zb2 = zbeta.^2;
za3 = zalpha.^3;
zb3 = zbeta.^3;
za4 = zalpha.^4;
zb4 = zbeta.^4;
% Get the coefficients.
c1 = n/((n-1)*(n-2));
c2 = (n*(n+1))/((n-1)*(n-2)*(n-3));
c3 = (3*(n-1)^3)/(n*(n+1));
c4 = (n-1)^3/(n*(n+1));
% Get all of the terms.
k30 = sum(za3)*c1;
k03 = sum(zb3)*c1;
k31 = sum(za3.*zbeta)*c2;
k13 = sum(zb3.*zalpha)*c2;
k04 = (sum(zb4) - c3)*c2;
k40 = (sum(za4) - c3)*c2;
k22 = (sum(za2.*zb2) - c4)*c2;
k21 = sum(za2.*zbeta)*c1;
k12 = sum(zb2.*zalpha)*c1;
% Get the value:
t1 = k30^2 +3*k21^2 + 3*k12^2 + k03^2;
t2 = k40^2 + 4*k31^2 + 6*k22^2 + 4*k13^2 + k04^2;
pim = (t1 + t2/4)/12;

function ppi = csppind(x,a,b,n,ck)
% CSPPIND Chi-square projection pursuit index.
%   
%   PPI = CSPPIND(Z,ALPHA,BETA,N,CK)
%   This finds the value of the projection pursuit index
%   for a plane spanned by the column vectors ALPHA and
%   BETA. The vector CK contains the bivariate standard
%   normal probabilities for radial boxes. CK is usually
%   found in the function CSPPEDA. The matrix Z is the
%   sphered or standardized version of the data.
%
%   See also CSPPEDA, CSPPSTRTREM

%   W. L. and A. R. Martinez, 9/15/01
%   Computational Statistics Toolbox 

z=zeros(n,2);
ppi=0;
pk=zeros(1,48);
eta = pi*(0:8)/36;
delang=45*pi/180;
delr=sqrt(2*log(6))/5;
angles=0:delang:(2*pi);
rd = 0:delr:5*delr;
nr=length(rd);
na=length(angles);

for j=1:9
   % find rotated plane
   aj=a*cos(eta(j))-b*sin(eta(j));
   bj=a*sin(eta(j))+b*cos(eta(j));
   % project data onto this plane
   z(:,1)=x*aj;
   z(:,2)=x*bj;
   % convert to polar coordinates
   [th,r]=cart2pol(z(:,1),z(:,2));
   % find all of the angles that are negative
	ind = find(th<0);
	th(ind)=th(ind)+2*pi;
   % find # points in each box
   for i=1:(nr-1)	% loop over each ring
      for k=1:(na-1)	% loop over each wedge
         ind = find(r>rd(i) & r<rd(i+1) & th>angles(k) & th<angles(k+1));
         pk((i-1)*8+k)=(length(ind)/n-ck((i-1)*8+k))^2/ck((i-1)*8+k);
      end
   end
   % find the number in the outer line of boxes
   for k=1:(na-1)
      ind=find(r>rd(nr) & th>angles(k) & th<angles(k+1));
      pk(40+k)=(length(ind)/n-(1/48))^2/(1/48);
   end
   ppi=ppi+sum(pk);
end
ppi=ppi/9;


   
   