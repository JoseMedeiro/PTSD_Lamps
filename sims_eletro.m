%% Lamp Simulation
%
% Simulates a system where something that is there (in 'LAMP(1)') is 
% substituted by 'LAMP(c)' according to the Scenario 'd'.
%
%%
function LAMP = sims_eletro(LAMP_IN,c,d)

global DISCRETE_TIME;
global TOTAL_CYCLES;
global TOTAL_LAMPS;

LAMP = LAMP_IN;

% For the start
[LAMP(1).Count, LAMP(c).Scenarios(d).Count] = ...
    t0Replacement(LAMP(1).Count, LAMP(c).Scenarios(d).Count,...
                                 LAMP(c).Scenarios(d).Replacement);
LAMP(c).Scenarios(d).CountEletricity(1)     = DISCRETE_TIME *...
                                (sum(LAMP(1).Count(1,:))*LAMP(1).Watts+...
                                 sum(LAMP(c).Scenarios(d).Count(1,:))*....
                                 LAMP(c).Watts);
% For each time step after t0
for e=2:TOTAL_CYCLES

    % ORIGINAL LAMPS
        % Checks each one from last to second
    for f_v =0:size(LAMP(1).Count,2)-2
        f   =  size(LAMP(1).Count,2)-f_v;
        % passes the good lamps to the next section in time
        LAMP(1).Count(e,f) = ...
            LAMP(1).Count(e-1,f-1)*(1 - LAMP(1).ProbRateExp(f));
    end
    % first <- there is no replacement for the original lamps
    LAMP(1).Count(e,1) = 0;

    % NEW LAMPS
        % Checks each one from last to second
    for f_v=0:size(LAMP(c).Scenarios(d).Count,2)-2
        f  =  size(LAMP(c).Scenarios(d).Count,2) - f_v;
        % passes the good lamps to the next section in time
        LAMP(c).Scenarios(d).Count(e,f) = ...
            LAMP(c).Scenarios(d).Count(e-1,f-1)* ...
            (1 - LAMP(c).ProbRateExp(f));
    end
    % first <- replacement to maintain the lamps in the system
    LAMP(c).Scenarios(d).Count(e,1) = ...
        TOTAL_LAMPS - (sum(LAMP(1).Count(e,:)) +...
                       sum(LAMP(c).Scenarios(d).Count(e,:)));

    % eletricity spent
    LAMP(c).Scenarios(d).CountEletricity(e,1) = DISCRETE_TIME *...
       (sum(LAMP(1).Count(e-1,:))*LAMP(1).Watts               +...
        sum(LAMP(c).Scenarios(d).Count(e-1,:))*LAMP(c).Watts) ;
end

end
%% Functions
%
%% T_0 replacement
function [STATE_1, STATE_2] = t0Replacement(LAMP_1, LAMP_2, REPLACEMENT)

    global TOTAL_LAMPS;
    global FIRST_LAMPS;
    % Resets first lamps
    LAMP_1(1,:) = FIRST_LAMPS;
    % total lamps to replace
    LAMP_2(1,1) = TOTAL_LAMPS*REPLACEMENT;
    % replacement of the ones already broken
    if(LAMP_1(1,1) > LAMP_2(1,1))
     	LAMP_1(1,1) = LAMP_1(1,1) - LAMP_2(1,1);
    % replacement of the functioning ones
    else
        counter = LAMP_1(1,1);
        LAMP_1(1,1) = 0;
        for f_v=0:size(LAMP_1,2)-2
            % from last to second
            f = size(LAMP_1,2) - f_v;
            if LAMP_1(1,f) > LAMP_2 - counter
                LAMP_1(1,f) = LAMP_1(1,f) - (LAMP_2(1,1) - counter);
                break
            else
                counter = counter + LAMP_1(1,f);
                LAMP_1(1,f) = 0;
            end
        end
    end
    
    STATE_1 = LAMP_1;
    STATE_2 = LAMP_2;
end