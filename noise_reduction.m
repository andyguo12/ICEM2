
function G2 = noise_reduction(G)
%% 方法3

% 使用选择的分布个数重新拟合 GMM
gmm = fitgmdist(G, 3,'CovarianceType', 'full'); % 将分布个数设置为 3
G1 = smoothdata(G, 'movmean', 2); % window_size 是移动窗口的大小
% G1 = medfilt1(G, 2); % window_size 是移动窗口的大小


% 使用 EM 算法对 GMM 进行聚类
idx = cluster(gmm, G1);
% 设置字体样式为 Times New Roman
set(groot, 'defaultAxesFontName','Times New Roman')

% % 绘制散点图
% figure;
% h = gscatter(1:length(G1), G1, idx); % idx 为聚类结果
% set(gca, 'FontName', 'Times New Roman');
% xlabel('Data Index', 'FontName', 'Times New Roman');
% ylabel('\itPA', 'FontName', 'Times New Roman', 'FontAngle', 'italic');
% legend(h, 'Location', 'best');

% 计算每个聚类的数量
cluster_counts = histcounts(idx, 1:4);  % 聚类索引从 1 到 3
% 计算每个聚类的占比
cluster_percentage = cluster_counts / numel(idx);
% 显示每个聚类的占比
disp('每个聚类的占比：');
disp(cluster_percentage);
% 
tiny_clusters = find(cluster_percentage < 0.05); % 找到小于5%的聚类
for i = 1:length(tiny_clusters)
    idx(idx == tiny_clusters(i)) = 0; % 将小于5%的聚类的索引置为0
end

% 将权重小于0.5的聚类的权重设置为0，并进行权重重分配
for i = 1:length(cluster_percentage)
    if cluster_percentage(i) < 0.16
        cluster_percentage(i) = 0;
    end
end
cluster_percentage = cluster_percentage / sum(cluster_percentage);

% 找到所有非零索引，即剩余的聚类
non_zero_clusters = unique(idx(idx ~= 0));

% 选择属于非零索引对应聚类的数据点
G2 = [];
for i = 1:length(non_zero_clusters)
    cluster_data = G(idx == non_zero_clusters(i), :);
    G2 = [G2; cluster_data];
end

% % 显示处理前的数据直方图
% subplot(1, 2, 1);
% histogram(G, 'BinMethod', 'auto');
% set(gca, 'FontName', 'Times New Roman');
% title(''); % 去掉标题
% % 设置纵坐标标签
% ylabel('Frequency', 'FontName', 'Times New Roman');
% % 添加未处理的数据直方图英文
% text(0.5, -0.1, 'Raw Data', 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 10, 'Units', 'normalized');
% 
% % 显示处理后的数据直方图，并共享纵坐标
% subplot(1, 2, 2, 'Parent', gcf); % 使用 gcf 获取当前 figure 的句柄
% histogram(G1, 'BinMethod', 'auto');
% set(gca, 'FontName', 'Times New Roman');
% title(''); % 去掉标题
% % 添加处理后的数据直方图英文
% text(0.5, -0.1, 'Processed Data', 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 10, 'Units', 'normalized');




end

% % 标记要移除的异常值区域
% G_with_red = G;
% for i = 1:length(small_clusters)
%     cluster_idx = small_clusters(i);
%     G_with_red(idx == cluster_idx) = -1; % 标记为 -1，以便后续画图时标红
% end
% 
% % 绘制去除异常值前的直方图
% subplot(2,1,1);
% histogram(G, 'Normalization', 'pdf', 'FaceColor', 'none', 'EdgeColor', 'blue');
% xlabel('数据点');
% ylabel('概率密度');
% title('去除异常值前的数据分布');
% hold on;
% % % 标记异常值区域轮廓为红色
% % for i = 1:length(small_clusters)
% %     cluster_idx = small_clusters(i);
% %     histogram(G(idx == cluster_idx), 'Normalization', 'pdf', 'FaceColor', 'none', 'EdgeColor', 'red');
% % end
% 
% 
% % 去除异常值
% G_filtered = G(~ismember(idx, small_clusters), :);
% 
% % 绘制去除异常值后的直方图
% subplot(2,1,2);
% histogram(G_filtered, 'Normalization', 'pdf');
% xlabel('数据点');
% ylabel('概率密度');
% title('去除异常值后的数据分布');



