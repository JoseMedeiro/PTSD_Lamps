%% All Plots
%
% This function does the plots in a compartimentalized (and more clean)
% way.
%
%%
function all_plots(LAMP, setup,fileName,LEGEND)

for c=1:length(setup)
    if(strcmp(setup{c},'lamp'))
        lamp_plot(LAMP,fileName,LEGEND);
    end
    if(strcmp(setup{c},'eletro'))
        eletro_plot(LAMP,fileName,LEGEND);
    end
    if(strcmp(setup{c},'total'))
        total_plot(LAMP,fileName,LEGEND);
    end
    if(strcmp(setup{c},'comparative'))
        comparative_plot(LAMP,fileName,LEGEND);
    end
    if(strcmp(setup{c},'aggregate'))
        aggregate_plot(LAMP,fileName,LEGEND);
    end
end

end
%% Functions
%
%% Lamp Plots
function lamp_plot(LAMP,fileName,LEGEND_ON)

% Sum of the new lamps per year
for c=2:length(LAMP)
    figure()
    hold on;
    grid on;
    for d=1:length(LAMP(c).Scenarios)
        plot(LAMP(c).Scenarios(d).YearTime,...
             LAMP(c).Scenarios(d).YearLamps,...
            'Marker', "*");
    end
    xlabel('Year');
    ylabel('Lamps');
    title(['New lamps per year: ' LAMP(c).Name]);
    save_figure(['./img/lamps_lamp_' num2str(c) '_' fileName '.png']);
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
    xlabel('Year');
    ylabel('Lamps');
    if(LEGEND_ON)
        legend(LEGEND{1:d});
    end
    save_figure(['./img/cumulative_lamps_lamp_' num2str(c) '_'...
                 fileName '.png']);
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
    xlabel('Year');
    ylabel('Atualized Costs [€]');
    if(LEGEND_ON)
        legend(LEGEND{1:d});
    end
    save_figure(['./img/cumulative_lamps_money_lamp_' num2str(c) '_'...
                 fileName '.png']);
end

end
%% Eletro Plots
function eletro_plot(LAMP,fileName,LEGEND_ON)

% Sum of the eletricity per year
for c=2:length(LAMP)
    figure()
    hold on;
    grid on;
    title(['Eletricity per year: ' LAMP(c).Name]);
    for d=1:length(LAMP(c).Scenarios)
        plot(LAMP(c).Scenarios(d).YearTime,...
             LAMP(c).Scenarios(d).YearEletricity/100,...
            'Marker', "*");
    end
    xlabel('Year');
    ylabel('Eletricity [kW]');
    save_figure(['./img/electicity_lamp_' num2str(c) '_' fileName '.png']);
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
    xlabel('Year');
    ylabel('Eletricity [kW]');
    title(['Cumulative eletricity used: ' LAMP(c).Name]);
    if(LEGEND_ON)
    	legend(LEGEND{1:d});
    end
    save_figure(['./img/comulative_electicity_lamp_' num2str(c) '_'...
                 fileName '.png']);
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
    
    ylabel('Atualized Costs [€]');
    if(LEGEND_ON)
        legend(LEGEND{1:d});
    end
    save_figure(['./img/comulative_electicity_money_lamp_' num2str(c)...
                 '_' fileName '.png']);
end

end
%% Total Plots
function total_plot(LAMP,fileName,LEGEND_ON)
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
    xlabel('Year');
    ylabel('Atualized Costs [€]');
    if(LEGEND_ON)
        legend(LEGEND{1:d});
    end
    save_figure(['./img/yearly_total_money_lamp_' num2str(c) '_'...
                 fileName '.png']);
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
    xlabel('Year');
    ylabel('Atualized Costs [€]');
    if(LEGEND_ON)
        legend(LEGEND{1:d});
    end
    save_figure(['./img/comulative_total_money_lamp_' num2str(c) '_'...
                 fileName '.png']);
end

end
%% Comparative Plots (per R_0)
function comparative_plot(LAMP,fileName,LEGEND_ON)

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
    title(['NPV at r_i = ' num2str(LAMP(c).Scenarios(d).Replacement*100)...
           '%']);
    if(LEGEND_ON)
        legend(LEGEND{1:c-1});
    end
    save_figure(['./img/comparative_scn' num2str(d) '_' fileName '.png']);
end

end
%% Comparative Plots (Aggragate)
function aggregate_plot(LAMP,fileName,LEGEND_ON)

global COLORS_STRING;
global MARKER_STRING;


% Money Plot
    figure();
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
    ylabel('NPV [€]');
    title(['With W_{FL} = ' num2str(LAMP(1).Watts) ' W']);
    if(LEGEND_ON)
    legend(LEGEND{1:n-1},'Location'     , 'southoutside' ,...
                         'NumColumns'   , 3             ,...
                         'Orientation'  , 'horizontal');
    end
    ax = gca;
    ax.YAxis.Exponent = 3;

    save_figure(['./img/aggregate-' fileName '.png']);
