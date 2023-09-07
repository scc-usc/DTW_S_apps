% %%%%%%%%%%%%%%% Part of the code derived from Eamonn Keogh's implementation %%%%%%%%%%%%%%%%%%%%%
% Function to classify each time-series % in matrix TEST using DTW+S based nearest neighbor
% among time-series in TRAIN
% win_set and smooth_len are hyperparameter sets for the DTW window and
% smoothing window, respectively.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [err_rate, best_win, best_smooth, this_correct] = UCR_time_series_test(TRAIN, TEST, validation_on, win_set, rel_length, smooth_len)

if nargin < 3
    validation_on = 0;
end
if nargin < 4
    win_set = 10;
end
if nargin < 5
    rel_length = 0;
end

if nargin < 6
    smooth_len = 0;
end

best_win = 0; err_rate = inf; this_correct = 0; best_smooth = 0;

if validation_on == 0
    if length(win_set)~=1 || length(smooth_len)~=1
        disp('ERROR: window should be a scalar. Vectors allowed only for validations');
        return;
    end
    best_win = win_set;
    best_smooth = smooth_len;
end

TRAIN_class_labels = TRAIN(:,1); % Pull out the class labels.
TRAIN(:,1) = []; % Remove class labels from training set.
TEST_class_labels = TEST(:,1); % Pull out the class labels.
TEST(:,1) = []; % Remove class labels from testing set.

TRAIN_orig = TRAIN;
TEST_orig = TEST;

% if length(smooth_len) == 1
%     if smooth_len > 0
%         smooth_len_int = ceil(size(TRAIN, 2)*smooth_len);
%         TRAIN = movmean(TRAIN, smooth_len_int, 2);
%         TEST = movmean(TEST, smooth_len_int, 2);
%     end
% end

if rel_length > 0
    win_set = unique(ceil(win_set*size(TRAIN, 2)));
    best_win = win_set;
end

% Shapelet setup

A = [1 2 3 4;
    1 2 2 1;
    1 2 4 8;
    0 0 0 0];

%A = eye(4, 4);

d = size(A, 1); w = size(A, 2);
slope_thres = get_slope_threshold(TRAIN, w);
% slope_thres = -1; % to ignore flatness
% %%% Compute shapelet space representation at all points in time for all time-series
% 
% [all_reps_TRAIN] = shape_ts_transform(TRAIN, A, slope_thres);
% [all_reps_TEST] = shape_ts_transform(TEST, A, slope_thres);

%
if validation_on == 1
    [X1, X2] = ndgrid(win_set, smooth_len);
    val_list = [X1(:) X2(:)];
    this_correct = zeros(size(val_list, 1), 1);

    for ww = 1:size(val_list, 1)
        smooth_win = (val_list(ww, 2));
        this_win = (val_list(ww, 1));
        
        TRAIN = TRAIN_orig;
        if smooth_win > 0
            smooth_len_int = ceil(size(TRAIN, 2)*smooth_win);
            TRAIN = movmean(TRAIN_orig, smooth_len_int, 2);
            %TEST = movmean(TEST_orig, smooth_len_int, 2);
        end

        slope_thres = get_slope_threshold(TRAIN, w);

        [all_reps_TRAIN] = shape_ts_transform(TRAIN, A, slope_thres);
        %[all_reps_TEST] = shape_ts_transform(TEST, A, slope_thres);

        correct = zeros(length(TRAIN_class_labels), 1); % Initialize the number we got correct

        parfor i = 1 : length(TRAIN_class_labels) % Loop over every instance in the test set
            classify_this_shape = squeeze(all_reps_TRAIN(i,:, :))';
            this_objects_actual_class = TRAIN_class_labels(i);
            predicted_class = Classification_Algorithm_S(all_reps_TRAIN, TRAIN_class_labels, classify_this_shape, this_win, i);
            if predicted_class == this_objects_actual_class
                correct(i) = 1;
            end
        end
        this_correct(ww) = sum(correct);
    end
    [mval] = max(this_correct);
    best_win_idx = find(this_correct > mval-0.5 & this_correct < mval+0.5);
    best_win = val_list(best_win_idx(end), 1);
    best_smooth = val_list(best_win_idx(end), 2);
