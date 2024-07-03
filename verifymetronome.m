trial_conditions = fieldnames(dataStruct);

% New structure to store frequencies
frequencyStruct = struct();

% Loop through trial conditions
for t = 1:length(trial_conditions)
    % Get the data for current trial condition
    trial_data = dataStruct.(trial_conditions{t});
    
    % Initialize a struct to store frequencies for current trial 
    trial_frequencies = struct();
    
    % Loop through each participant (row) in the current trial 
    for p = 1:length(trial_data)
        % Check if the participant's data is not empty
        if ~isempty(trial_data(p).MetronomePkLocs)
            % Get the metronome peak locations for the participant
            metronome_peaks = trial_data(p).MetronomePkLocs;
            
            % an array to store mean periods for each bin
            metbin = [];
            
            % Loop through each bin of 10 peaks to calculate mean periods
            for i = 1:12
                % Ensure we have enough peaks to form a full bin
                if (1 + 10*(i-1) <= length(metronome_peaks)) && (10*i <= length(metronome_peaks))
                    % Calculate the mean period for the current bin
                    metbin(i) = mean(diff(metronome_peaks(1 + 10*(i-1):10*i)));
                else
                    % If not enough peaks, store NaN
                    metbin(i) = NaN;
                end
            end
            
            % Calculate the frequencies for each bin in Hz
            metfq = 1 ./ metbin;
            
            % Multiply frequencies by 100
            metfq = metfq * 100;
            
            % Store the bin frequencies for the current participant in the structure
            trial_frequencies(p).BinFrequencies = metfq;
        else
            % If participant data is empty, store an empty array
            trial_frequencies(p).BinFrequencies = [];
        end
    end
    
    % Store the frequencies for the current trial condition in the main structure
    frequencyStruct.(trial_conditions{t}) = trial_frequencies;
end

% Display the structure with frequencies
disp(frequencyStruct);
