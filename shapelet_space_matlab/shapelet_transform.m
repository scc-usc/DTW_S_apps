function [coords] = shapelet_transform(vector, shapelet_array, slope_thres)
%generate shapelet space representation for the given vector
if nargin < 3
    slope_thres = 0.0005;
end
ns = size(shapelet_array,1);
d = size(shapelet_array,2 );
coords = nan(1, ns);

if d == 1
    coords = vector;
    return;
end

if length(vector)~=d
    return;
end

% The average absolute slope of slope_thres
% gets a flatness of 0.1. Modify below to change
beta = -log(0.1)/slope_thres;

% flat threshold is m0. If the slope is below m0 flatness is 1
m0 = 0;
slope = mean(abs(diff(vector)));
if slope < m0
    flatness = 1;
else
    flatness = exp(-beta*(slope - m0));
end

if slope_thres < 0 % dummy value in case we want correlation only
    flatness = 0;
end

for i = 1:ns
    if not(any(shapelet_array(i, :)))
        score = 2*flatness - 1;
    else
        score = (1-flatness)*similarity_non_flat(shapelet_array(i, :),vector);
    end
    coords(i) =score;
end
end

function s = similarity_non_flat(v1, v2)
v1 = v1(:); v2 = v2(:);
if std(v1)< 1e-100 || std(v2) < 1e-100
    s=0;
else
    temp = corrcoef([v1 v2]);
    s = temp(1,2);
end
end

