data = jsondecode(fileread('Lamps_1.json'));

if isfield(data, 'engine_set')
    % re-transforms data.engine_set in a cell array
    if ~iscell(data.engine_set)
        data.engine_set = num2cell(data.engine_set);
    end
    % re-transforms all data.engine_set.engines in cell arrays
    for c = 1:size(data.engine_set,1)
        if isfield(data.engine_set{c}, 'engines')
            if ~iscell(data.engine_set{c}.engines)
                data.engine_set{c}.engines = num2cell(data.engine_set{c}.engines);
            end
        end
    end
end