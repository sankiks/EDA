function[W,S]=PLSA(x,K,iter)
%
% [W,S]=PLSA(x,K,iter)
%
% Maximum Likelihood estimation of the Probabilistic Latent Semantic 
% Analysis model of Thomas Hofmann.
% Teaching material for Machine Learning -- Practical Assignment 3, 
% written by Ata Kaban, 2005. Used with permission, May 2010.
%
% INPUT PARAMETERS:
%       x: term by document matrix (documents are assumed to be columns 
%            of this matrix)
%       K: number of factors (or topics/clusters)
%       iter (optional): number of iterations - 100 is the default
%
% OUTPUTS:
%   W: terms by topics matrix, containing entries 
%       W(term,topic) = P(term|topic) for each term and topic
%   S: topics by documents matrix, containing entries 
%       S(topic,doc) = P(topic|doc) for each topic and doc
%
 
if nargin<3, iter=100; end % 100 iterations by default

[T,N]=size(x);
 
% Initialisation
W=rand(T,K);   W=W./repmat(sum(W),T,1);
S=rand(K,N);   S=S./repmat(sum(S),K,1);  
 
% Loop (eqs are written in matrix format, which makes the MatLab 
% code more efficient)
for i=1:iter
    S=S.*(W'*((x+eps) ./ (W*S+eps)));    % ./ is element-wise division
    S=S./repmat(sum(S),K,1);
    % the small number eps is added to avoid numerical problems
    W=W.*(( (x+eps) ./ (W*S+eps) )*S');
    W=W./repmat(sum(W),T,1);
end;
