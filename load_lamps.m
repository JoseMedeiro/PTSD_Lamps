%% Type of data
%
% The data looked by the function in order to fill the lamps is:
%   
%   Name: for plot reasons;
%   Time Rated: for the survival rate and failure probability;
%   Survival Rate Rated: for the survival rate and failure probability;
%   Substitution Scenario: for the removal of (firstly) existing lamps.
%
%% Notes
%
% The first lamp is one that is already on the field; if one doesn't want
% to count with this, is just a matter of saying that the rate of
% substitution is 100%
%
%% Function
function LAMP = load_lamps(TOTAL_CYCLES, DISCRETE_TIME)

%% LAMP 1 - STARTER
c = 1;
LAMP(c).Name                            = 'Default';
LAMP(c).TimeRated                       = [0  ; 2; 4; 6; 8;12;15;16;20]*10^3;
LAMP(c).SurvivalRateRated               = [100;99;99;99;99;89;50;33; 0]*10^(-2);
LAMP(c).Watts                           = 19;

[LAMP(c).TimeExp, LAMP(c).ProbRateExp]  = interpolate_values(...
                                            LAMP(c).TimeRated,...
                                            LAMP(c).SurvivalRateRated,...
                                            DISCRETE_TIME);

LAMP(c).Count       = zeros(TOTAL_CYCLES,LAMP(c).TimeRated(end)/DISCRETE_TIME+1);
LAMP(c).Start       = 100;
LAMP(c).Count(1,:)  = equilibrium_lamps(LAMP);

%% LAMP 2 - FL
c = 2;
LAMP(c).Name                            = 'FL';
LAMP(c).TimeRated                       = [0  ; 2; 4; 6; 8;12;15;16;20]*10^3;
LAMP(c).SurvivalRateRated               = [100;99;99;99;99;89;50;33; 0]*10^(-2);
LAMP(c).Price                           = 10.49;
LAMP(c).Watts                           = 17.1;

[LAMP(c).TimeExp, LAMP(c).ProbRateExp]  = interpolate_values(...
                                            LAMP(c).TimeRated,...
                                            LAMP(c).SurvivalRateRated,...
                                            DISCRETE_TIME);

LAMP(c).Scenarios(1).Replacement        = 0;
for d=1:size(LAMP(c).Scenarios,2)
    LAMP(c).Scenarios(d).Count = zeros(TOTAL_CYCLES,...
                                    LAMP(c).TimeRated(end)/DISCRETE_TIME+1);
end
%% LAMP 3 - LED A
c = 3;
LAMP(c).Name                            = 'LED A';
LAMP(c).TimeRated                       = [0  ; 2;18;20;25;30;36;36.1]*10^3;
LAMP(c).SurvivalRateRated               = [100;99;99;98;90;62;30;   0]*10^(-2);
LAMP(c).Price                           = 13.58;
LAMP(c).Watts                           = 19;

[LAMP(c).TimeExp, LAMP(c).ProbRateExp]  = interpolate_values(...
                                            LAMP(c).TimeRated,...
                                            LAMP(c).SurvivalRateRated,...
                                            DISCRETE_TIME);

LAMP(c).Scenarios(1).Replacement           = 0;
LAMP(c).Scenarios(2).Replacement           = 0.5;
LAMP(c).Scenarios(3).Replacement           = 1;

for d=1:size(LAMP(c).Scenarios,2)
    LAMP(c).Scenarios(d).Count = zeros(TOTAL_CYCLES,...
                                    LAMP(c).TimeRated(end)/DISCRETE_TIME+1);
end

%% LAMP 4 - LED B
c = 4;
LAMP(c).Name                            = 'LED B';
LAMP(c).TimeRated                       = [0  ;40;56;60;65;70;80;88;88.1]*10^3;
LAMP(c).SurvivalRateRated               = [100;95;92;89;80;70;40;20;0   ]*10^(-2);
LAMP(c).Price                           = 20.99;
LAMP(c).Watts                           = 12.5;

[LAMP(c).TimeExp, LAMP(c).ProbRateExp]  = interpolate_values(...
                                            LAMP(c).TimeRated,...
                                            LAMP(c).SurvivalRateRated,...
                                            DISCRETE_TIME);

LAMP(c).Scenarios(1).Replacement           = 0;
LAMP(c).Scenarios(2).Replacement           = 0.5;
LAMP(c).Scenarios(3).Replacement           = 1;
for d=1:size(LAMP(c).Scenarios,2)
    LAMP(c).Scenarios(d).Count = zeros(TOTAL_CYCLES,...
                                    LAMP(c).TimeRated(end)/DISCRETE_TIME+1);
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