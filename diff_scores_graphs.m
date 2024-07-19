% Extract difference scores and participant IDs
difference_values = [difference_scores.difference];
participant_ids = [difference_scores.participantID];

% Create figure
figure;

% Box Plot
subplot(2,2,1);
boxplot(difference_values);
yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
title('Box Plot of Difference Scores');
xlabel('Conditions');
ylabel('Difference Score');
grid on;

% Bar Plot with Participant IDs
subplot(2,2,2);
bar(participant_ids, difference_values);
hold on;
yline(mean(difference_values), 'r--', 'LineWidth', 2); % Mean difference score
yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
title('Bar Plot of Participant Difference Scores');
xlabel('Participants');
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

% Add overarching title to the figure
sgtitle('Visualization of Participant Difference Scores Across Conditions');

% Explanation of positive and negative scores
annotation('textbox', [0.1 0.92 0.8 0.05], 'String', 'Positive scores indicate greater deviations in the Mirror condition; Negative scores indicate greater deviations in the Opaque condition.', 'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');

%% For 4 Groups - Same figure
% Extract difference scores for each group
groups = fieldnames(difference_scores_4Groups);

% Create figure
figure;

% Loop through each group and create the plots
for i = 1:length(groups)
    group_name = groups{i};
    group_data = difference_scores_4Groups.(group_name);
    difference_values = [group_data.difference];
    participant_ids = [group_data.participantID];

    % Box Plot
    subplot(4, 4, (i-1)*4 + 1);
    boxplot(difference_values);
    yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
    title(['Box Plot of Difference Scores for ', group_name]);
    xlabel('Conditions');
    ylabel('Difference Score');
    grid on;

    % Bar Plot with Participant IDs
    subplot(4, 4, (i-1)*4 + 2);
    bar(participant_ids, difference_values);
    hold on;
    yline(mean(difference_values), 'r--', 'LineWidth', 2); % Mean difference score
    yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
    title(['Bar Plot of Participant Difference Scores for ', group_name]);
    xlabel('Participants');
    ylabel('Difference Score');
    grid on;
    legend('Difference Score', 'Mean Difference Score');

    % Scatter Plot
    subplot(4, 4, (i-1)*4 + 3);
    scatter(participant_ids, difference_values, 'filled');
    yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
    title(['Scatter Plot of Participant Difference Scores for ', group_name]);
    xlabel('Participant ID');
    ylabel('Difference Score');
    grid on;

    % Histogram
    subplot(4, 4, (i-1)*4 + 4);
    histogram(difference_values, 'BinWidth', 5); % Adjust BinWidth as necessary
    yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
    title(['Histogram of Difference Scores for ', group_name]);
    xlabel('Difference Score');
    ylabel('Frequency');
    grid on;
end

% Add overarching title to the figure
sgtitle('Visualization of Participant Difference Scores Across Four Groups');

% Explanation of positive and negative scores
annotation('textbox', [0.1 0.92 0.8 0.05], 'String', 'Positive scores indicate greater deviations in the first condition of each pair; Negative scores indicate greater deviations in the second condition of each pair.', 'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');

%% 4 Groupings - Different Figures

% Extract difference scores for each group
groups = fieldnames(difference_scores_4Groups);

% Loop through each group and create separate figures
for i = 1:length(groups)
    group_name = groups{i};
    group_data = difference_scores_4Groups.(group_name);
    difference_values = [group_data.difference];
    participant_ids = [group_data.participantID];

    % Create a new figure for each group
    figure;
    
    % Box Plot
    subplot(2, 2, 1);
    boxplot(difference_values);
    yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
    title(['Box Plot of Difference Scores for ', group_name]);
    xlabel('Conditions');
    ylabel('Difference Score');
    grid on;

    % Bar Plot with Participant IDs
    subplot(2, 2, 2);
    bar(participant_ids, difference_values);
    hold on;
    yline(mean(difference_values), 'r--', 'LineWidth', 2); % Mean difference score
    yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
    title(['Bar Plot of Participant Difference Scores for ', group_name]);
    xlabel('Participants');
    ylabel('Difference Score');
    grid on;
    legend('Difference Score', 'Mean Difference Score');

    % Scatter Plot
    subplot(2, 2, 3);
    scatter(participant_ids, difference_values, 'filled');
    yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
    title(['Scatter Plot of Participant Difference Scores for ', group_name]);
    xlabel('Participant ID');
    ylabel('Difference Score');
    grid on;

    % Histogram
    subplot(2, 2, 4);
    histogram(difference_values, 'BinWidth', 5); % Adjust BinWidth as necessary
    yline(0, 'k--', 'LineWidth', 2); % Add a horizontal line at y = 0
    title(['Histogram of Difference Scores for ', group_name]);
    xlabel('Difference Score');
    ylabel('Frequency');
    grid on;

    % Add overarching title to the figure
    sgtitle(['Visualization of Participant Difference Scores for ', group_name]);

    % Explanation of positive and negative scores
    annotation('textbox', [0.1 0.92 0.8 0.05], 'String', 'Positive scores indicate greater deviations in the first condition of each pair; Negative scores indicate greater deviations in the second condition of each pair.', 'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
end