end

TRAIN = TRAIN_orig;
if best_smooth > 0
    smooth_len_int = ceil(size(TRAIN, 2)*best_smooth);
    TRAIN = movmean(TRAIN_orig, smooth_len_int, 2);
    TEST = movmean(TEST_orig, smooth_len_int, 2);
end

slope_thres = get_slope_threshold(TRAIN, w);

[all_reps_TRAIN] = shape_ts_transform(TRAIN, A, slope_thres);
[all_reps_TEST] = shape_ts_transform(TEST, A, slope_thres);


correct = zeros(length(TEST_class_labels), 1); % Initialize the number we got correct
parfor i = 1 : length(TEST_class_labels) % Loop over every instance in the test set
    %classify_this_object = TEST(i,:);
    classify_this_shape = squeeze(all_reps_TEST(i,:, :))';
    this_objects_actual_class = TEST_class_labels(i);
    %predicted_class = Classification_Algorithm(TRAIN,TRAIN_class_labels, classify_this_object);
    predicted_class = Classification_Algorithm_S(all_reps_TRAIN,TRAIN_class_labels, classify_this_shape, best_win);
    if predicted_class == this_objects_actual_class
        correct(i) = correct(i) + 1;
    end
%     if mod(i, 100) == 0
%         disp([int2str(i), ' out of ', int2str(length(TEST_class_labels)), ' done']) % Report progress
%     end
end
correct = sum(correct);
err_rate = (length(TEST_class_labels)-correct )/length(TEST_class_labels);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here is a sample classification algorithm, it is the simple (yet very competitive) one-nearest
% neighbor using the Euclidean distance.
% If you are advocating a new distance measure you just need to change the line marked "Euclidean distance"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function predicted_class = Classification_Algorithm(TRAIN,TRAIN_class_labels,unknown_object)
best_so_far = inf;
for i = 1 : length(TRAIN_class_labels)
    compare_to_this_object = TRAIN(i,:);
    %distance = sqrt(sum((compare_to_this_object - unknown_object).^2)); % Euclidean distance
    distance = dtw(compare_to_this_object, unknown_object, 4, 'euclidean');
    
    if distance < best_so_far
        predicted_class = TRAIN_class_labels(i);
        best_so_far = distance;
    end
end
end

function predicted_class = Classification_Algorithm_S(TRAIN,TRAIN_class_labels,unknown_object, win, skip_idx)
if nargin < 5
    skip_idx = -1;
end
best_so_far = inf;
for i = 1 : length(TRAIN_class_labels)
    if skip_idx == i
        continue;
    end
    compare_to_this_object = squeeze(TRAIN(i,:, :))';
    %distance = sqrt(sum((compare_to_this_object - unknown_object).^2)); % Euclidean distance
    %distance = dtw(compare_to_this_object, unknown_object, 4, 'euclidean');
    %distance = shape_dtw_dist(compare_to_this_object, unknown_object);
    distance = dtw_cons_md_mex(compare_to_this_object, unknown_object, int32(win), 'eu');
    if distance < best_so_far
        predicted_class = TRAIN_class_labels(i);
        best_so_far = distance;
    end
end
end

function slope_thres = get_slope_threshold(dd, w)
%%% Find slopes that define increase
ns = size(dd, 1); T = size(dd, 2); slope_time = T;

slope_thres = zeros(ns, 1);
for cid = 1:ns
    slope_thres(cid) = max(movmean(abs(diff(dd(cid, 1:slope_time))), [0 w-1]));
end
slope_thres = median(slope_thres);
end