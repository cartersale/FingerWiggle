%% 4 Subplot from Grant
% Open field_idx, field_names, and field from data set


ID = 10;
search_field = 'M1';
field_idx = find(strcmp(field_names, search_field));

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

 nexttile([2,1]) 
Langle = 180*angle(hilbert(dataStruct.(field_names{field_idx})(ID).Lend_X))/pi;
plot((1:length(dataStruct.(field_names{field_idx})(ID).Rend_X))/100,180*angle(hilbert(dataStruct.(field_names{field_idx})(ID).Rend_X))/pi,'LineWidth',1); hold all;
plot((1:length(dataStruct.(field_names{field_idx})(ID).Lend_X))/100,180*angle(hilbert(dataStruct.(field_names{field_idx})(ID).Lend_X))/pi,'LineWidth',1)
plot(dataStruct.(field_names{field_idx})(ID).PkPosLocR/100,180*dataStruct.(field_names{field_idx})(ID).PkPosR/pi,'o','MarkerSize',6,'LineWidth',2,'Color',[0.00,0.45,0.74]) 
plot(dataStruct.(field_names{field_idx})(ID).PkPosLocR/100,Langle(dataStruct.(field_names{field_idx})(ID).PkPosLocR),'o','MarkerSize',6,'LineWidth',2,'Color',[0.85,0.33,0.10]) 

legend('Right', 'Left','Location','northeastoutside')
title('Phase Angle')
ylabel('Angle (Degrees)')
set(gca,'FontSize', 18)
yticks([-180 0 180])
%xlim([58 61])
%xlim([0 89])
curtick = get(gca, 'XTick');
set(gca, 'XTick', unique(round(curtick)))

 nexttile([3,1])
 plot(dataStruct.(field_names{field_idx})(ID).PkPosLocR/100,(180*dataStruct.(field_names{field_idx})(ID).relPhase/pi),'ko','LineWidth',2);
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

xlim([58 61])
%xlim([0 89])
curtick = get(gca, 'XTick');
set(gca, 'XTick', unique(round(curtick)))

nexttile([2,1])
plot((dataStruct.(field_names{field_idx})(ID).PkPosLocR)/100,cumsum(dataStruct.(field_names{field_idx})(ID).phaseout),'LineWidth',2)
ylabel('Cum. Deviations')
xlabel('Time (s)')
title('Cumulative Devations from Anti-Phase')
set(gca,'FontSize', 18)
xlim([58 61])
%xlim([0 89])

curtick = get(gca, 'XTick');
set(gca, 'XTick', unique(round(curtick)))
curtick = get(gca, 'YTick');
set(gca, 'YTick', unique(round(curtick)))