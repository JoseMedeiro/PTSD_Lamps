%% All Plots
%
% This function does the plots in a compartimentalized (and more clean) way
%
%%
function all_plots(LAMP, setup)

for c=1:length(setup)
    if(strcmp(setup{c},'lamp'))
        lamp_plot(LAMP);
    end
    if(strcmp(setup{c},'eletro'))
        eletro_plot(LAMP);
    end
    if(strcmp(setup{c},'total'))
        total_plot(LAMP);
    end
    if(strcmp(setup{c},'comparative'))
        comparative_plot(LAMP);
    end
    if(strcmp(setup{c},'aggregate'))
        aggregate_plot(LAMP);
    end
end

end
%% Functions
%
%% Lamp Plots
function lamp_plot(LAMP)

% Sum of the new lamps per year
for c=2:length(LAMP)
    figure()
    hold on;
    grid on;
    title(['New lamps per year: ' LAMP(c).Name]);
    for d=1:length(LAMP(c).Scenarios)
        plot(LAMP(c).Scenarios(d).YearTime,...
             LAMP(c).Scenarios(d).YearLamps,...
            'Marker', "*");
    end
end
% Total of the new lamps until year
for c=2:length(LAMP)
    figure()
    hold on;
    for d=1:length(LAMP(c).Scenarios)
        plot(LAMP(c).Scenarios(d).YearTime,...
             LAMP(c).Scenarios(d).YearLampsSum,...
            'Marker', "*");
        LEGEND{d} = ['r_0 = '...
                     num2str(LAMP(c).Scenarios(d).Replacement*100)...
                     '%'];
    end
    % Plot things
    grid on;
    title(['Cumulative lamps: ' LAMP(c).Name]);
    legend(LEGEND{1:d});
end
% Total of the money spent in lamps until year
for c=2:length(LAMP)
    figure()
    hold on;
    for d=1:length(LAMP(c).Scenarios)
        plot(LAMP(c).Scenarios(d).YearTime,...
             LAMP(c).Scenarios(d).MoneyLampsSum,...
            'Marker', "*");
        LEGEND{d} = ['r_0 = '...
             num2str(LAMP(c).Scenarios(d).Replacement*100)...
             '%'];
    end
    % Plot things
    grid on;
    title(['Cumulative money spent on lamps: ' LAMP(c).Name]);
    legend(LEGEND{1:d});
end

end
%% Eletro Plots
function eletro_plot(LAMP)

% Sum of the eletricity per year
for c=2:length(LAMP)
    figure()
    hold on;
    grid on;
    title(['Eletricity per year: ' LAMP(c).Name]);
    for d=1:length(LAMP(c).Scenarios)
        plot(LAMP(c).Scenarios(d).YearTime,...
             LAMP(c).Scenarios(d).YearEletricity,...
            'Marker', "*");
    end
end
% Total of the new lamps until year
for c=2:length(LAMP)
    figure()
    hold on;
    for d=1:length(LAMP(c).Scenarios)
        plot(LAMP(c).Scenarios(d).YearTime,...
             LAMP(c).Scenarios(d).YearEletricitySum,...
            'Marker', "*");
        LEGEND{d} = ['r_0 = '...
                     num2str(LAMP(c).Scenarios(d).Replacement*100)...
                     '%'];
    end
    % Plot things
    grid on;
    title(['Cumulative eletricity used: ' LAMP(c).Name]);
    legend(LEGEND{1:d});
end
% Total of the money spent in lamps until year
for c=2:length(LAMP)
    figure()
    hold on;
    for d=1:length(LAMP(c).Scenarios)
        plot(LAMP(c).Scenarios(d).YearTime,...
             LAMP(c).Scenarios(d).MoneyEletricitySum,...
            'Marker', "*");
        LEGEND{d} = ['r_0 = '...
             num2str(LAMP(c).Scenarios(d).Replacement*100)...
             '%'];
    end
    % Plot things
    grid on;
    title(['Cumulative money spent on eletricity: ' LAMP(c).Name]);
    legend(LEGEND{1:d});
