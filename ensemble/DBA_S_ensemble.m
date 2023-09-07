addpath('../');
addpath('../../../shapelets/shapelet_space_matlab/');
addpath('../../../shapelets/');
addpath('../../../networks/');
%%
load model_dat.mat
%%
%model_dat = all_state_dat{loc_map(20)}; %20
dd = squeeze(model_dat(:, 2, 2, :));
dd(all(isnan(dd), 2), :) = [];
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
% tic;
% sim_mat = nan(ns, ns); 
% %par
% for ii=1:ns
%     for jj=1:ii
%         sim_mat(ii, jj) = dtw_cons_md(squeeze(all_reps(ii, :, :))', squeeze(all_reps(jj, :, :))', int32(win), 'euc');
%     end
% end
% toc
% %%
% sim_mat(isnan(sim_mat(:))) = 0; sim_mat = (sim_mat + sim_mat')/2;
% 
% %%
% [~, med_idx] = min(mean(sim_mat));
% ref_ts = dd(med_idx, :);
% temp_reps = padarray(all_reps, [1 0 0], 'post');
% num_iter = 10;
% all_refs = [ref_ts];
% for iter = 1:num_iter
%     ref_SSR = shape_ts_transform(ref_ts, A, slope_thres);
%     temp_reps(ns+1, :, :) = ref_SSR;
%     base_id = ns+1;
%     dtw_matches = find_dtw_matchings(temp_reps, win, 'euc', base_id);
%     [mean_curve, meanT] = dtw_mean_ensemble(dd, dtw_matches(1:ns, :));
%     [~, al] = unique(meanT);
%     ref_ts = interp1(meanT(al), mean_curve(al), [1:size(dd, 2)], 'makima');
%     ref_ts(ref_ts < 0) = 0;
%     d_change = sum((ref_ts - all_refs(end, :)).^2);
%     if d_change < 1e-10
%         disp('Early Termination');
%         break;
%     end
%     all_refs = [all_refs; ref_ts];
% end
[dtw_matches] = DBA_S_alignments(dd, dd, 1, slope_thres, win, 'euc', 20);
%%
[mean_curve, meanT, true_y, true_T] = dtw_mean_ensemble(dd, dtw_matches);

%% Plot
clear h;
dd1 = dd;
set(0,'defaultAxesFontSize',20)
s = plot(dd1', 'Color', [0 0 1 0.1]); hold on
h(1) = plot(mean(dd1, 1), 'Color', 'r', 'LineWidth', 1.5);
h(2) = plot(meanT, mean_curve, 'Color', 'black', 'LineWidth', 1.5);

legend(h, {'Mean', 'DTW+S DBA'});
%%