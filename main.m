%% Script for NPV value of lamps

clear all;
close all;

%% Global variables
global DISCRETE_TIME;
global TOTAL_CYCLES;
global END;
global YEAR;
global SIM_TIME;
global PRICE_ELETRICITY;
global TOTAL_LAMPS;
global FIRST_LAMPS;

RATE            = 0.05;

DISCRETE_TIME   = 100;
YEAR            = ((14 + 2 + 4)*2)*5*12;
TOTAL_YEARS     = 30;
TOTAL_CYCLES    = fix(YEAR*TOTAL_YEARS/DISCRETE_TIME) + 1;
END             = DISCRETE_TIME*(TOTAL_CYCLES - 1);
SIM_TIME        = 0:DISCRETE_TIME:END;
PRICE_ELETRICITY= 0.239*10^(-3);

%% Loading of lamps
%
% In here the lamps are loaded from the file specified in 'fileName'
% variable. See 'load_lamps' for more detail in how the .JSON file is
% supposed to be crafted.
%
disp('Starting Loading')
fileName   = 'Lamps_1.json';
LAMP        = load_lamps(fileName);

TOTAL_LAMPS = sum(LAMP(1).Count(1,:));
FIRST_LAMPS = LAMP(1).Count(1,:);
disp(['Loaded ' num2str(length(LAMP)) ' lamps'])
disp('Ending Loading')
%% Life Simulation
% 
% See 'sims_eletro.m' for more details. But basically it does the life
% simulation for all of the lamps.
%
disp('Starting Simulations')
% For each lamp
for c=2:length(LAMP)
    disp(['Simulating ' LAMP(c).Name])
    % For each scenario
    for d=1:length(LAMP(c).Scenarios)
        disp(['           Replacement '...
              num2str(LAMP(c).Scenarios(d).Replacement*100) '%'])
        LAMP = sims_eletro(LAMP,c,d);
    end
end
disp('Ending Simulations')
%% Accounting
%
% Groups the discrete-acting-as-continuos in the spaces we so call 'years',
% aka, specified time intervals in which to aggregate the data collected.
%
disp('Starting Accounting')
%% Accounting of new lamps
for c=2:length(LAMP)
    for d=1:length(LAMP(c).Scenarios)
        % New Lamps
        [LAMP(c).Scenarios(d).YearTime,...
         LAMP(c).Scenarios(d).YearLamps]	= ...
            yearly_lamps(LAMP(c).Scenarios(d));
        % Sum of new lamps
        LAMP(c).Scenarios(d).YearLampsSum   = ...
            specialSum(LAMP(c).Scenarios(d).YearLamps,0);
        % In money
        LAMP(c).Scenarios(d).MoneyLamps     = ...
            -LAMP(c).Scenarios(d).YearLamps*LAMP(c).Price;
        % Sum of money
        LAMP(c).Scenarios(d).MoneyLampsSum  = ...
            specialSum(LAMP(c).Scenarios(d).MoneyLamps,RATE);
    end
end
%% Accounting of eletricity
for c=2:length(LAMP)
    for d=1:length(LAMP(c).Scenarios)
        % Eletricity
     	[~,LAMP(c).Scenarios(d).YearEletricity] = ...
            yearly_eletricity(LAMP(c).Scenarios(d));
        % Sum of eletricity
        LAMP(c).Scenarios(d).YearEletricitySum  = ...
            specialSum(LAMP(c).Scenarios(d).YearEletricity,0);
        % In money
        LAMP(c).Scenarios(d).MoneyEletricity    = ...
            -LAMP(c).Scenarios(d).YearEletricity*PRICE_ELETRICITY;
        % Sum of money
        LAMP(c).Scenarios(d).MoneyEletricitySum = ...
            specialSum(LAMP(c).Scenarios(d).MoneyEletricity,RATE);
    end
end
disp('Ending Accounting')
%% Plots
%
% Seems a little obvious, and it is. This is the part where the plots for
% the data are made.
%
disp('Starting Plots')
% Colors & Markers (TODO - comming in the .JSON)
global MARKER_STRING;
global COLORS_STRING;
COLORS_STRING = ["#000000","#076785","#3F762B";...
                 "#000000","#0989B1","#549E39";...
                 "#000000","#46CCF6","#93D07D"];

MARKER_STRING = [" ";...
                 "*";...
                 "."];

setup_plot = {'aggregate';...
              'eletro'};

all_plots(LAMP,setup_plot);

disp('Ending Plots')
%% Functions
%
%% Sum with interest
function SUM = specialSum(x, r)

SUM = x;

for c=2:size(x,1)
    SUM(c) = SUM(c-1) + x(c)/(1+r)^(c-1);
end

end