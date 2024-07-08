%% Mixed Model ANOVA

% Define the trial conditions and their repetitions
repeated_conditions = {
    'M', {'M1', 'M2', 'M3'};
    'IM', {'IM1', 'IM2', 'IM3'};
    'O', {'O1', 'O2', 'O3'};
    'IO', {'IO1', 'IO2', 'IO3'}
};

% Specify participants to include (example: [1, 2, 5])
participants_to_include = [2,3,4,5,6,7,8,9,10,12,14,15,16,17,18,19,21,22]; 

% Get the number of bins (assuming it is 12)
num_bins = 12;

% Initialize arrays to store the data
relPhase_data_all = [];
bin_numbers = [];
condition_labels = [];
participant_ids = [];

% Loop through each distinct condition
for condition_idx = 1:length(repeated_conditions)
    condition_name = repeated_conditions{condition_idx, 1};
    repetitions = repeated_conditions{condition_idx, 2};
    
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
                        
                        % Append the data to the arrays
                        relPhase_data_all = [relPhase_data_all; relPhase_data];
                        bin_numbers = [bin_numbers; repmat(segment_num, length(relPhase_data), 1)];
                        condition_labels = [condition_labels; repmat({condition_name}, length(relPhase_data), 1)];
                        participant_ids = [participant_ids; repmat(p, length(relPhase_data), 1)];
                    end
                end
            end
        end
    end
end

% Convert to categorical variables
bin_numbers = categorical(bin_numbers);
condition_labels = categorical(condition_labels);
participant_ids = categorical(participant_ids);

% Create a table for the mixed model
data_table = table(relPhase_data_all, bin_numbers, condition_labels, participant_ids, ...
                   'VariableNames', {'relPhase', 'Bin', 'Condition', 'Participant'});

% Fit the mixed model
lme = fitlme(data_table, 'relPhase ~ Bin * Condition + (1|Participant)');

% Perform ANOVA
anova_results = anova(lme);

% Display the results
disp('Mixed Model ANOVA Results:');
disp(anova_results);