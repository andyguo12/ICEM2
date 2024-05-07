%% input
% address is teh address of the output image
% G is the random variable to be analysed
% label is the name of G.
%% output
%  In this section, include six distribution {'Normal','Lognormal','ExtremeValue','Frechet','Weibull','GMM'};
%  p is reliability
%  gof is the goodness-of-fit value, 
%  (from top to bottom refers to the goodness-of-fit of the six distributions, 
%  and the columns refer to the different fitting distributions.)
% A——the name of the figure.

clc
clear all
close all
G=normrnd(1,0.1,[1000,1]);
label='TEST';
p=0.9;
address='D:\Desktop\tupian1';

[ cp,bestfit,gof,rf,pd,n,parameter1] = icm( G,label,p );
hist_figure_chun(G,pd,n,parameter1,A);