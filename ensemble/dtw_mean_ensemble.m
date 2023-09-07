function [mean_curve, meanT, quant_curve, T] = dtw_mean_ensemble(dd, dtw_matches)
ll = size(dtw_matches, 2); % number of matchings/"events"
ns = size(dd, 1); % number of simulations
np = size(dtw_matches, 1); % number of points per event. Must be a multiple of ns

% if ~iscell(dtw_mean_ensemble)
%     ll = size(dtw_matches, 2); % number of matchings/"events"
%     ns = size(dd, 1); % number of simulations
%     np = size(dtw_matches, 1); % number of points per event. Must be a multiple of ns
%     dtw_matches_cell = cell(1, ll);
%     for j=1:ll
%         dtw_matches_cell{j} = dtw_matches(:, j);
%     end
% else
%     dtw_matches_cell = dtw_matches;
% end

quant_curve = zeros(np, ll);
T = zeros(np, length(ll));

mean_curve = zeros(1, ll);
meanT = zeros(1, ll);

for j=1:ll
    T(:, j) = dtw_matches(:, j);
    meanT(j) = mean(dtw_matches(:, j));
    dat = zeros(1, np);
    for cid = 1:np
        dat(cid) = dd(1+mod(cid-1, ns), dtw_matches(cid, j));
    end
    mean_curve(j) = mean(dat);
    quant_curve(:, j) = dat';
end
end

