%% Effects of Barrier Direction regardless of barrier type
% Initialize the structure to store the total deviations across the new groups
totalDeviationsAcrossConditions_2Groups = struct();
difference_scores_2Groups = struct();

% Define the condition groups for the new comparison
condition_groups_new = {
    'M_O', {'M1', 'M2', 'M3', 'O1', 'O2', 'O3'};
    'IM_IO', {'IM1', 'IM2', 'IM3', 'IO1', 'IO2', 'IO3'}
};

% Loop through each condition group
for g = 1:size(condition_groups_new, 1)
    condition_name = condition_groups_new{g, 1};
    condition_trials = condition_groups_new{g, 2};
    
    % Initialize a dictionary to accumulate deviations per participant
    deviations_dict = containers.Map('KeyType', 'double', 'ValueType', 'double');
    
    % Loop through each trial in the current condition group
    for t = 1:length(condition_trials)
        trial_condition = condition_trials{t};
        
        % Get the data for the current trial condition
        trial_data = totalDeviationsStruct.(trial_condition);
        
        % Loop through each participant in the current trial condition
        for p = 1:length(trial_data)
            if isfield(trial_data(p), 'totalDeviations') && ~isnan(trial_data(p).totalDeviations)
                participant_id = p;
                if isKey(deviations_dict, participant_id)
                    deviations_dict(participant_id) = deviations_dict(participant_id) + trial_data(p).totalDeviations;
                else
                    deviations_dict(participant_id) = trial_data(p).totalDeviations;
                end
            end
        end
    end
    
    % Store the total deviations for each participant in the current condition group
    participant_ids = keys(deviations_dict);
    for p = 1:length(participant_ids)
        participant_id = participant_ids{p};
        totalDeviationsGroup(p).participantID = participant_id;  % Store participant ID
        totalDeviationsGroup(p).totalDeviations = deviations_dict(participant_id);
    end
    
    % Store the total deviations for the current condition group in the main structure
    totalDeviationsAcrossConditions_2Groups.(condition_name) = totalDeviationsGroup;
end

% Calculate the difference scores (M/O minus IM/IO) for each participant
M_O_deviations = totalDeviationsAcrossConditions_2Groups.('M_O');
IM_IO_deviations = totalDeviationsAcrossConditions_2Groups.('IM_IO');

participant_ids_M_O = [M_O_deviations.participantID];
participant_ids_IM_IO = [IM_IO_deviations.participantID];

for p = 1:length(participant_ids_M_O)
    participant_id = participant_ids_M_O(p);
    idx_IM_IO = find(participant_ids_IM_IO == participant_id, 1);
    if ~isempty(idx_IM_IO)
        difference_scores_2Groups(p).participantID = participant_id;  % Store participant ID
        difference_scores_2Groups(p).difference = M_O_deviations(p).totalDeviations - IM_IO_deviations(idx_IM_IO).totalDeviations;
    else
        difference_scores_2Groups(p).participantID = participant_id;  % Store participant ID
        difference_scores_2Groups(p).difference = M_O_deviations(p).totalDeviations;
    end
end

for p = 1:length(participant_ids_IM_IO)
    participant_id = participant_ids_IM_IO(p);
    idx_M_O = find(participant_ids_M_O == participant_id, 1);
    if isempty(idx_M_O)
        difference_scores_2Groups(end+1).participantID = participant_id;  % Store participant ID
        difference_scores_2Groups(end).difference = -IM_IO_deviations(p).totalDeviations;
    end
end

% Plot the results
difference_values = [difference_scores_2Groups.difference];
participant_ids = [difference_scores_2Groups.participantID];

% Box Plot
figure;
subplot(2,2,1);
boxplot(difference_values);
yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
title('Box Plot of Difference Scores (M/O - IM/IO)');
xlabel('Conditions');
ylabel('Difference Score');
grid on;

% Bar Plot
subplot(2,2,2);
bar(participant_ids, difference_values);
hold on;
yline(mean(difference_values), 'r--', 'LineWidth', 2); % Mean difference score
yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
title('Bar Plot of Participant Difference Scores');
xlabel('Participant ID');
ylabel('Difference Score');
grid on;
legend('Difference Score', 'Mean Difference Score');

% Scatter Plot
subplot(2,2,3);
scatter(participant_ids, difference_values, 'filled');
yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
title('Scatter Plot of Participant Difference Scores');
xlabel('Participant ID');
ylabel('Difference Score');
grid on;

% Histogram
subplot(2,2,4);
histogram(difference_values, 'BinWidth', 5); % Adjust BinWidth as necessary
yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
title('Histogram of Difference Scores');
xlabel('Difference Score');
ylabel('Frequency');
grid on;

% Add an overarching title and explanation
sgtitle('Difference Scores (M/O - IM/IO) Across Participants');

annotation('textbox', [0.5, 0, 0, 0.5], 'String', 'Positive scores indicate higher deviations in M/O than IM/IO. Negative scores indicate higher deviations in IM/IO than M/O.', 'FitBoxToText', 'on', 'EdgeColor', 'none');

%% Paired t-test
difference_values = [difference_scores_2Groups.difference];

% Perform the paired t-test
[h, p, ci, stats] = ttest(difference_values);

% Display the results
fprintf('Paired t-test results:\n');
fprintf('t-statistic: %.4f\n', stats.tstat);
fprintf('p-value: %.4f\n', p);
fprintf('Confidence interval: [%.4f, %.4f]\n', ci(1), ci(2));

% Interpret the results
if h == 1
    fprintf('The test rejects the null hypothesis at the 5%% significance level.\n');
    if mean(difference_values) > 0
        fprintf('M/O has significantly more deviations than IM/IO.\n');
    else
        fprintf('IM/IO has significantly more deviations than M/O.\n');
    end
else
    fprintf('The test fails to reject the null hypothesis at the 5%% significance level.\n');
    fprintf('There is no significant difference in deviations between M/O and IM/IO.\n');
end