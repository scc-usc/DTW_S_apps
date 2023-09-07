addpath('../shapelet_space_matlab/');
addpath('../clustering/');
%%
dd = readmatrix("flu_sims.csv");
%%
plot(dd', 'Color', [0 0 1 0.2]); hold on;
plot(mean(dd, 1, 'omitnan'), 'o', 'Color', 'r')

%% Shapelet definitions
A = [1 1.5 3 7.5; ...
    1 2 3 4; ...
    1,2,2,1; ...
    4,3,2,1; ...
    0 0 0 0];

A = [1 2 3 4;
    1 2 2 1;
   1 2 4 8;
    0 0 0 0];

% A = [1 2 3 4 5;
%     1 2 3 2 1;
%     1 2 4 8 16;
%     0 0 0 0 0];



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

%% Clustering that will help select subset of similar time-series to ensemble
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

%% All time-series
%base_ids = base_ids(min(2, length(base_ids)));
dtw_matches = find_dtw_matchings(all_reps, 20, 'euc');
[mean_curve, meanT, true_y, true_T] = dtw_mean_ensemble(dd, dtw_matches);


%% Plot
clear h;
% sel_idx = T==4;
% dd1 = dd(sel_idx, :);
dd1 = dd;
set(0,'defaultAxesFontSize',20)
s = plot(dd1', 'Color', [0 0 1 0.1]); hold on
h(1) = plot(mean(dd1, 1), 'Color', 'r', 'LineWidth', 1.5);
h(2) = plot(meanT, mean_curve, 'Color', 'black', 'LineWidth', 1.5);
%h(2) = plot(meanT_noshape, mean_curve_noshape, 'Color', 'green', 'LineWidth', 1.5);
legend(h, {'Mean', 'DTW+S Mean'});
%  plot(T(1, :)', quant_curve(3, :)', 'LineWidth', 1.5)
%  plot(T(2, :)', quant_curve(2, :)', 'LineWidth', 1.5)
%  plot(T(3, :)', quant_curve(1, :)', 'LineWidth', 1.5)

%plot(quant_curve_i', 'LineWidth',1.5, 'Color', 'green');
%% Repeat for cluster number 1 only
clear h;
sel_idx = T==1;
dd1 = dd(sel_idx, :);
all_reps1 = shape_ts_transform(dd1, A, slope_thres);

%%
% set(0,'defaultAxesFontSize',20);

figure('Position', [1 1 600 600]);
s = plot(dd1', 'Color', [0 0 1 0.1]); hold on
h(1) = plot(mean(dd1, 1), 'Color', 'r', 'LineWidth', 1.5);
sel_bool = zeros(length(base_ids), 1); sel_bool([5 6]) = 1;
all_peaks = zeros(size(dd1, 1), 1);
for ii = 1:size(dd1, 1)
    dtw_matches = find_dtw_matchings(all_reps1, win, 'euc', ii);
    [mean_curve, meanT, true_y, true_T] = dtw_mean_ensemble(dd1, dtw_matches);
    %h(2) = plot(meanT, mean_curve, 'Color', 'black', 'LineWidth', 1.5);
    h(2) = plot(meanT, mean_curve, 'Color', 'black', 'Marker','o'); %, 'Linestyle', 'none');
    all_peaks(ii) = max(mean_curve);
end
legend(h, {'Mean', 'DTW+S Mean'});
xlabel('time')
ylabel('value')

%% Plot matchings
figure('Position', [1 1 600 600]);
dtw_matches = find_dtw_matchings(all_reps1, 30, 'euc', 1);
[~, ~, int_y, int_T] = dtw_ensemble_intervals(dd1, dtw_matches, 0.5);
dmatches = dtw_matches; 
tY = true_y; tT = true_T;
tY2 = int_y; tT2 = int_T;
%tY(any(isnan(tY), 2), :) = []; tT(any(isnan(tT), 2), :) = [];
c_list = {'k', 'r', 'b', 'm', 'g'};
s = plot(dd1', 'Color', [0 0 1 0.1]); hold on
xlabel('time'); ylabel('value');
for mm = 1:size(dmatches, 2)
    x1 = tT(:, mm); y1= tY(:, mm);
    bad_idx = (isnan(x1) | isnan(y1));
    x1(bad_idx) = []; y1(bad_idx) = [];

    x2 = tT2(:, mm); y2= tY2(:, mm);
    bad_idx = (isnan(x2) | isnan(y2));
    x2(bad_idx) = []; y2(bad_idx) = [];
    
    if any(abs(diff(x1)) > 0.5) && any(abs(diff(y1)) > 0.5) && any(abs(diff(x2)) > 0.5) && any(abs(diff(y2)) > 0.5)
        [k, av] = convhull(x1, y1, 'Simplify', false);
        %h1 = plot(x1(k, 1), y1(k, 1), c_list{1 + mod(mm, length(c_list))}, 'marker', 'x');
        h1 = plot(x1, y1, c_list{1 + mod(mm, length(c_list))}, 'marker', 'x', 'LineStyle', 'none');
    else
        h1 = plot(x1, y1, c_list{1 + mod(mm, length(c_list))}, 'marker', 'x', 'LineStyle', 'none');
    end
    
    plot(meanT(mm), mean_curve(mm), c_list{1 + mod(mm, length(c_list))}, 'marker', 'o', 'LineWidth',3);
 
      waitforbuttonpress
       delete(h1)
end
%plot(meanT, mean_curve, 'Color', 'black', 'marker', 'o');

%% Fill color
figure; hold on;

for mm = 1:size(dmatches, 2)
    x1 = tT(:, mm); y1= tY(:, mm);
    bad_idx = (isnan(x1) | isnan(y1));
    x1(bad_idx) = []; y1(bad_idx) = [];
    k = convex_hull_degen(x1, y1);
    fill(x1(k, 1), y1(k, 1), 'g', 'FaceAlpha',0.2);
end

for mm = 1:size(dmatches, 2)
    x2 = tT2(:, mm); y2= tY2(:, mm);
    bad_idx = (isnan(x2) | isnan(y2));
    x2(bad_idx) = []; y2(bad_idx) = [];
    %x2 = x2.*(1 + 0.1*rand(length(x2), 1)); y2 = y2.*(1 + 0.1*rand(length(y2), 1));
    k = convex_hull_degen(x2, y2);
    fill(x2(k, 1), y2(k, 1), 'b', 'FaceAlpha',0.2);
end
plot(meanT, mean_curve, 'Color', 'black', 'marker', 'o','LineWidth',2);

%% 
function k = convex_hull_degen(x2, y2)
    if any(abs(diff(x2)) > 1e-10) && any(abs(diff(y2)) > 1e-10) 
        [k] = convhull(x2, y2, 'Simplify', true);
    else
        [~, i1] = min(x2); [~, i2] = min(y2); [~, i3] = max(x2); [~, i4] = max(y2);
        k = [i1; i2; i3; i4];
    end
end