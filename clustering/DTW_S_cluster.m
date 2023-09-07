addpath('../shapelet_space_matlab/');
addpath('../clustering/');
%%
dd = readmatrix("flu_sims.csv");
%%
plot(dd', 'Color', [0 0 1 0.2]); hold on;
plot(mean(dd, 1, 'omitnan'), 'o', 'Color', 'r')

%% Shapelet definitions
A = [1 2 3 4;
    1 2 2 1;
   1 2 4 8;
    0 0 0 0];

d = size(A, 1); w = size(A, 2);
%% Find slopes that are definite increase
ns = size(dd, 1); T = size(dd, 2);
slope_time = T;
slope_thres = zeros(ns, 1);
for cid = 1:ns
    slope_thres(cid) = max(movmean(abs(diff(dd(cid, 1:slope_time))), [0 d-1]));
end
slope_thres(:) = median(slope_thres, 'omitnan');
%% Compute shapelet space representation at all points in time for all time-series

[all_reps] = shape_ts_transform(dd, A, slope_thres);

%% Plot shapelets
cid = randi(size(dd, 1), 1);% cid = 107;
tiledlayout(2, 1); 

nexttile; plot(dd(cid, :)); xlim([1,size(all_reps, 2)]);
xlabel('Time'); ylabel('Value');
title('Time-series');
nexttile; 
imagesc(squeeze(all_reps(cid, :, :))'); xlim([1,size(all_reps, 2)]);
colorbar('eastoutside');
xlabel('Time'); ylabel('Shapelet dimensions');
ax = gca;
ax.YTickLabel = {'Inc', 'Peak', 'Surge', 'Flat'};
title('Shapelet space visualization');
%%
win = 30; dd_orig = dd; all_reps_orig = all_reps;

%% Find similarity matrix (this will be used later for clustering in case we want to only create ensemble of one cluster)
tic;
sim_mat = nan(ns, ns); 
%par
for ii=1:ns
    for jj=1:ii
        sim_mat(ii, jj) = dtw_cons_md(squeeze(all_reps(ii, :, :))', squeeze(all_reps(jj, :, :))', int32(win), 'euc');
    end
end
toc
%% Uncomment the nested loop corresponding to the desired distance measure
% win = int32(win);
%%% normalized Euclidean distance
% sim_mat_norm = nan(ns, ns); % Actually , distance!
% dd_scaled = normalize(dd, 2, "zscore");
% for ii=1:ns
%     for jj=1:ii
%         sim_mat_norm(ii, jj) = sqrt(sum((dd_scaled(ii, :) - dd_scaled(jj, :)).^2));
%     end
% end
% %
%%% normalized DTW
% sim_mat_norm_dtw = nan(ns, ns); % Actually , distance!
% for ii=1:ns
%     for jj=1:ii
%         sim_mat_norm_dtw(ii, jj) = dtw_cons_md(dd_scaled(ii, :), dd_scaled(jj, :), win, 'eu');
%     end
% end
% 
%%% DTW
% sim_mat_dtw = nan(ns, ns); % Actually , distance!
% for ii=1:ns
%     for jj=1:ii
%         sim_mat_dtw(ii, jj) = dtw_cons_md(dd(ii, :), dd(jj, :), win, 'eu');
%     end
% end
% %
%%% Euclidean distance on SSR
% sim_mat_shape = nan(ns, ns); % Actually , distance!
% for ii=1:ns
%     for jj=1:ii
%         sim_mat_shape(ii, jj) = dtw_cons_md(squeeze(all_reps(ii, :, :))', squeeze(all_reps(jj, :, :))', int32(1), 'eu');
%     end
% end
%%
[T, nC, sil, S] = cluster_ts(sim_mat, 0, 'hier');
%[T, nC, sil, S] = cluster_ts(sim_mat, 4, 'hier');
%%
t = tiledlayout('flow', 'Tilespacing', 'tight');
dd = dd_orig;
all_reps = all_reps_orig;
cmap = hsv(nC);
clear hh;
base_ids = [];
for cc = 1:nC
    nexttile;
    plot(dd(T==cc, :)', 'color', [cmap(cc, :) 0.5]); hold on
    temp = sil; temp(T~=cc) = -inf;
    [~, idx] = max(temp);
    %hh(cc) =  plot(dd(idx, :)', 'color', cmap(cc, :), 'Marker', 'o');
    %hh(cc) =  semilogy(dd(idx, :)', 'color', cmap(cc, :), 'Marker', 'o');
    base_ids = [base_ids; idx];
    ylim([0, max(dd(:))]);
    xL = xlim;
    yL = ylim;
    text(1.5*xL(1),yL(2),['cluster' num2str(cc)],'HorizontalAlignment','left','VerticalAlignment','top',  'FontSize', 16)
    set(gca,'xtick',[]); set(gca,'xticklabel',[]);
    set(gca,'ytick',[]); set(gca,'yticklabel',[]);
    %waitforbuttonpress
end
%legend(hh, compose('%g', (1:nC)))
if win >= size(dd, 2)-1
    win_label = '\infty';
else
    win_label = num2str(win);
end
title(t, ['DTW+S, win = ' win_label])
%title(t, ['DTW+S (cos), win = ' win_label])
%title(t, ['DTW, win = ' win_label])
%title(t, ['DTW, normalized, win = ' win_label])
%title(t, ['Shapelet only'])
%title(t, ['Euclidean, normalized']);

