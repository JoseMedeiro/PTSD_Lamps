%% Type of data
%
% The data looked by the function in order to fill the lamps is:
%   
%   Name: for plot reasons;
%   Time Rated: for the survival rate and failure probability;
%   Survival Rate Rated: for the survival rate and failure probability;
%   Substitution Scenario: for the removal of (firstly) existing lamps;
%   Start: to know the size of the system of initial lamps.
%
%% Notes
%
% The first lamp is one that is already on the field; if one doesn't want
% to count with this, is just a matter of saying that the rate of
% substitution is 100%
%
%% Function
function LAMP = load_lamps(fileName)

global TOTAL_CYCLES;
global DISCRETE_TIME;

data = jsondecode(fileread(fileName));

LAMP = data.Lamps_data;

for c=1:length(LAMP)
    
    % Corrects the values in the .JSON
    LAMP(c).TimeRated           = LAMP(c).TimeRated*1000;
    LAMP(c).SurvivalRateRated   = LAMP(c).SurvivalRateRated/100;
    % Filling the probabilities in the discrete time
    [LAMP(c).TimeExp, LAMP(c).ProbRateExp]  = interpolate_values(...
                                            LAMP(c).TimeRated,...
                                            LAMP(c).SurvivalRateRated,...
                                            DISCRETE_TIME);
    % Creating a matriz for the lamps in different stages for different
    % times, in the different Scenarios
    for d=1:length(LAMP(c).Scenarios)
        LAMP(c).Scenarios(d).Replacement    = LAMP(c).Scenarios(d)...
                                              .Replacement/100;
        LAMP(c).Scenarios(d).Count          = zeros(TOTAL_CYCLES,...
                                               LAMP(c).TimeRated(end)/...
                                               DISCRETE_TIME+1);
    end
    % Creates an equilibrium for the default lamps
    if(~isempty(LAMP(c).Start))
        LAMP(c).Count       = zeros(TOTAL_CYCLES,...
                                    LAMP(c).TimeRated(end)/...
                                    DISCRETE_TIME+1);
        LAMP(c).Count(1,:)  = equilibrium_lamps(LAMP(c));
    end
    
end

end
%% Functions

%% Probability and time for failure
function [t, p] = interpolate_values(t_t, s_t, dt)

t = (0:dt:t_t(end))';

s_0     = 1;
p(1,1)    = 0;

for c=2:size(t,1)
    % interpolates survival rate
    for d=1:size(t_t,1)
      if(t(c) <= t_t(d))
          break;
      end
    end
    s_1 = s_t(d - 1) + ...
          (t(c) - t_t(d-1))*(s_t(d) - s_t(d - 1))/(t_t(d) - t_t(d-1));
    % Probability of failure between dt*(c-1) and dt*c
    p(c,1) = (s_0 - s_1) / (s_0);
    % Passes the survival rate
    s_0 = s_1;
end
end
%% Equilibrium for first lamps
function row = equilibrium_lamps(LAMP)

    row = LAMP.Count(1,:);
    
    SUM = 1;
    for c=1:size(row,2)-1
        PROD = 1;
        for d=1:c
            PROD = PROD*(1 - LAMP.ProbRateExp(d+1));
        end
        SUM = SUM + PROD;
        
    end
    
    row(1) = LAMP.Start/SUM;
    for c=2:size(row,2)
        row(c) = row(c-1)*(1-LAMP.ProbRateExp(c));
    end

end