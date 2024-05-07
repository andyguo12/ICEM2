function hist_figure_chun( a,pd,bn,parameter1,A)

ge=2;
if nargin == 6  
    ge=1;           %Output Figure
end

% Six different colors represent different distributions
color=[0.505882353	0.894117647	1;
0.149019608	0.380392157	0.733333333;
0.047058824	0.262745098	0.180392157;
0.37254902	0.635294118	0.564705882;
0.305882353	0.580392157	0.917647059;
0.239215686	0.243137255	0.568627451];

le=0.7;
le1=0.2;
al=0.4;

tiaoju=0.05;
x_values=0:0.001:2.55;

edges = (0:tiaoju:2.6);
n=length(a);
[c,d] = hist(a,edges);
   hold (A,'on')
   c=c*100;
for i = 1:length(c)
    BA=bar(A,d(i),c(i)/n,tiaoju,'Barwidth',0.2);
    if d(i) < 0.5
        set(BA,'FaceColor',[188,214,91]/255);
    elseif d(i) <= 1
        set(BA,'FaceColor',[255,236,95]/255);
    else
        set(BA,'FaceColor',[195,79,6]/255);
    end
end
    % legend('off')
    hold (A,'on')
    %%  参数拟合
    dis_type={'normal','logn','ev','f','weibull'};
    label_name={'Normal','Lognormal','Gumbel','Frechet','Weibull','GMM'};
%% ==================================================================
for i=1:5 
    if i~=4
    if i==bn
        pd{i}=fitdist(a,dis_type{i});
        y{i} = pdf(pd{i},x_values)*tiaoju*100;
        p{i}=plot(A,x_values,y{i},'color','r','LineWidth',le+le1);
         hold (A,'on')
    else
        pd{i}=fitdist(a,dis_type{i});
        y{i} = pdf(pd{i},x_values)*tiaoju*100;
        p{i}=plot(A,x_values,y{i},'color',color(i,:),'LineWidth',le);
        p{i}.Color(4) =al;
        hold (A,'on')
    end
    end
end
%% =========================='Frechet'===================================
i=4;
y{i} = (pd{4}(1)./pd{4}(2)).*(pd{4}(2)./x_values).^(pd{4}(1)+1) .* exp( -(pd{4}(2)./x_values).^pd{4}(1) )*tiaoju*100;
if i==bn
p{i}=plot(A,x_values,y{i},'color','r','LineWidth',le+le1);
else 
p{i}=plot(A,x_values,y{i},'color',color(i,:),'LineWidth',le,'DisplayName',label_name{i}); 
 p{i}.Color(4) = al;
end
hold (A,'on')


%% ============================'GMM'==================================
i=6;
P(i)=0;
    mean= parameter1(1,:);
    cov= parameter1(2,:);
    coef= parameter1(3,:);

    y{i}= zeros(1,length(x_values));
    q{i}= zeros(length(a),1);
for v=1:3
    y{i} = y{i}+ normpdf(x_values,mean(v),cov(v))*coef(v);
    q{i} = q{i}+ normpdf(a,mean(v),cov(v))*coef(v);
end

if i==bn
    p{i} = plot(A,x_values,y{i}*tiaoju*100,'color','r','LineWidth',le+le1,'DisplayName',label_name{i});
  else
    p{i} = plot(A,x_values,y{i}*tiaoju*100,'color',color(i,:),'LineWidth',le,'DisplayName',label_name{i});
    p{i}.Color(4) = al;
end

% 
%     p{i} = plot(x_values,y{i}*5,'color','r','LineWidth',le);
    legend([p{1},p{2},p{3},p{4},p{5},p{6}],label_name,'location','northeast','Fontname','Helvetica');
   legend(A,'boxoff') 
    %hist_set(A)
    % if ge==1
    %      print(figure1,address,'-dbmp','-r600')
    % end
end

%%   
function hist_set(A)

kuan=230;
gao=200;
figure_FontSize=8;
bili=[.15 .17 .80 .80];
ylabel(A,'Frequency/%','FontSize',figure_FontSize,'Fontname', 'Times New Roman','LineWidth',1);
xlabel(A,'{\itPA}','FontSize',figure_FontSize,'Fontname','Times New Roman','LineWidth',1); 
legend(A,'boxoff') 
% grid on 
axis(A,[0 2.5 0 25]);
set(A,gcf,'Position',[100 100 kuan gao]);
set(A,gca,'Position',bili,'LineWidth',1,'GridLineStyle','-','FontSize',figure_FontSize,'Fontname', 'Times New Roman');  %内部坐标轴线的宽度阴影之类的,'GridAlpha',0.6
set(A,gca,'xTickLabel',num2str(get(gca,'xTick')','%.1f'))

grid on

box on

end

