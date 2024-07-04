% Assuming segmentedRelPhaseStruct is already created and loaded in the workspace

trial_conditions_to_include = {'M1','M2','M3'}; % Specify the trial condition to plot

participants_to_include = [2,3,4,5,6,7,8,9,10,12,14,15,16,17,18,19,21,22];  % Specify participants to include 

num_bins = 12; % Get the number of bins (assuming it is 12)

% Initialize cell arrays to store mean and standard error data for each condition
mean_data = zeros(length(trial_conditions_to_include), num_bins);
stderr_data = zeros(length(trial_conditions_to_include), num_bins);

% Loop through each trial condition
for trial_idx = 1:length(trial_conditions_to_include)
    trial_condition = trial_conditions_to_include{trial_idx};
    
    % Loop through each bin to calculate mean and standard error
    for segment_num = 1:num_bins
        aggregated_data = [];  % Initialize an empty array to store aggregated data for the current bin
        
        % Loop through each specified participant in the selected trial condition
        trial_data = segmentedRelPhaseStruct.(trial_condition);
        for p = participants_to_include
            field_name = ['Segment', num2str(segment_num)];
            if isfield(trial_data(p), field_name)
                relPhase_data = trial_data(p).(field_name);
                
                if ~isempty(relPhase_data)
                    % Flatten the data to a single vector (if it is a matrix)
                    relPhase_data = relPhase_data(:);
                    
                    % Append the data to the aggregated_data array
                    aggregated_data = [aggregated_data; relPhase_data];
                end
            end
        end
        
        % Debugging: Print the aggregated data for the current bin
        fprintf('Trial: %s, Bin: %d, Aggregated Data: %s\n', trial_condition, segment_num, mat2str(aggregated_data));
        
        % Calculate mean and standard error for the current bin
        if ~isempty(aggregated_data)
            mean_data(trial_idx, segment_num) = nanmean(aggregated_data);
            stderr_data(trial_idx, segment_num) = nanstd(aggregated_data) / sqrt(sum(~isnan(aggregated_data)));
            
            % Debugging: Print the mean and standard error for the current bin
            fprintf('Mean: %.2f, StdErr: %.2f\n', mean_data(trial_idx, segment_num), stderr_data(trial_idx, segment_num));
        else
            mean_data(trial_idx, segment_num) = NaN;
            stderr_data(trial_idx, segment_num) = NaN;
            
            % Debugging: Print a message indicating why mean and stderr are NaN
            fprintf('Mean and StdErr are NaN for Trial: %s, Bin: %d\n', trial_condition, segment_num);
        end
    end
end

% Create a plot with error bars for each condition
figure;
hold on;
colors = lines(length(trial_conditions_to_include));  % Generate distinct colors for each condition

for trial_idx = 1:length(trial_conditions_to_include)
    errorbar(1:num_bins, mean_data(trial_idx, :), stderr_data(trial_idx, :), 'o-', ...
        'LineWidth', 2, 'MarkerSize', 8, 'Color', colors(trial_idx, :));
end

% Plot
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
legend(trial_conditions_to_include, 'Location', 'Best');
grid on;
hold off;