% % 使用 DBSCAN 算法进行密度聚类
% % 使用 fitgmdist 函数进行密度聚类
% threshold_density = 0.05; % 设置密度阈值
% gmdist_obj = fitgmdist(G, num_distributions,'CovarianceType', 'full'); % 将分布个数设置为 3
% pdf_values = pdf(gmdist_obj, G); % 计算数据点的概率密度值
% 
% % 确定密度小于阈值的数据点索引
% low_density_points_idx = pdf_values < threshold_density;
% 
% % 去除密度较低的数据点
% G_filtered = G(~low_density_points_idx, :);
% 
% % 绘制去除异常值前的直方图
% subplot(2,1,1);
% histogram(G, 'Normalization', 'pdf', 'FaceColor', 'none', 'EdgeColor', 'blue');
% xlabel('数据点');
% ylabel('概率密度');
% title('去除异常值前的数据分布');
% 
% % % 标记异常值区域轮廓为红色
% % hold on;
% % plot(G(low_density_points_idx), zeros(size(G(low_density_points_idx))), 'rx'); % 标记异常值为红色 'x'
% 
% % 绘制去除异常值后的直方图
% subplot(2,1,2);
% histogram(G_filtered, 'Normalization', 'pdf');
% xlabel('数据点');
% ylabel('概率密度');
% title('去除异常值后的数据分布');
% G1=G_filtered;
% 
% end
%%
% z_scores = zscore(G);
% threshold = 3;
% outliers = abs(z_scores) > threshold;
% cleaned_data = G(~outliers);
% G1=cleaned_data;
% end
%%
% % 密度估计方法
% [f,xi] = ksdensity(G); % 使用核密度估计计算数据的概率密度函数
% density_threshold = prctile(f, 5); % 计算密度的第5百分位数，作为阈值
% 
% % EM算法聚类
% gm = fitgmdist(G, 3); % 使用 EM 算法拟合高斯混合模型
% 
% % 聚类结果
% idx = cluster(gm, G); % 获取数据点所属的聚类索引
% 
% % 识别密度较低的区域
% low_density_indices = find(f < density_threshold); % 密度低于阈值的索引
% cluster1_indices = find(idx == 1); % 第一个聚类的索引
% cluster2_indices = find(idx == 2); % 第二个聚类的索引
% 
% % 选择要移除的数据点
% points_to_remove = intersect(low_density_indices, [cluster1_indices; cluster2_indices]);
% 
% % 移除数据点
% cleaned_G = G;
% cleaned_G(points_to_remove) = [];
% G1=cleaned_G;
% % 可视化结果
% figure;
% subplot(2,1,1);
% plot(xi, f);
% xlabel('数据点');
% ylabel('概率密度');
% title('数据概率密度估计');
% 
% subplot(2,1,2);
% histogram(cleaned_G, 'Normalization', 'pdf');
% xlabel('数据点');
% ylabel('概率密度');
% title('去除异常值后的数据分布');

% % 密度估计方法（核密度估计）
% [f, xi] = ksdensity(G); % 使用核密度估计计算数据的概率密度函数
% 
% % 找到概率密度函数值较小的区域
% low_density_indices = find(f < 0.5); % 密度低于第5百分位数的索引
% 
% % 确定属于密度较低的区域的数据点
% points_to_remove = low_density_indices;
% 
% % 移除数据点
% cleaned_G = G;
% cleaned_G(points_to_remove) = [];
% G1=cleaned_G;
% % 可视化结果
% figure;
% subplot(2,1,1);
% plot(xi, f);
% xlabel('数据点');
% ylabel('概率密度');
% title('数据概率密度估计');
% 
% subplot(2,1,2);
% histogram(cleaned_G, 'Normalization', 'pdf');
% xlabel('数据点');
% ylabel('概率密度');
% title('去除异常值后的数据分布');

% end