end

end
%% Total Plots
function total_plot(LAMP)
% Total of money spent per year
for c=2:length(LAMP)
    figure()
    hold on;
    for d=1:length(LAMP(c).Scenarios)
        plot(LAMP(c).Scenarios(d).YearTime,...
             LAMP(c).Scenarios(d).MoneyEletricity + ...
             LAMP(c).Scenarios(d).MoneyLamps,...
            'Marker', "*");
        LEGEND{d} = ['r_0 = '...
             num2str(LAMP(c).Scenarios(d).Replacement*100)...
             '%'];
    end
    % Plot things
    grid on;
    title(['Money spent: ' LAMP(c).Name]);
    legend(LEGEND{1:d});
end
% Total of money until year
for c=2:length(LAMP)
    figure()
    hold on;
    for d=1:length(LAMP(c).Scenarios)
        plot(LAMP(c).Scenarios(d).YearTime,...
             LAMP(c).Scenarios(d).MoneyEletricitySum + ...
             LAMP(c).Scenarios(d).MoneyLampsSum,...
            'Marker', "*");
        LEGEND{d} = ['r_0 = '...
             num2str(LAMP(c).Scenarios(d).Replacement*100)...
             '%'];
    end
    % Plot things
    grid on;
    title(['Cumulative money spent: ' LAMP(c).Name]);
    legend(LEGEND{1:d});
end

end
%% Comparative Plots (per R_0)
function comparative_plot(LAMP)

for d=1:size(LAMP(3).Scenarios,2)
    figure()
    hold on;
    % First lamps are for comparison
    plot(LAMP(2).Scenarios(1).YearTime,...
             zeros(size(LAMP(2).Scenarios(1).YearTime)),...
            'Marker', "*");
    LEGEND{1} = [LAMP(2).Name];
    for c=3:length(LAMP)
        plot(LAMP(c).Scenarios(d).YearTime,...
             LAMP(c).Scenarios(d).MoneyEletricitySum + ...
             LAMP(c).Scenarios(d).MoneyLampsSum - ...
             LAMP(2).Scenarios(1).MoneyEletricitySum - ...
             LAMP(2).Scenarios(1).MoneyLampsSum,...
            'Marker', "*");
        LEGEND{c-1} = [LAMP(c).Name];
    end
    % Plot things
    grid on;
    title(['NPV at r_i = ' num2str(LAMP(c).Scenarios(d).Replacement*100) '%']);
    legend(LEGEND{1:c-1});
end

end
%% Comparative Plots (Aggragate)
function aggregate_plot(LAMP)

global COLORS_STRING;
global MARKER_STRING;

figure()
hold on;
n = 1;
for c_=0:length(LAMP)-2
    c = length(LAMP) - c_;
    % First lamps are for comparison
    for d=1:length(LAMP(c).Scenarios)
        p(n)    = plot(LAMP(c).Scenarios(d).YearTime,...
                       LAMP(c).Scenarios(d).MoneyEletricitySum + ...
                       LAMP(c).Scenarios(d).MoneyLampsSum - ...
                       LAMP(2).Scenarios(1).MoneyEletricitySum - ...
                       LAMP(2).Scenarios(1).MoneyLampsSum);
        if(MARKER_STRING(c-1) ~= " ")
            p(n).Marker = MARKER_STRING(c-1);
        end
        p(n).Color = COLORS_STRING(d,c-1);
        LEGEND{n} = [LAMP(c).Name ', r_0 = ' num2str(LAMP(c).Scenarios(d).Replacement*100) '%'];
        n = n+1;
    end
end
% Plot things
grid on;
xlabel('Years');
ylabel('NPV [�]');
title(['With W_{FL} = ' num2str(LAMP(1).Watts) ' W']);
legend(LEGEND{1:n-1},'Location'     , 'southoutside' ,...
                     'NumColumns'   , 3             ,...
                     'Orientation'  , 'horizontal');


end