function [T, nC, sil, S] = cluster_ts(sim_mat, Cn, method)
if nargin < 2
    Cn = 0;
end

if nargin < 3
    method = 'hier';
end

[ii, jj, val] = find(sim_mat);
temp = [ii, jj, val];

sim_mat1 = sim_mat; sim_mat1(isnan(sim_mat)) = 0;
[ii, jj, val] = find(~sim_mat1);
temp1 = [ii, jj, val-1];
temp = [temp; temp1];

temp(temp(:, 1) <= temp(:, 2), :) = []; % sparse distance format
Z = linkage(temp(:, 3)', 'complete');
maxC = 10;
S = zeros(maxC, 1);
for nC = 1:maxC
    if contains(method, 'hier')
        T = cluster(Z, 'MaxClust', nC);
    elseif contains(method, 'kmed')
        T = kmedoids_D(sim_mat, nC);
    end
    [S(nC)] = sillhouette_eval(sim_mat, T);
end

if Cn == 0
    [~, nC] = max(S);
else
    nC = Cn;
end
if contains(method, 'hier')
    T = cluster(Z, 'MaxClust', nC);
elseif contains(method, 'kmed')
    T = kmedoids_D(sim_mat, nC);
end
[~, sil] = sillhouette_eval(sim_mat, T);
