%% Calculation of yearly lamps
%
% This function is used to calculate the yearly (time interval for
% analysis) of new lamps in the system.
%
% It returns both the time in years, starting at zero, and the new lamps in
% those time frames
%
function [TIME, RESULTS] = yearly_lamps(LAMP)

global YEAR;
global SIM_TIME;
global DISCRETE_TIME;

d = 1;
TIME(d)    = 0;
RESULTS(d) = sum(LAMP.Count(1,1));
while d*YEAR <= SIM_TIME(end)
    TIME(d+1)    = d;
    % Detects the start
    for lower_end=1:size(SIM_TIME,2)
      if((d-1)*YEAR < SIM_TIME(lower_end))
          if(lower_end ~= 1)
            lower_percentage = (SIM_TIME(lower_end) - (d-1)*YEAR)/...
                               DISCRETE_TIME;
          end
          break;
      end
    end
    % Detects the end
    for upper_end=1:size(SIM_TIME,2)
      if((d)*YEAR < SIM_TIME(upper_end))
     	upper_end           = upper_end-1;
        upper_percentage    = (d*YEAR - SIM_TIME(upper_end))/...
                               DISCRETE_TIME;
          break;
      end
    end
    % Sums
    RESULTS(d+1) = sum(LAMP.Count(lower_end:upper_end,1));
    if(lower_end == 2)
        RESULTS(d+1) = RESULTS(d+1) + ...
                       LAMP.Count(lower_end,1)*...
                       lower_percentage;
    end
    if(lower_end > 2)
        RESULTS(d+1) = RESULTS(d+1) + ...
                       LAMP.Count(lower_end - 1,1)*...
                       lower_percentage;
    end
    if(upper_end < size(SIM_TIME,2))
        RESULTS(d+1) = RESULTS(d+1) + ...
                       LAMP.Count(upper_end + 1,1)*...
                       upper_percentage;
    end
    d = d+1;
end

TIME    = TIME';
RESULTS = RESULTS';

end