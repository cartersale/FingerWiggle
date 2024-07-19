% Calculating Difference Score based on Cumulative Deviations 

%% 1. Release grip on relative phase 

% Deviation = 1 (including NaN values)    Within Anti-Phase Range = 1
% Using all repetitions for each participant 
% First grouping inverse and non-inverse together 

% Make new structure to separate from dataStruct
trial_conditions = fieldnames(dataStruct);

% Initialize a new structure to store the updated phaseout values
updatedPhaseoutStruct = struct();

% Loop through each trial condition
for t = 1:length(trial_conditions)
    % Get the data for the current trial condition
    trial_data = dataStruct.(trial_conditions{t});
    
    % Initialize a struct to store updated phaseout values for the current trial condition
    updatedPhaseout = struct();
    
    % Loop through each participant in the current trial condition
    for p = 1:length(trial_data)
        % Check if the participant's data is not empty and contains the required fields
        if isfield(trial_data(p), 'relPhase') && isfield(trial_data(p), 'phaseout') ...
                && ~isempty(trial_data(p).relPhase) && ~isempty(trial_data(p).phaseout)
            
            % Get the relPhase and phaseout data
            relPhase_data = trial_data(p).relPhase;
            phaseout_data = trial_data(p).phaseout;
            
            % Initialize updated phaseout data
            updated_phaseout_data = phaseout_data;
            
            % Find NaN values in relPhase and set corresponding phaseout to 1
            nan_indices = isnan(relPhase_data);
            updated_phaseout_data(nan_indices) = 1;
            
            % Save the updated phaseout data in the structure
            updatedPhaseout(p).phaseout = updated_phaseout_data;
            updatedPhaseout(p).relPhase = relPhase_data;  % Optionally keep the relPhase data for reference
        else
            % If participant data is empty or missing required fields, store empty arrays
            updatedPhaseout(p).phaseout = [];
            updatedPhaseout(p).relPhase = [];
        end
    end
    
    % Store the updated phaseout values for the current trial condition in the main structure
    updatedPhaseoutStruct.(trial_conditions{t}) = updatedPhaseout;
end

%% 2. Calculate Total # of Deviations and Save to Structure

% Initialize a new structure to store the total deviations
totalDeviationsStruct = struct();

% Loop through each trial condition
for t = 1:length(trial_conditions)
    % Get the data for the current trial condition
    trial_data = updatedPhaseoutStruct.(trial_conditions{t});
    
    % Initialize a struct to store total deviations for the current trial condition
    totalDeviations = struct();
    
    % Loop through each participant in the current trial condition
    for p = 1:length(trial_data)
        % Check if the participant's data is not empty and contains the required fields
        if isfield(trial_data(p), 'phaseout') && ~isempty(trial_data(p).phaseout)
            
            % Get the phaseout data
            phaseout_data = trial_data(p).phaseout;
            
            % Calculate the total deviations
            total_deviations = sum(phaseout_data == 1);
            
            % Save the total deviations in the structure
            totalDeviations(p).totalDeviations = total_deviations;
            totalDeviations(p).phaseout = phaseout_data;  % Optionally keep the phaseout data for reference
        else
            % If participant data is empty or missing required fields, store empty arrays
            totalDeviations(p).totalDeviations = NaN;
            totalDeviations(p).phaseout = [];
        end
    end
    
    % Store the total deviations for the current trial condition in the main structure
    totalDeviationsStruct.(trial_conditions{t}) = totalDeviations;
end

%% 3. Grouping into 2 Conditions (M+IM, O+IO) and Calculate Difference Score

trial_conditions = fieldnames(totalDeviationsStruct);
condition_groups = {
    'M_IM', {'M1', 'M2', 'M3', 'IM1', 'IM2', 'IM3'};
    'O_IO', {'O1', 'O2', 'O3', 'IO1', 'IO2', 'IO3'}
};

% Initialize a new structure to store the total deviations across conditions
totalDeviationsAcrossConditions = struct();
difference_scores = struct();

% Loop through each condition group
for g = 1:size(condition_groups, 1)
    condition_name = condition_groups{g, 1};
    condition_trials = condition_groups{g, 2};
    
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
    totalDeviationsAcrossConditions.(condition_name) = totalDeviationsGroup;
end

% Calculate the difference scores (M+IM minus O+IO) for each participant
M_IM_deviations = totalDeviationsAcrossConditions.('M_IM');
O_IO_deviations = totalDeviationsAcrossConditions.('O_IO');

participant_ids_M_IM = {M_IM_deviations.participantID};
participant_ids_O_IO = {O_IO_deviations.participantID};

for p = 1:length(participant_ids_M_IM)
    participant_id = participant_ids_M_IM{p};
    idx_O_IO = find([O_IO_deviations.participantID] == participant_id);
    if ~isempty(idx_O_IO)
        difference_scores(p).participantID = participant_id;  % Store participant ID
        difference_scores(p).difference = M_IM_deviations(p).totalDeviations - O_IO_deviations(idx_O_IO).totalDeviations;
    else
        difference_scores(p).participantID = participant_id;  % Store participant ID
        difference_scores(p).difference = M_IM_deviations(p).totalDeviations;
    end
