%% Count NaNs and Include in Error Bars:  

% Define the trial conditions and their repetitions
repeated_conditions = {
    'M', {'M1', 'M2', 'M3'};
    %'IM', {'IM1', 'IM2', 'IM3'};
    'O', {'O1', 'O2', 'O3'};
    %'IO', {'IO1', 'IO2', 'IO3'}
};

% Specify participants to include
participants_to_include = [3, 16, 21, 12, 5, 14, 15]; 

% Get the number of bins (assuming it is 12)
num_bins = 12;

% Initialize arrays to store mean, standard error, and NaN proportion data for each distinct condition
distinct_conditions = repeated_conditions(:, 1);
mean_data = zeros(length(distinct_conditions), num_bins);
stderr_data = zeros(length(distinct_conditions), num_bins);
nan_proportion_data = zeros(length(distinct_conditions), num_bins);

% Loop through each distinct condition
for condition_idx = 1:length(distinct_conditions)
    condition_name = distinct_conditions{condition_idx};
    repetitions = repeated_conditions{condition_idx, 2};
    
    % Initialize arrays to store aggregated data across repetitions
    aggregated_data_per_bin = cell(1, num_bins);
    
    % Loop through each repetition of the current condition
    for rep_idx = 1:length(repetitions)
        trial_condition = repetitions{rep_idx};
        
        % Loop through each bin to aggregate data
        for segment_num = 1:num_bins
            % Loop through each specified participant in the selected trial condition
            trial_data = segmentedRelPhaseStruct.(trial_condition);
            for p = participants_to_include
                field_name = ['Segment', num2str(segment_num)];
                if isfield(trial_data(p), field_name)
                    relPhase_data = trial_data(p).(field_name);
                    
                    if ~isempty(relPhase_data)
                        % Flatten the data to a single vector (if it is a matrix)
                        relPhase_data = relPhase_data(:);
                        
                        % Append the data to the aggregated_data_per_bin array
                        if isempty(aggregated_data_per_bin{segment_num})
                            aggregated_data_per_bin{segment_num} = relPhase_data;
                        else
                            aggregated_data_per_bin{segment_num} = [aggregated_data_per_bin{segment_num}; relPhase_data];
                        end
                    end
                end
            end
        end
    end
    
    % Calculate mean, standard error, and NaN proportion for each bin
    for segment_num = 1:num_bins
        aggregated_data = aggregated_data_per_bin{segment_num};
        
        if ~isempty(aggregated_data)
            nan_count = sum(isnan(aggregated_data));
            valid_count = sum(~isnan(aggregated_data));
            total_count = length(aggregated_data);
            
            mean_data(condition_idx, segment_num) = nanmean(aggregated_data);
            stderr_data(condition_idx, segment_num) = nanstd(aggregated_data) / sqrt(valid_count);
            nan_proportion_data(condition_idx, segment_num) = nan_count / total_count;
            
            % Adjust the error bar to reflect the proportion of NaNs
            stderr_data(condition_idx, segment_num) = stderr_data(condition_idx, segment_num) + (nan_proportion_data(condition_idx, segment_num) * 360);  % Adjust scale as needed
            
            % Debugging: Print the mean, standard error, and NaN proportion for the current bin
            fprintf('Condition: %s, Bin: %d, Mean: %.2f, StdErr: %.2f, NaN Proportion: %.2f\n', condition_name, segment_num, mean_data(condition_idx, segment_num), stderr_data(condition_idx, segment_num), nan_proportion_data(condition_idx, segment_num));
        else
            mean_data(condition_idx, segment_num) = NaN;
            stderr_data(condition_idx, segment_num) = NaN;
            nan_proportion_data(condition_idx, segment_num) = NaN;
            
            % Debugging: Print a message indicating why mean, stderr, and NaN proportion are NaN
            fprintf('Mean, StdErr, and NaN Proportion are NaN for Condition: %s, Bin: %d\n', condition_name, segment_num);
        end
    end
end

% Create a plot with error bars for each distinct condition
figure;
hold on;
colors = lines(length(distinct_conditions));  % Generate distinct colors for each condition

for condition_idx = 1:length(distinct_conditions)
    errorbar(1:num_bins, mean_data(condition_idx, :), stderr_data(condition_idx, :), 'o-', ...
        'LineWidth', 2, 'MarkerSize', 8, 'Color', colors(condition_idx, :));
end

% Customize plot
title(['Mean relPhase for Multiple Conditions (Participants: ', num2str(participants_to_include), ')']);
xlabel('Bin Number');
ylabel('Mean relPhase (degrees)');
xlim([1, num_bins]);
ylim([0, 360]);
xticks(1:num_bins);
yticks([0, 120, 180, 240, 360]);
yline(180, '-');
yline(180+60, '--');
yline(180-60, '--');
legend(distinct_conditions, 'Location', 'Best');
grid on;
hold off;