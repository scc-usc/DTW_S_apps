function [all_reps] = shape_ts_transform(dd, A, slope_thres)
ns = size(dd, 1); T = size(dd, 2); 
w = size(A, 2); d = size(A, 1);
nopad = 0; % 0 means pad the last w points
all_reps = nan(ns, T, d);

if length(slope_thres)==1
    slope_thres = repmat(slope_thres, [ns 1]);
end

l = ceil(w/2)-1; r = w - ceil(w/2); % moving window determined by left and right
%l = 0; r = w-1;
for cid = 1:ns
    for tt = l+1 : T-r
        all_reps(cid, tt, :) = shapelet_transform(dd(cid, tt-l:tt+r), A, slope_thres(cid));
    end
    if nopad < 1
        all_reps(cid, 1:l, :) = repmat(squeeze(all_reps(cid, ceil(w/2), :)), [1 l])';
        all_reps(cid, (T-r+1) : T, :) = repmat(squeeze(all_reps(cid, T - r, :)), [1 r])';
    end
end
end

