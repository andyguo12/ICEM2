function pointchart(G,B,numRows)

kuan=300;
gao=255;
figure_FontSize=10;
le=1;                                        %线宽
bili=[.17 .19 .80 .78];
X2=numRows+2;
Y2=2.5;
axis(B,[0,X2,0,Y2]);


line(B,[0,X2],[1,1],'LineWidth',le);
hold (B,'on')
plot (B,G(:,1),G(:,2),'.','MarkerEdgeColor','r','MarkerSize',10);
hold (B,'on')

% 将 numRows 除以 6，再向上取整
N = ceil(numRows / 5);


ylabel(B,'{\itPA}','FontSize',figure_FontSize,'Fontname', 'Times New Roman','LineWidth',le);
xlabel(B,'{\itNumber}','FontSize',figure_FontSize,'Fontname','Times New Roman','LineWidth',le);
set(B,'XTick',0:N:numRows+2);
set(B,'YTick',0:0.5:2.5);
grid (B,'on')
box (B,'on') 
% set(gca,'Position',bili,'LineWidth',le,'GridLineWidth',0.5,'GridAlpha',0.4,'FontSize',figure_FontSize,'FontName', 'Times New Roman','Box','on');  %内部坐标轴线的宽度阴影之类的
% set(gcf,'Position',[100 100 kuan gao]);


end

