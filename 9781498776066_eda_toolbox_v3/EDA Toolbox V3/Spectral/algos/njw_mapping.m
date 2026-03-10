
function uu=njw_mapping(S,k)
addpath('C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3\Spectral\helper')
%function uu=njw_mapping(S,k,use_gen)
%Returns the vectors using the NJW algorithm

% Set up global options.
%global_options; 


  %  Compute Laplacian L=D^-1/2 S D^-1/2
	D=diag(sum(S)); 
	Dsqrt=sqrt(D); 
	L=Dsqrt\S/Dsqrt;

	% the top k EV 
	[uu, dummy]=myeigs(S,k); 
	uu=uu'; 
	uu=normalize_2nd(uu); 
