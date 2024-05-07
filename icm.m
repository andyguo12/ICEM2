function [ D,cp,bestfit,gof,rf,pd,n,parameter1] = icm( G,label,p )
%  G is the data to be processed;
% label is the data label;
% p is the reliability;
% address is the output location of the figure.

ge=2;
if nargin == 4  
    ge=1;           %Output Figure
end

%% Characteristic Parameter Extractor
 [ cp ] = cpe( G );
%  cp is the mean, standard deviation and COV;
%% Fitting Distribution Processors
[n,D,bestfit,gof,pd,parameter1] = fdp( G,label);

%% Recommendating Factor Processor
[rf] = rfp(p,bestfit{2},n);

end