% Lamp Plot
    figure();
    hold on;
    n = 1;
    for c_=0:length(LAMP)-2
        c = length(LAMP) - c_;
        % First lamps are for comparison
        for d=1:length(LAMP(c).Scenarios)
            p(n)    = plot(LAMP(c).Scenarios(d).YearTime,...
                           LAMP(c).Scenarios(d).YearLampsSum);
            if(MARKER_STRING(c-1) ~= " ")
                p(n).Marker = MARKER_STRING(c-1);
            end
            p(n).Color = COLORS_STRING(d,c-1);
            LEGEND{n} = [LAMP(c).Name ', r_0 = '...
                        num2str(LAMP(c).Scenarios(d).Replacement*100) '%'];
            n = n+1;
        end
    end
    % Plot things
    grid on;
    xlabel('Years');
    ylabel('Lamps [u]');
    title('Cumulative Lamps');
    if(LEGEND_ON)
    legend(LEGEND{1:n-1},'Location'     , 'southoutside' ,...
                         'NumColumns'   , 3             ,...
                         'Orientation'  , 'horizontal');
    end
    ax = gca;
    ax.YAxis.Exponent = 3;

    save_figure(['./img/aggregate-lamps-' fileName '.png']);
% Money Lamp Plot
    figure();
    hold on;
    n = 1;
    for c_=0:length(LAMP)-2
        c = length(LAMP) - c_;
        % First lamps are for comparison
        for d=1:length(LAMP(c).Scenarios)
            p(n)    = plot(LAMP(c).Scenarios(d).YearTime,...
                           LAMP(c).Scenarios(d).MoneyLampsSum);
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
    ylabel('Atualized Costs [€]');
    title('Cumulative Expenses in Lamps');
    if(LEGEND_ON)
    legend(LEGEND{1:n-1},'Location'     , 'southoutside' ,...
                         'NumColumns'   , 3             ,...
                         'Orientation'  , 'horizontal');
    end
    ax = gca;
    ax.YAxis.Exponent = 3;

    save_figure(['./img/aggregate-lamps_money-' fileName '.png']);
% Eletricity Plot
    figure();
    hold on;
    n = 1;
    for c_=0:length(LAMP)-2
        c = length(LAMP) - c_;
        % First lamps are for comparison
        for d=1:length(LAMP(c).Scenarios)
            p(n)    = plot(LAMP(c).Scenarios(d).YearTime,...
                           LAMP(c).Scenarios(d).YearEletricitySum/1000);
            if(MARKER_STRING(c-1) ~= " ")
                p(n).Marker = MARKER_STRING(c-1);
            end
            p(n).Color = COLORS_STRING(d,c-1);
            LEGEND{n} = [LAMP(c).Name ', r_0 = '...
                         num2str(LAMP(c).Scenarios(d).Replacement...
                         *100) '%'];
            n = n+1;
        end
    end
    % Plot things
    grid on;
    xlabel('Years');
    ylabel('Energy [kWh]');
    title(['Cumulative Eletricity with W_{FL} = '...
           num2str(LAMP(1).Watts) ' W']);
    if(LEGEND_ON)
    legend(LEGEND{1:n-1},'Location'     , 'southoutside' ,...
                         'NumColumns'   , 3             ,...
                         'Orientation'  , 'horizontal');
    end
    ax = gca;
    ax.YAxis.Exponent = 3;

    save_figure(['./img/aggregate-eletricity-' fileName '.png']); 
% Money Eletricity Plot
    figure();
    hold on;
    n = 1;
    for c_=0:length(LAMP)-2
        c = length(LAMP) - c_;
        % First lamps are for comparison
        for d=1:length(LAMP(c).Scenarios)
            p(n)    = plot(LAMP(c).Scenarios(d).YearTime,...
                           LAMP(c).Scenarios(d).MoneyEletricitySum);
            if(MARKER_STRING(c-1) ~= " ")
                p(n).Marker = MARKER_STRING(c-1);
            end
            p(n).Color = COLORS_STRING(d,c-1);
            LEGEND{n} = [LAMP(c).Name ', r_0 = '...
                         num2str(LAMP(c).Scenarios(d).Replacement...
                         *100) '%'];
            n = n+1;
        end
    end
    % Plot things
    grid on;
    xlabel('Years');
    ylabel('Atualized Costs [€]');
    title(['Cumulative Expenses in Eletricity with W_{FL} = '...
           num2str(LAMP(1).Watts) ' W']);
    if(LEGEND_ON)
    legend(LEGEND{1:n-1},'Location'     , 'southoutside' ,...
                         'NumColumns'   , 3             ,...
                         'Orientation'  , 'horizontal');
    end
    ax = gca;
    ax.YAxis.Exponent = 3;

    save_figure(['./img/aggregate-eletricity_money-' fileName '.png']); 
end
%% Save fig
%
% Moddified from MathWorks Support Team here:
% https://www.mathworks.com/matlabcentral/answers/102382-how-do-i-specify-t
% he-output-sizes-of-jpeg-png-and-tiff-images-when-using-the-print-function
% -in-mat
%
function save_figure(NAME)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5.6 3])
print('-dpng', NAME, '-r150')

end


