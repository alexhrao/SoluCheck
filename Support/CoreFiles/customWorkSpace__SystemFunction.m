 function [out, cellError__SystemVariable] = customWorkSpace__SystemFunction(cellFormula__SystemVariable)
    cellFileNames__SystemVariable = getappdata(findobj('Tag', 'uiBSoluCheck'), 'cellFileNames');
    for iCounter__SystemVariable = 1:numel(cellFileNames__SystemVariable)
        try
            addpath(strjoin(cellFileNames__SystemVariable{iCounter__SystemVariable}, ''));
            evalc(['load(''', char(cellFileNames__SystemVariable{iCounter__SystemVariable}{2}), ''');']);
            rmpath(strjoin(cellFileNames__SystemVariable{iCounter__SystemVariable}, ''));
        catch ME
            out = 0;
            if strcmp(ME.identifier, 'MATLAB:load:couldNotReadFile')
                cellError__SystemVariable = {true, ME, {sprintf('>> File #%d: MAT File %s Does Not Exist!', iCounter__SystemVariable, char(cellFileNames__SystemVariable{iCounter__SystemVariable}{2}))}};
            else
                cellError__SystemVariable = {true, ME, {sprintf('>> File #%d: MAT File %s failed to load!', iCounter__SystemVariable, char(cellFileNames__SystemVariable{iCounter__SystemVariable}{2})), sprintf('Error Identifier: %s', ME.identifier)}};
            end
            return
        end
    end
    cellError__SystemVariable = {false, [], ''};
    % First, get a list of all the variables that we have in the base:
    out = 0;
    % Now we have a list of variable names; now use the eval of evalin!
    for iCounter__SystemVariable = evalin('base', 'who')'
        if ~any(strcmp(iCounter__SystemVariable{1}, {'iCounter__SystemVariable', 'cellFormula__SystemVariable', 'cellError__SystemVariable'}))
            evalc([iCounter__SystemVariable{1}, ' = ', ['evalin(''base'', ''', iCounter__SystemVariable{1}, ''');']]);
        end
    end
    % Add 1 so that it represents the ACTUAL iteration number!
    intIterationNumber = evalin('caller', 'intIterationNumber') + 1; %#ok<NASGU>
    % Now all of our variables have been defined; now we have to execute the
    % actual code!
    try
        % Have two outputs so that IF there is NO output we don't get a
        % false positive!
        out = eval(strjoin(cellFormula__SystemVariable, '\n'));
    catch ME
        try
            evalc(strjoin(cellFormula__SystemVariable, '\n'));
        catch  %#ok<CTCH>
            cellError__SystemVariable = {true, ME, {'Formulaic Error:', ME.identifier, ME.message}};
        end
    end
end