end

for p = 1:length(participant_ids_O_IO)
    participant_id = participant_ids_O_IO{p};
    idx_M_IM = find([M_IM_deviations.participantID] == participant_id);
    if isempty(idx_M_IM)
        difference_scores(end+1).participantID = participant_id;  % Store participant ID
        difference_scores(end).difference = -O_IO_deviations(p).totalDeviations;
    end
end

% Add the difference scores to the main structure
totalDeviationsAcrossConditions.Difference_Scores = difference_scores;


%% 5. Grouping into 4 Conditions (M,IM,O,IO) and Calculate Difference Score

trial_conditions = fieldnames(totalDeviationsStruct);
condition_groups = {
    'M', {'M1', 'M2', 'M3'};
    'IM', {'IM1', 'IM2', 'IM3'};
    'O', {'O1', 'O2', 'O3'};
    'IO', {'IO1', 'IO2', 'IO3'}
};

% Initialize a new structure to store the total deviations across conditions
totalDeviationsAcrossConditions_4Groups = struct();
difference_scores_4Groups = struct();

% Loop through each condition group
for g = 1:size(condition_groups, 1)
    condition_name = condition_groups{g, 1};
    condition_trials = condition_groups{g, 2};
    
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
    totalDeviationsAcrossConditions_4Groups.(condition_name) = totalDeviationsGroup;
end

% Calculate the difference scores for each participant
M_deviations = totalDeviationsAcrossConditions_4Groups.M;
IM_deviations = totalDeviationsAcrossConditions_4Groups.IM;
O_deviations = totalDeviationsAcrossConditions_4Groups.O;
IO_deviations = totalDeviationsAcrossConditions_4Groups.IO;

participant_ids_M = [M_deviations.participantID];
participant_ids_IM = [IM_deviations.participantID];
participant_ids_O = [O_deviations.participantID];
participant_ids_IO = [IO_deviations.participantID];

% Initialize a structure to store difference scores
difference_scores_4Groups.M_O = struct();
difference_scores_4Groups.IM_IO = struct();
difference_scores_4Groups.M_IM = struct();
difference_scores_4Groups.O_IO = struct();

% Calculate M - O
for p = 1:length(participant_ids_M)
    participant_id = participant_ids_M(p);
    idx_O = find(participant_ids_O == participant_id, 1);
    if ~isempty(idx_O)
        difference_scores_4Groups.M_O(p).participantID = participant_id;  % Store participant ID
        difference_scores_4Groups.M_O(p).difference = M_deviations(p).totalDeviations - O_deviations(idx_O).totalDeviations;
    else
        difference_scores_4Groups.M_O(p).participantID = participant_id;  % Store participant ID
        difference_scores_4Groups.M_O(p).difference = M_deviations(p).totalDeviations;
    end
end

% Calculate IM - IO
for p = 1:length(participant_ids_IM)
    participant_id = participant_ids_IM(p);
    idx_IO = find(participant_ids_IO == participant_id, 1);
    if ~isempty(idx_IO)
        difference_scores_4Groups.IM_IO(p).participantID = participant_id;  % Store participant ID
        difference_scores_4Groups.IM_IO(p).difference = IM_deviations(p).totalDeviations - IO_deviations(idx_IO).totalDeviations;
    else
        difference_scores_4Groups.IM_IO(p).participantID = participant_id;  % Store participant ID
        difference_scores_4Groups.IM_IO(p).difference = IM_deviations(p).totalDeviations;
    end
end

% Calculate M - IM
for p = 1:length(participant_ids_M)
    participant_id = participant_ids_M(p);
    idx_IM = find(participant_ids_IM == participant_id, 1);
    if ~isempty(idx_IM)
        difference_scores_4Groups.M_IM(p).participantID = participant_id;  % Store participant ID
        difference_scores_4Groups.M_IM(p).difference = M_deviations(p).totalDeviations - IM_deviations(idx_IM).totalDeviations;
    else
        difference_scores_4Groups.M_IM(p).participantID = participant_id;  % Store participant ID
        difference_scores_4Groups.M_IM(p).difference = M_deviations(p).totalDeviations;
    end
end

% Calculate O - IO
for p = 1:length(participant_ids_O)
    participant_id = participant_ids_O(p);
    idx_IO = find(participant_ids_IO == participant_id, 1);
    if ~isempty(idx_IO)
        difference_scores_4Groups.O_IO(p).participantID = participant_id;  % Store participant ID
        difference_scores_4Groups.O_IO(p).difference = O_deviations(p).totalDeviations - IO_deviations(idx_IO).totalDeviations;
    else
        difference_scores_4Groups.O_IO(p).participantID = participant_id;  % Store participant ID
        difference_scores_4Groups.O_IO(p).difference = O_deviations(p).totalDeviations;
    end
end

% Store the difference scores in the main structure
totalDeviationsAcrossConditions_4Groups.Difference_Scores = difference_scores_4Groups;



