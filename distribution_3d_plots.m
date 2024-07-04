%% 3D Distribution Plots

% Assuming segmentedRelPhaseStruct is already created and loaded in the workspace
% Specify the trial conditions to plot (example: {'IM1', 'IM2', 'IM3'})
trial_conditions_to_include = {'IM1', 'IM2', 'IM3'};

% Specify participants to include (example: [1, 2, 5])
participants_to_include = [3,16,21,22];  % Specify the participant indices you want to include

% Get the number of bins (assuming it is 12)
num_bins = 12;

% Initialize a cell array to store aggregated data for each bin across all trial conditions
aggregated_data = cell(1, num_bins);

% Loop through each specified trial condition
for trial_idx = 1:length(trial_conditions_to_include)
    trial_condition = trial_conditions_to_include{trial_idx};
    
    % Loop through each specified participant in the selected trial condition
    trial_data = segmentedRelPhaseStruct.(trial_condition);
    for p = participants_to_include
        % Loop through each bin
        for segment_num = 1:num_bins
            field_name = ['Segment', num2str(segment_num)];
            relPhase_data = trial_data(p).(field_name);
            
            if ~isempty(relPhase_data)
                % Flatten the data to a single vector (if it is a matrix)
                relPhase_data = relPhase_data(:);
                
                % Append the data to the corresponding bin in aggregated_data
                aggregated_data{segment_num} = [aggregated_data{segment_num}; relPhase_data];
            end
        end
    end
end

% Prepare data for 3D plot
edges = 0:10:360; % Define edges for the histogram bins
counts_matrix = zeros(num_bins, length(edges)-1); % Initialize matrix to store histogram counts

% Loop through each bin to calculate histogram counts
for segment_num = 1:num_bins
    [counts, ~] = histcounts(aggregated_data{segment_num}, edges);
    counts_matrix(segment_num, :) = counts;
end

% Create 3D bar plot
figure;
bar3(edges(1:end-1), counts_matrix', 'detached');

% Adjust plot appearance
xlabel('Bin Number');
ylabel('Relative Phase (degrees)');
zlabel('Occurrence');
set(gca, 'XTick', 1:num_bins, 'XTickLabel', 1:num_bins);
set(gca, 'YLim', [0 360], 'YTick', [0 120 180 240 360], 'YTickLabel', {'0', '120', '180', '240', '360'});

% Add a main title to the figure
title(['3D Distribution of relPhase for Trials: ', strjoin(trial_conditions_to_include, ', '), ' (Participants: ', num2str(participants_to_include), ')']);