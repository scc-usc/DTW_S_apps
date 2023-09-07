function dtw_matches = find_dtw_matchings(all_reps, dtw_win, dtw_metric, base_m)

if nargin <4
    base_m = 1;
end
if nargin <3
    dtw_metric = 'euc';
end
if nargin <2
    dtw_win = inf;
end

dtw_matches = zeros(size(all_reps, 1), 2*size(all_reps, 2));
ll = size(all_reps, 2);
first_time = 1;
for j=1:size(all_reps, 1)
    if j==base_m
        continue;
    end
    if size(all_reps, 3) == 1
        sig1 = all_reps(base_m, :); sig2 = all_reps(j, :);
    else
        sig1 = squeeze(all_reps(base_m, :, :))'; sig2 = squeeze(all_reps(j, :, :))';
    end

    [~, ix, iy] = dtw_cons_md(sig1, sig2, int32(dtw_win), dtw_metric);
    if first_time == 1
        ll = length(ix);
        dtw_matches(base_m, 1:ll) = ix;
        dtw_matches(j, 1:ll) = iy;
        first_time = 0;
        continue;
    end
    ix = process_repeated(ix); max_ix = floor(max(ix));
    targets = dtw_matches(base_m, 1:ll)'; 
    targets(targets > max_ix) = []; targets = unique(targets);
    dtw_matches(j, targets) = interp1(ix, iy, targets);
    dtw_matches(j, targets(end)+1 : ll) = dtw_matches(j, targets(end)); 
    dtw_matches(j, ll) = iy(end);
end
dtw_matches = dtw_matches(:, 1:ll);
end

% Function to process repeated values
function xx = process_repeated(x)
xx = x;
u = unique(x);
for j=1:length(u)
    idx = find(x==u(j));
    adder = linspace(0, 1, length(idx)+1);
    xx(idx) = xx(idx) + adder(1:end-1)';
end
end
