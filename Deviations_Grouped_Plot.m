%% Plot Deviations Together

field_idx = find(strcmp(field_names, search_field));
problem = [3, 12, 16, 21];
IDlistsmall = [2, 4:10,14, 15, 17:19,22];
IDlistfull = IDlist;
IDlist = [7,19,18,10,6,7,4]; %Pick which participants you want to graph (Seems 7 at a time looks the most clear)
%[8,9,10,12,14,15];
%,9,10,12,14,15,16,18,19,21,22];

figure;
tiledlayout(1,2)
nexttile
search_field = 'IM2'; %Pick first trial you want to represent
field_idx = find(strcmp(field_names, search_field));
for i = 1: length(IDlist)
    ID = IDlist(i);
    txt = num2str(IDlist(i));
plot((dataStruct.(field_names{field_idx})(ID).PkPosLocR-dataStruct.(field_names{field_idx})(ID).MetronomePkLocs(1))/100,cumsum(dataStruct.(field_names{field_idx})(ID).phaseout),'LineWidth',2,'DisplayName',txt); hold on;
end
hold off
legend show
legend('Location','northeastoutside')
xlabel('Time (s)')
ylabel('Cumulative Deviated Cycles')
xlim([0 90])
ylim([0 15])
%legend(num2str(IDlist))
%title(['Deviations from Anti-Phase - Condition: ' search_field])
title('Deviations from Anti-Phase - Mirror Condition')
set(gca,'FontSize', 18)

nexttile
search_field = 'IO2'; % Second Trial to represent
field_idx = find(strcmp(field_names, search_field));
for i = 1: length(IDlist)
    ID = IDlist(i);
    txt1 = num2str(IDlist(i));
plot((dataStruct.(field_names{field_idx})(ID).PkPosLocR-dataStruct.(field_names{field_idx})(ID).MetronomePkLocs(1))/100,cumsum(dataStruct.(field_names{field_idx})(ID).phaseout),'LineWidth',2,'DisplayName',txt1); hold on;
end
hold off
legend show
legend('Location','northeastoutside')
xlabel('Time (s)')
ylabel('Cumulative Deviated Cycles')
xlim([0 90])
%legend(num2str(IDlist))
%title(['Deviations from Anti-Phase - Condition: ' search_field])
title('Deviations from Anti-Phase - Opaque Condition')
set(gca,'FontSize', 18)
ylim([0 15])
%sgtitle('Mirror Destabilizes Anti-Phase Patterns');