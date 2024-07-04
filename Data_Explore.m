% Data Explore Updated 6/21/2024 10PM

ID = 2;
search_field = 'M1';
field_idx = find(strcmp(field_names, search_field));

%% Finger Positions
figure;
 tiledlayout(10,1)
 nexttile([3,1])
 plot((1:length(dataStruct.(field_names{field_idx})(ID).Rend_X))/100,dataStruct.(field_names{field_idx})(ID).Rend_X,'LineWidth',1); hold all;
 plot((1:length(dataStruct.(field_names{field_idx})(ID).Lend_X))/100,dataStruct.(field_names{field_idx})(ID).Lend_X,'LineWidth',1)
 
legend('Right', 'Left','Location','northeastoutside')
title(['Participant #' num2str(ID) ' - Mirror Condition'])
ylabel('Finger Position (mm)')
set(gca,'FontSize', 18)
%xlim([58 61])
%xlim([0 89])
curtick = get(gca, 'XTick');
set(gca, 'XTick', unique(round(curtick)))

%% Phase Angles

 nexttile([2,1]) 
Langle = 180*angle(hilbert(dataStruct.(field_names{field_idx})(ID).Lend_X))/pi;
plot((1:length(dataStruct.(field_names{field_idx})(ID).Rend_X))/100,180*angle(hilbert(dataStruct.(field_names{field_idx})(ID).Rend_X))/pi,'LineWidth',1); hold all;
plot((1:length(dataStruct.(field_names{field_idx})(ID).Lend_X))/100,180*angle(hilbert(dataStruct.(field_names{field_idx})(ID).Lend_X))/pi,'LineWidth',1)
%plot(dataStruct.(field_names{field_idx})(ID).PkPosLocR/100,180*dataStruct.(field_names{field_idx})(ID).PkPosR/pi,'o','MarkerSize',6,'LineWidth',2,'Color',[0.00,0.45,0.74]) 
%plot(dataStruct.(field_names{field_idx})(ID).PkPosLocR/100,Langle(dataStruct.(field_names{field_idx})(ID).PkPosLocR),'o','MarkerSize',6,'LineWidth',2,'Color',[0.85,0.33,0.10]) 

legend('Right', 'Left','Location','northeastoutside')
title('Phase Angle')
ylabel('Angle (Degrees)')
set(gca,'FontSize', 18)
yticks([-180 0 180])
%xlim([58 61])
%xlim([0 89])
curtick = get(gca, 'XTick');
set(gca, 'XTick', unique(round(curtick)))

%% Relative Phase
 nexttile([3,1])
 figure;
 plot(dataStruct.(field_names{field_idx})(ID).PkPosLocR/100,(180*dataStruct.(field_names{field_idx})(ID).relPhase/pi),'ro','LineWidth',2);
yline(180,'-')
yline(180+60,'--')
yline(180-60,'--')
yticks([0 (180-60) 180 (180+60) 360])
yticklabels({'0','120', '180' ,'240','360'})
ylabel('Degrees')
ylim([0 360])

yyaxis right
yticks([0 (180-60) 180 (180+60) 360])
yticklabels({'in-phase','lower bound', 'anti-phase' ,'upper bound','in-phase'})
%colororder({'b','m'})
title('Relative Phase')
%xlabel('Time (s)')
ylim([0 360])
set(gca,'FontSize', 18)

%xlim([58 61])
%xlim([0 89])
curtick = get(gca, 'XTick');
set(gca, 'XTick', unique(round(curtick)))


%% Cumulative Deviations from Anti-Phase

nexttile([2,1])
plot((dataStruct.(field_names{field_idx})(ID).PkPosLocR)/100,cumsum(dataStruct.(field_names{field_idx})(ID).phaseout),'LineWidth',2)
ylabel('Cum. Deviations')
xlabel('Time (s)')
title('Cumulative Devations from Anti-Phase')
set(gca,'FontSize', 18)
%xlim([58 61])
%xlim([0 89])

curtick = get(gca, 'XTick');
set(gca, 'XTick', unique(round(curtick)))
curtick = get(gca, 'YTick');
set(gca, 'YTick', unique(round(curtick)))


Right = dataStruct.M3(10).Rend_X;
Left = dataStruct.M3(10).Lend_X;
%time = 1:length(Right);

%% Velocity and Acceleration

velocity_Right = diff(Right);
velocity_Left = diff(Left);

%time_velocity = time(1:end-1) + diff(time)/2;

acceleration_Right = diff(velocity_Right); 
acceleration_Left = diff(velocity_Left); 

% Plot position
figure;
subplot(3,1,1);
plot(Right)
hold on
plot(Left)
title('Position');
xlabel('Time (s)');
ylabel('Position (m)');
legend('Right', 'Left');

% Plot velocity
subplot(3,1,2);
plot(velocity_Left)
hold on
plot(velocity_Right)
title('Velocity');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend('Right', 'Left');

% Plot acceleration
subplot(3,1,3);
plot(acceleration_Right)
hold on
plot(acceleration_Left)
title('Acceleration');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
legend('Right', 'Left');

% Adjust layout for better visualization
sgtitle('Position, Velocity, and Acceleration of Right and Left');


%% Phase Space Plot
figure;
% Set up the phase space plot for "Right"
subplot(2,1,1);
hRight = plot(Right(1), velocity_Right(1), 'b');
title('Phase Space Plot for Right Fingers');
xlabel('Position (m)');
ylabel('Velocity (m/s)');
grid on;
xlim([min(Right) max(Right)]);
ylim([min(velocity_Right) max(velocity_Right)]);
time = 1:length(Right);
timeTextRight = text(0.05, 0.9, sprintf('Time: %.1f f', time(1)), 'Units', 'normalized', 'FontSize', 10, 'Color', 'b');
% Set up the phase space plot for "Left"
subplot(2,1,2);
hLeft = plot(Left(1), velocity_Left(1), 'r');
title('Phase Space Plot for Left Limb');
xlabel('Position (m)');
ylabel('Velocity (m/s)');
grid on;
xlim([min(Left) max(Left)]);
ylim([min(velocity_Left) max(velocity_Left)]);
timeTextLeft = text(0.05, 0.9, sprintf('Time: %.1f f', time(1)), 'Units', 'normalized', 'FontSize', 10, 'Color', 'r');
% Animate the phase space plots
for k = 2:length(velocity_Right)
    % Update the data for "Right"
    set(hRight, 'XData', Right(1:k), 'YData', velocity_Right(1:k));
    % Update the time counter for "Right"
    set(timeTextRight, 'String', sprintf('Time: %.1f s', time(k)));
    
    % Update the data for "Left"
    set(hLeft, 'XData', Left(1:k), 'YData', velocity_Left(1:k));
    % Update the time counter for "Left"
    set(timeTextLeft, 'String', sprintf('Time: %.1f s', time(k)));
    
    % Pause to create animation effect
    pause(0.01);
end

% Adjust layout for better visualization
sgtitle('Animated Phase Space Plots for Right and Left Limbs');







