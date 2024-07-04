%% Break up Relative Phase Data into Frequency Bins

% Assuming newStruct is already created and loaded in the workspace
trial_conditions = fieldnames(newStruct);

% Initialize a new structure to store the segmented relPhase values
segmentedRelPhaseStruct = struct();

% Loop through each trial condition
for t = 1:length(trial_conditions)
    % Get the data for the current trial condition
    trial_data = newStruct.(trial_conditions{t});
    
    % Initialize a struct to store segmented relPhase values for the current trial condition
    segmentedRelPhase = struct();
    
    % Loop through each participant in the current trial condition
    for p = 1:length(trial_data)
        % Check if the participant's data is not empty and contains the required fields
        if isfield(trial_data(p), 'relPhase') && isfield(trial_data(p), 'PkPosLocR') && isfield(trial_data(p), 'TenthPeaks') ...
                && ~isempty(trial_data(p).relPhase) && ~isempty(trial_data(p).PkPosLocR) && ~isempty(trial_data(p).TenthPeaks)
            
            % Initialize cell array to store segments
            segments = cell(1, 12);
            
            % Loop through each segment
            start_idx = 1;
            for segment_num = 1:12
                if segment_num <= length(trial_data(p).TenthPeaks)
                    % Get the metronome peak for the current segment
                    currentpk = trial_data(p).TenthPeaks(segment_num);
                    
                    % Find the last index where PkPosLocR is less than or equal to currentpk
                    end_idx = find(trial_data(p).PkPosLocR <= currentpk, 1, 'last');
                    
                    % Segment the relPhase data
                    if ~isempty(end_idx) && end_idx >= start_idx
                        segments{segment_num} = double(trial_data(p).relPhase(start_idx:end_idx, :));
                        start_idx = end_idx + 1; % Update the start index for the next segment
                    else
                        segments{segment_num} = []; % If no valid end_idx found, store an empty array
                    end
                else
                    segments{segment_num} = []; % If there are fewer than 12 TenthPeaks, store an empty array
                end
            end
            
            % Save the segmented data in the structure
            for segment_num = 1:12
                field_name = ['Segment', num2str(segment_num)];
                segmentedRelPhase(p).(field_name) = segments{segment_num};
            end
        else
            % If participant data is empty or missing required fields, store empty arrays
            for segment_num = 1:12
                field_name = ['Segment', num2str(segment_num)];
                segmentedRelPhase(p).(field_name) = [];
            end
        end
    end
    
    % Store the segmented relPhase values for the current trial condition in the main structure
    segmentedRelPhaseStruct.(trial_conditions{t}) = segmentedRelPhase;
end

% Display the new structure with segmented relPhase values
disp(segmentedRelPhaseStruct);