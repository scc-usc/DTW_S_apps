function [S, sil, coh, sep] = sillhouette_eval(dist_mat, CC)
% dist_mat must be lower triangular
% CC is the assignement of all nodes
dist_mat(isnan(dist_mat)) = 0;
dist_mat = dist_mat + dist_mat';
nc = max(unique(CC));
ns = size(dist_mat, 1);

coh = zeros(ns, 1); sep = zeros(ns, 1); 
sil = zeros(ns, 1);

if nc==1
    S = mean(sil);
    return;
end

for ii = 1:ns
    coh(ii) = sum(dist_mat(ii, CC == CC(ii)))/(1e-15 + sum(CC==CC(ii)));
    sep(ii) = inf;
    for cc = 1:nc
        if CC(ii) == cc
            d = inf;
        else
            d = sum(dist_mat(ii, CC == cc))/(1e-15 + sum(CC==cc));
        end
        sep(ii) = min([sep(ii), d]);
    end
    sil(ii) = (sep(ii) - coh(ii))./max([sep(ii), coh(ii)]);
end

S = mean(sil);