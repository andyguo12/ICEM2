function [parameter,parameter1,P,NlogL,AIC,BIC,pd] = hist_figure(a,kge)


    x_values=0:0.001:2.55;
    alpha=0.05;
    n=length(a);
    dis_type={'normal','logn','ev','f','weibull'};

%% ==================================================================
for i=1:5 
    if i==4
        continue;
    else
        pd{i}=fitdist(a,dis_type{i});
        y{i} = pdf(pd{i},x_values)*5;
        u{i} = [a,cdf(pd{i},a)];
        [~,P(i)] =kstest(a,'cdf',u{i},'alpha',alpha);
        format compact
        NlogL(i)=round(negloglik(pd{i}),3);
        nParam=2;
        [BIC(i),AIC(i)] = Gof(NlogL(i),nParam,n);
         parameter(i,:)=round((pd{i}.ParameterValues)',3);
    end
       
end
%% =========================='Frechet'===================================
    i=4;
    [parameter(i,1),parameter(i,2)]=MLE_est(a,[1.85,0.58]);
    y{i} = (parameter(i,1)./parameter(i,2)).*(parameter(i,2)./x_values).^(parameter(i,1)+1) .* exp( -(parameter(i,2)./x_values).^parameter(i,1) )*5;
    u{i}=[a,exp( -(parameter(i,2)./a).^parameter(i,1))];
    [H(i),P(i)] =kstest(a,'cdf',u{i},'alpha',alpha);
    format compact
    q{i} = (parameter(i,1)/parameter(i,2))*(parameter(i,2)./a).^(parameter(i,1)+1) .* exp( -(parameter(i,2)./a).^parameter(i,1) );
    NlogL(i) = round(Nlog(q{i}),3);
    [BIC(i),AIC(i)] = Gof(NlogL(i),nParam,n);
    pd{i}=round(parameter(i,:),3);
%% ============================'GMM'==================================
i=6;
P(i)=0;

while P(i)<0.8
    [mean,cov,coef] =  gaussian_mixture_model(a',kge,0.05);
    f= zeros(length(a),1);
    for v=1:kge
        f = f+ normcdf(a,mean(v),cov(v))*coef(v);
    end
    u{i}=[a,f];
    if isnan(mean(1))
        P(i)=0;
    else
        [H(i),P(i)] =kstest(a,'cdf',u{i},'alpha',0.05);
    end
end
    y{i}= zeros(1,length(x_values));
    q{i}= zeros(length(a),1);
    
for v=1:kge
    y{i} = y{i}+ normpdf(x_values,mean(v),cov(v))*coef(v);
    q{i} = q{i}+ normpdf(a,mean(v),cov(v))*coef(v);
end

%     p{i} = plot(x_values,y{i}*5,'color',color(i,:),'LineWidth',le1);
    NlogL(i) =round(Nlog(q{i}),3);
    nParam= kge*3-1;
    [BIC(i),AIC(i)] = Gof(NlogL(i),nParam,n);

    parameter1(1,1:kge)=round(mean,3)';
    parameter1(2,1:kge)= round(cov,3)';
    parameter1(3,1:kge)= round(coef,3)';
    parameter=round(parameter,3)';

end
%% =============================================================

function [estA,estB] = MLE_est(x,guess)
    % x is the vector of data points
    % guess is a vector with 2 elements; these are your initial guesses for A and B
    ests = fminsearch(@fntominimize,guess);
    estA = ests(1);  
    estB = ests(2);
       function minuslnpdf = fntominimize(ests)  % use a nested function so it has access to x
        estA = ests(1);
        estB = ests(2);
        % Next compute the pdf values of all x's
        pdfs = (estA/estB)*(estB./x).^(estA+1) .* exp( -(estB./x).^estA );
        % now compute the minus of the log likelihood function, which is what
        % you want to minimize.
        minuslnpdf = sum( -log(pdfs) );
    end
  end
function NlogL = Nlog(q)
    LL = log(q);
    NlogL = -sum(LL(~isnan(LL))); 
    
end

function [BIC,AIC] = Gof(NlogL,nParam,n)
    % AIC BIC
    BIC= round(2*NlogL + nParam*log(n));
    AIC= round(2*NlogL + 2*nParam,3);
end



