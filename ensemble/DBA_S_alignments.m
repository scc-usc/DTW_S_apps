function [dtw_matches] = DBA_S_alignments(dd, all_reps, A, slope_thres, win, dist_type, num_iter)
ns = size(dd, 1);

%% Compute a good starting point (medoid)
sim_mat = nan(ns, ns); 
%par
for ii=1:ns
    for jj=1:ii
        sim_mat(ii, jj) = dtw_cons_md(squeeze(all_reps(ii, :, :))', squeeze(all_reps(jj, :, :))', int32(win), dist_type);
    end
end


sim_mat(isnan(sim_mat(:))) = 0; sim_mat = (sim_mat + sim_mat')/2;
[~, med_idx] = min(mean(sim_mat));

ref_ts = dd(med_idx, :);

%% Iteratively compute the alignments based on new reference time-series
% New reference time-series computed based on the ensemble of alignments in
% the previous iteration

temp_reps = padarray(all_reps, [1 0 0], 'post');
all_refs = [ref_ts];

for iter = 1:num_iter
    ref_SSR = shape_ts_transform(ref_ts, A, slope_thres);
    temp_reps(ns+1, :, :) = ref_SSR;
    base_id = ns+1;
    dtw_matches = find_dtw_matchings(temp_reps, win, dist_type, base_id);
    [mean_curve, meanT] = dtw_mean_ensemble(dd, dtw_matches(1:ns, :));
    [~, al] = unique(meanT);
    ref_ts = interp1(meanT(al), mean_curve(al), [1:size(dd, 2)], 'makima');
    ref_ts(ref_ts < 0) = 0;
    d_change = sum((ref_ts - all_refs(end, :)).^2);
    if d_change < 1e-10
        disp('Early Termination');
        break;
    end
    all_refs = [all_refs; ref_ts];
end
end

