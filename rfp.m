function [rf] = rfp(p,parameter1,n)
% p is reliability; 
% parameter1 is the best-fit parameter; 
% n is index of bestfi;.
% x0 is the initial hypothesis solution;

x0=0.5;
switch n
    case 1     
        rf=icdf('Normal',p,parameter1(1),parameter1(2));
        
    case 2
        rf=icdf('Lognormal',p,parameter1(1),parameter1(2));
        
    case 3
        rf=icdf('ev',p,parameter1(1),parameter1(2));
    case 4
        fcdf=@(x)exp(-(parameter1(2)./x).^parameter1(1))-p;
        rf= fsolve(fcdf,x0);
        %  Frechet distribution     
    case 5
        rf=icdf('Weibull',p,parameter1(1),parameter1(2));
    case 6
        pm=parameter1;
        mu= parameter1(1,:);
        cov= parameter1(2,:);
        coef= parameter1(3,:);
        gmcdf=@(x)(normcdf(x,mu(1),cov(1))*coef(1)+normcdf(x,mu(2),cov(2))*coef(2)+normcdf(x,mu(3),cov(3))*coef(3))-p;
        rf = fsolve(gmcdf,x0);
      
end







