%% Create New Structure for relPhase and PkPosLocR from dataStruct
trial_conditions = fieldnames(dataStruct);

% Initialize a new structure to store relPhase, PkPosLocR, and metronome timestamps
newStruct = struct();

% Loop through each trial condition
for t = 1:length(trial_conditions)
    % Get the data for the current trial condition
    trial_data = dataStruct.(trial_conditions{t});
    
    % Initialize a struct to store relPhase, PkPosLocR, and metronome timestamps for the current trial condition
    extractedData = struct();
    
    % Loop through each participant (row) in the current trial condition
    for p = 1:length(trial_data)
        % Check if the participant's data is not empty
        if ~isempty(trial_data(p).relPhase) && ~isempty(trial_data(p).PkPosLocR) && ~isempty(trial_data(p).MetronomePkLocs)
            % Extract the relPhase, PkPosLocR, and MetronomePkLocs values for the current participant
            relPhase = trial_data(p).relPhase;
            PkPosLocR = trial_data(p).PkPosLocR;
            MetronomePkLocs = trial_data(p).MetronomePkLocs;
            
            % Extract every 10th value from the metronome peak locations
            tenthPeaks = MetronomePkLocs(10:10:end);
            
            % Store the values in the new structure
            extractedData(p).relPhase = relPhase;
            extractedData(p).PkPosLocR = PkPosLocR;
            extractedData(p).TenthPeaks = tenthPeaks;
        else
            % If participant data is empty, store empty arrays
            extractedData(p).relPhase = [];
            extractedData(p).PkPosLocR = [];
            extractedData(p).TenthPeaks = [];
        end
    end
    
    % Store the extracted data for the current trial condition in the main structure
    newStruct.(trial_conditions{t}) = extractedData;
end

% Display the new structure with relPhase, PkPosLocR, and metronome timestamps
disp(newStruct);