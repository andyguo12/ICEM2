function [n,D,bestfit,gof,pd,parameter1] = fdp( G,label)
% index a is the best-fit distribution to which the indicator points,
% and the three columns are tabulated to represent NlogL, AIC, and BIC.
% Results 1-6 represent{'Normal','Lognormal','ExtremeValue','Frechet','Weibull','GMM'}.

%%  Judge the number of inputs to make sure whether to output the image or not.
% ge represents the number of inputs；
ge=2;                    
if nargin == 3     %有地址就输出
    ge=1;
end
%% Parameter estimation and goodness-of-fit calculations
% parameter is the fitting parameter for the unimodal distribution;
% parameter1 is the fitting parameter for the multi-peak distribution;
% gof is the goodness-of-fit, p-value(K-S test),NlogL, AIC, BIC;
% PD is the details of distribution;
% G is the random variable to be analysed;
% k is the number of normal distributions required to be coupled.
   k=3;
   [parameter,parameter1,gof(:,1),gof(:,2),gof(:,3),gof(:,4),pd] = hist_figure( G,k);
 
%% Hypothetical Distribution Filter
% col is the distribution number that passes the filtering.
label_name={'Normal','Lognormal','ExtremeValue','Frechet','Weibull','GMM'};
D{1,1}=label;
col=find( gof(:,1)>0.05);

%%  Best Fit Distribution Filter
% index——the pointer pointing to the best-fit distribution by NlogL, AIC and BIC.
% D——the best-fit distribution name.
[~,index(1)] = min(gof(col,2));
[~,index(2)] = min(gof(col,3));
[~,index(3)] = min(gof(col,4));
D{:,2}=label_name(col(index(1)));
D{:,3}=label_name(col(index(2)));
D{:,4}=label_name(col(index(3)));

% a is is a frequency distribution table. the name of the pointer indicating the best-fit distribution.
% The first column represents species; 
% The second column represents frequency;
% The third column represents probability.
a=tabulate(index);  
x=find(a(:,2)>=2); % Finding the distribution number with cumulative points greater than 2.
n=col(a(x));
%% The output of the best-fit distribution
% best-fit{1} is the name;
% best-fit{2} is the parameter;
bestfit{1}=label_name(n);   
if isempty(x)
    disp( 'There is no agreement on different indicators.') ;
else
    if col(a(x,1))<6
        bestfit{2}= round(parameter(:,n),3);
    else
        bestfit{2}= round(parameter1,3);
    end
end


%% draw a figure


end



