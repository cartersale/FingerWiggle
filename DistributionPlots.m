% Assuming segmentedRelPhaseStruct is already created and loaded in the workspace
% Select the trial condition to plot
trial_condition = 'IM1';

% Specify participants to include 
participants_to_include = [1, 2, 5]; 

% Get the number of bins (assuming it is 12)
num_bins = 12;

% Initialize a cell array to store aggregated data for each bin
aggregated_data = cell(1, num_bins);

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

% Create subplots for each bin
figure;
for segment_num = 1:num_bins
    subplot(1, num_bins, segment_num);
    histogram(aggregated_data{segment_num});
    title(['Bin ', num2str(segment_num)]);
    xlabel('relPhase');
    ylabel('Occurrence');
    xlim([0, 360]);  % Adjusted to fit standardized relPhase values
    xline(180, '-');
    xline(180+60, '--');
    xline(180-60, '--');
end

% Add a main title to the figure
sgtitle(['Distribution of relPhase for ', trial_condition, ' (Participants: ', num2str(participants_to_include), ')']);
