function [logPassed, strError, intIterationNumber, cellArgs, cellAnswers, cellSolutions, vecCodeTime, vecSolnTime, fidAudit] =...
    SoluCheckEngine(strFName, strFSolnName, intIterations, cellDataType, varargin)
% SOLUCHECKENGINE Core of SoluCheck Platform
%
%       Normally only used via the SoluCheck User Interface, the SoluCheck
%       Engine can nevertheless be called directly from the command line.
%
%       Arguments:      
%               1. A string that has the function name (with .m).
%               2. A string that represents the Solution Name (with .p).
%               3. A whole number of iterations to be performed.
%               4. A cell array of the data types, from 1-6.
%               5. A variable input. Give your argument, then the step 
%                   size, in that order, for all arguments.
%
%       SoluCheck Engine will output: 
%               1. Boolean of passing status.
%               2. String that represents any errors.
%               3. Number of iterations done.
%               4. Cell array of arguments used.
%               5. Cell array of your answers.
%               6. Cell array of the solutions.
%               7. Vector with your code times.
%               8. Vector with the solution code time.
%               9. A FileID for the audit, if applicable.
%
%       To use the SoluCheck Engine, you'll need to have somewhat advanced
%       knowledge of how MATLAB operates. It is recommended that you use the
%       SoluCheck GUI instead; Engine use is only for experienced
%       programmers. Additionally, any errors you instigate will cause the
%       SoluCheck Engine to crash violently, without saving any results.
%
%       For more information, see the SoluCheck Documentation.
%   See also: SoluCheck, AdvancedOptions

% Initialize starting variables.
    cellFigures = num2cell(findobj('Type', 'Figure'))';
    fExtract = @(fig)(fig.Tag);
    cellFigures = cellfun(fExtract, cellFigures, 'UniformOutput', false);
    strOldRecycle = recycle('off');
    strError = '';
    intIterationNumber = 0;
    logPassed = true;
    cellAnswers = cell(0, 0);
    cellSolutions = cell(0, 0);
    cellArgs = cell(0, 0);
    vecCodeTime = 0;
    vecSolnTime = 0;
    hSoluCheck = findobj('Tag', 'uiBSoluCheck');
    % Find the application folder
    stcAppInfo = matlab.apputil.getInstalledAppInfo;
    strFolder = '';
    for m = 1:numel(stcAppInfo)
        if strcmp(stcAppInfo(m).name, 'SoluCheck')
            strFolder = stcAppInfo(m).location;
            break
        end
    end
    if isempty(strFolder)
        strFolder = cd;
    end
    strCurrentPath = cd;
    addpath(strCurrentPath);
    cellTags = {'uiAAdvancedOptions', 'uiFViewArguments', 'uiPPlots', 'uiEExempt',...
    'uiDLoadDatabase', 'uiLLoadVariables', 'uiNNotifications', 'uiRMaxMin', ...
    'uiSArrSize', 'uiVViewer', 'uiHHelp', 'uiWWorkSpace', 'uiBSoluCheck', 'uiPParameters'};
    cellReserved = [cellTags, cellFigures];
    % Check for the Switches; if it does not exist, create it!
    if ishandle(hSoluCheck)
        stcSwitches = getappdata(hSoluCheck, 'stcSwitches');
        objProgressBar = getappdata(hSoluCheck, 'objProgressBar');
        % Initialize the progress bar!
        objProgressBar.setValue(0);
        objProgressBar.setMinimum(1);
        objProgressBar.setMaximum(intIterations);
        objProgressBar.setString('0.00%');
        vecOut = getappdata(hSoluCheck, 'vecOut');
    else
        stcSwitches = struct('Profiler', false, ...
                             'Timing', false, ...
                             'LoadDatabase', false, ...
                             'LoadVariables', false, ...
                             'Details', false, ...
                             'MaxMin', false, ...
                             'Exempt', false, ...
                             'ArrSize', false, ...
                             'Notifications', false, ...
                             'Arguments', false, ...
                             'PlotTesting', false, ...
                             'FileTesting', false, ...
                             'ImageTesting', false, ...
                             'VariableIn', false, ...
                             'VariableOut', false, ...
                             'Auditing', false);
        vecOut = [];
    end
    if stcSwitches.FileTesting || stcSwitches.ImageTesting
        cd(strFolder);
    end
    
    % If the details are enabled, then prepare to load results into it!
    if stcSwitches.Details
        fViewer = findobj('Tag', 'uiVViewer');
        hViewer = guidata(fViewer);
        cViewer = cell(intIterations, 1);
        strOld = get(hViewer.tbVViewBox, 'String');
        [intOldLines, ~] = size(strOld);
    end
    
    % Turn the profiler on or off, as indicated:
    if stcSwitches.Profiler
        profile('on');
    else
        profile('off');
    end
    % If there are max and mins, then get the acceptable ranges
    if stcSwitches.MaxMin
        cellRanges = getappdata(hSoluCheck, 'celRanges');
    end
    % If there are exempt values, then get the exempt and stand-in values
    if stcSwitches.Exempt
        cellExempt = getappdata(hSoluCheck, 'celExempt');
        cellStandIn = getappdata(hSoluCheck, 'celStandIn');
    end
    % If we are stepping the array size, then get what sizes we need:
    if stcSwitches.ArrSize
        cellArraySizes = getappdata(hSoluCheck, 'celArraySizes');
    end
    
    if stcSwitches.PlotTesting
        vecPlotAverage = zeros(1, intIterations) - 1;
    end
    
    if stcSwitches.Auditing
        fstAudit = [strCurrentPath '\auditFile.m'];
        fidAudit = fopen(fstAudit, 'w');
        fprintf(fidAudit, '%%%% Audit:\n%%\n%% Problem: %s\n%%\n%% TimeStamp: %s\n%%\n', strFName, datestr(datetime));
    else
        fidAudit = -1;
    end
    % If we are reading from a database, then get those values:
    if stcSwitches.LoadDatabase
        % Get the raw data:
        cRaw = getappdata(hSoluCheck, 'cRaw');
        [intIterations, intArgsData] = size(cRaw);
        cTests = cRaw(:, 1:2:end);
        cTypes = cRaw(:, 2:2:end);
        % Convert the data to be what it should be
        try
            for j = 1:intArgsData / 2
                for i = 1:intIterations
                    switch lower(cTypes{i, j})
                        case 'string'
                            switch class(cTests{i, j})
                                case 'double'
                                    cTests{i, j} = num2str(cTests{i, j});
                            end
                        case 'number'
                            switch class(cTests{i, j})
                                case 'string'
                                    cTests{i, j} = str2double(cTests{i, j});
                            end
                        case 'array'
                            switch class(cTests{i, j})
                                case 'string'
                                    cTests{i, j} = evalin('base', cTests{i, j});
                            end
                        case 'cell array'
                            switch class(cTests{i, j})
                                case 'string'
                                    cTests{i, j} = evalin('base', cTests{i, j});
                                case 'double'
                                    cTests{i, j} = cTests(i, j);
                            end
                        case 'logical'
                            switch class(cTests{i, j})
                                case {'string', 'double'}
                                    cTests{i, j} = logical(evalin('base', cTests{i, j}));
                            end
                    end
                end
            end
        catch ME
            % If there was an error, just report back:
            strError = sprintf('Database conversion failed! Check case #%d, Input %d\n%s', i, j, ME.message);
            logPassed = false;
            return
        end
    end
    % Get the Formulaic Entry from SoluCheck, if it exists:
    if ishandle(hSoluCheck)
        cellFormulaic = getappdata(hSoluCheck, 'cellFormulaic');
    end
    try
        cellAnswers = cell(1, nargout(strFName) + 2);
        cellSolutions = cell(1, nargout(strFSolnName) + 2);
        cellArgs = cell(1, nargin(strFName));
        cellSteps = cell(1, nargin(strFName));
    catch ME
        strError = sprintf('%s\n%s', ME.identifier, ME.message);
        logPassed = false;
        return
    end
    
    % Prep starting arguments; if loading databases are enabled, then do
    % this instead:
    if stcSwitches.LoadDatabase
        i = 1;
        while i <= intArgsData / 2
            cellArgs{i} = cTests{1, i};
            i = i + 1;
        end
    else
        i = 0;
        while i < length(varargin) / 2
            cellSteps{i+1} = varargin{2 .* (i + 1)};
            cellArgs{i+1} = varargin{2 .* i + 1};
            i = i + 1;
        end
    end
    % Check for data types! If it is formulaic, use the CUSTOMWORKSPACE
    % system function to evaluate their formulaic entry within a contained
    % workspace:
    for i = 1:numel(cellArgs)
        if cellDataType{i} == 7
            % If we get an error, print it and report back:
            [varArg, cellError] = customWorkSpace__SystemFunction(cellFormulaic{i});
            if cellError{1}
                cstrError = cellError{3};
                intErrorLines = numel(cstrError);
                logPassed = false;
                if stcSwitches.Details
                    intIterationNumber = intIterationNumber + 1;
                    cViewer{intIterationNumber, 1} = sprintf('>> Iteration %d: Argument #%d: %s', intIterationNumber, i, cellError{3}{1});
                    cellTemp = cell(1, intOldLines + intIterationNumber);
                    for j = 1:intOldLines
                        cellTemp{j} = strOld(j, :);
                    end
                    cellTemp(intIterationNumber+1:end) = cellTemp(1:intOldLines);
                    cellTemp(1:intIterationNumber) = cViewer(intIterationNumber:-1:1);
                    cellViewer = cell(intErrorLines + intIterationNumber + intOldLines, 1);
                    cellViewer(1:intErrorLines) = cstrError;
                    cellViewer((intErrorLines+1):end) = cellTemp;
                    set(hViewer.tbVViewBox, 'String', strjoin(cellViewer, '\n'));
                end
                strError = sprintf('Argument #%d: %s', i, cellError{3}{1});
                return
            else
                cellArgs{i} = varArg;
            end
        elseif cellDataType{i} == 1
            % Evaluate in custom workspace, with out equalling the
            % variable!
            tbBArgument = getappdata(hSoluCheck, 'tbBArgument');
            [varArg, cellError] = customWorkSpace__SystemFunction({['out = ' tbBArgument{i}.String, ';']});
            if cellError{1}
                % Like if we had an error before:
                cstrError = cellError{3};
                intErrorLines = numel(cstrError);
                logPassed = false;
                if stcSwitches.Details
                    cViewer{intIterationNumber, 1} = sprintf('>> Argument #%d: Formulaic Error!', intIterationNumber);
                    cellTemp = cell(1, intOldLines + intIterationNumber);
                    for j = 1:intOldLines
                        cellTemp{j} = strOld(j, :);
                    end
                    cellTemp(intIterationNumber+1:end) = cellTemp(1:intOldLines);
                    cellTemp(1:intIterationNumber) = cViewer(intIterationNumber:-1:1);
                    cellViewer = cell(intErrorLines + intIterationNumber + intOldLines);
                    cellViewer(1:intErrorLines) = cstrError;
                    cellViewer((intErrorLines+1):end) = cellTemp;
                    set(hViewer.tbVViewBox, 'String', strjoin(cellViewer, '\n'));
                end
                return
                % Otherwise, just have the argument equal the output!
            else
                cellArgs{i} = varArg;
            end
        end
    end
    
    % Now that we've defined everything; CHANGE the SoluCheck Tags to have
    % a handle visibility of off:
    for k = cellTags
        fTag = findobj('Tag', k{1});
        if ~isempty(fTag)
            fTag.HandleVisibility = 'off';
        end
    end
    % Initialize our counters:
    cellCounter = cellArgs;
    intArgs = length(cellArgs);
    vecCodeTime = zeros(1, intIterations);
    vecSolnTime = zeros(1, intIterations);

    % Begin iteratively testing code!
    while intIterationNumber < intIterations
        drawnow();
        if getappdata(hSoluCheck, 'logCancel')
            setappdata(hSoluCheck, 'logCancel', false);
            logPassed = false;
            strError = 'User Aborted Test.';
            if stcSwitches.Details
                cViewer{intIterationNumber, 1} = sprintf('>> Iteration %d: User Aborted Test.', intIterationNumber);
                cellTemp = cell(1, intOldLines + intIterationNumber);
                for j = 1:intOldLines
                    cellTemp{j} = strOld(j, :);
                end
                cellTemp(intIterationNumber+1:end) = cellTemp(1:intOldLines);
                cellTemp(1:intIterationNumber) = cViewer(intIterationNumber:-1:1);
                cellViewer = cell(intErrorLines + intIterationNumber + intOldLines);
                cellViewer(1:intErrorLines) = cstrError;
                cellViewer((intErrorLines+1):end) = cellTemp;
                set(hViewer.tbVViewBox, 'String', strjoin(cellViewer, '\n'));
            end
            return
        end
        intIterationNumber = intIterationNumber + 1;
        bContinue = false;
        % Test the given code first:
        try
            % Start timing:
            tic();
            % Assign our answers to the cell array:
            [cellAnswers{1:end-2}] = feval(strFName, cellArgs{:});
            % Stop Timing:
            vecCodeTime(intIterationNumber) = toc();
            if stcSwitches.FileTesting
                % If we are testing files, get all of the txt files, read
                % them, then close and delete them!
                strFileNames = ls('*.txt');
                [intTextFiles, ~] = size(strFileNames);
                cellCodeFileNames = cell(1, intTextFiles);
                for i = 1:intTextFiles
                    cellCodeFileNames{i} = strFileNames(i, :);
                end
                    cellCodeAnswers = cell(1, numel(cellCodeFileNames) .* 2);
                    cellCodeAnswers(1:2:end) = cellCodeFileNames;
                for i = 1:intTextFiles
                    fidTemp = fopen(cellCodeFileNames{i}, 'r');
                    strTemp = fgetl(fidTemp);
                    intTempLine = 1;
                    while ischar(strTemp)
                        cellCodeFile{intTempLine} = strTemp; %#ok<AGROW>
                        intTempLine = intTempLine + 1;
                        strTemp = fgetl(fidTemp);
                    end
                    fclose(fidTemp);
                    delete(cellCodeFileNames{i});
                    cellCodeAnswers{1, 2 .* i} = cellCodeFile;
                end
                cellAnswers{end-1} = cellCodeAnswers;
            end
            if stcSwitches.ImageTesting
                % If we are testing images, read the images, then delete
                % them.
                stcImageFiles = [dir('*.jpg'), dir('*.png')];
                [~, intImageFiles] = size(stcImageFiles);
                cellCodeImageNames = cell(1, intImageFiles);
                for i = 1:intImageFiles
                    cellCodeImageNames{i} = stcImageFiles(i).name;
                end
                cellCodeAnswers = cell(1, numel(cellCodeImageNames) .* 2);
                cellCodeAnswers(1:2:end) = cellCodeImageNames;
                for i = 1:intImageFiles
                    cellCodeAnswers{1, 2 .* i} = imread(stcImageFiles(i).name);
                    delete(cellCodeImageNames{i});
                end
                cellAnswers{end} = cellCodeAnswers;
            end
            if stcSwitches.PlotTesting
                % If we are testing plots, save the plots as images, then
                % read in the images!
                stcFigures = findobj('Type', 'Figure');
                strOldFolder = cd(strFolder);
                for i = 1:numel(stcFigures)
                    if ~any(strcmp(stcFigures(i).Tag, cellReserved))
                        drawnow();
                        intCodeFigures = intCodeFigures + 1;
                        saveas(stcFigures(i), sprintf('Figure%d_Code.jpg', intCodeFigures));
                        delete(stcFigures(i))
                    end
                end
                cd(strOldFolder);
                % Delete our protection from plots
            end
        catch ME
            % Store our errors!
            strCodeErrorID = ME.identifier;
            strCodeErrorMsg = ME.message;
            cellAnswers(1:2) = {strCodeErrorID, strCodeErrorMsg};
            try
                % Try the solution code; if it does work, then coder
                % screwed up code; else, if the error messages are the
                % same, then count it as a success!
                [cellSolutions{1:end-2}] = feval(strFSolnName, cellArgs{:});
                strError = sprintf('Code File:\n%s\n%s', ME.identifier, ME.message);
                logPassed = false;
                if stcSwitches.FileTesting || stcSwitches.ImageTesting
                    stcFiles = [dir('*.jpg'), dir('*.txt'), dir('*.png')];
                    for fidFile = stcFiles
                        delete(fidFile.name);
                    end
                end
                if stcSwitches.Details
                    cViewer{intIterationNumber, 1} = sprintf('>> Argument #%d: Code Error!', intIterationNumber); 
                    cellViewer = cell(1, intOldLines + intIterationNumber);
                    for i = 1:intOldLines
                        cellViewer{i} = strOld(i, :);
                    end
                    cellViewer(intIterationNumber+1:end) = cellViewer(1:intOldLines);
                    cellViewer(1:intIterationNumber) = cViewer(intIterationNumber:-1:1);
                    set(hViewer.tbVViewBox, 'String', strjoin(cellViewer, '\n'));
                end
                if stcSwitches.Auditing
                    audit(intIterationNumber, cellArgs, cellAnswers, cellSolutions, fidAudit);
                else
                    break;
                end
            catch ME
                if strcmp(strCodeErrorID, ME.identifier)
                    logPassed = true;
                    bContinue = true;
                else
                    cellSolutions(1:2) = {strCodeErrorID, ME.identifier};
                    logPassed = false;
                    strError = sprintf('Code File:\n%s\n%s\n\nSolution File:\n%s\n%s', strCodeErrorID, strCodeErrorMsg, ME.identifier, ME.message);
                    if stcSwitches.Details
                        cViewer{intIterationNumber, 1} = sprintf('>> Argument #%d: Solution Error!', intIterationNumber); 
                        cellViewer = cell(1, intOldLines + intIterationNumber);
                        for i = 1:intOldLines
                            cellViewer{i} = strOld(i, :);
                        end
                        cellViewer(intIterationNumber+1:end) = cellViewer(1:intOldLines);
                        cellViewer(1:intIterationNumber) = cViewer(intIterationNumber:-1:1);
                        set(hViewer.tbVViewBox, 'String', strjoin(cellViewer, '\n'));
                    end
                    if stcSwitches.Auditing
                        audit(intIterationNumber, cellArgs, cellAnswers, cellSolutions, fidAudit);
                    else
                        break
                    end
                end
            end
        end
        % Try the given solution code:
        try
            tic();
            [cellSolutions{1:end-2}] = feval(strFSolnName, cellArgs{:});
            vecSolnTime(intIterationNumber) = toc();
            if stcSwitches.FileTesting
                strFileNames = ls('*.txt');
                [intTextFiles, ~] = size(strFileNames);
                cellSolnFileNames = cell(1, intTextFiles);
                for i = 1:intTextFiles
                    cellSolnFileNames{i} = strFileNames(i, :);
                end
                cellSolnAnswers = cell(1, numel(cellSolnFileNames) .* 2);
                cellSolnAnswers(1:2:end) = cellSolnFileNames;
                for i = 1:intTextFiles
                    fidTemp = fopen(cellSolnFileNames{i}, 'r');
                    strTemp = fgetl(fidTemp);
                    intTempLine = 1;
                    while ischar(strTemp)
                        intTempLine = intTempLine + 1;
                        strTemp = fgetl(fidTemp);
                    end
                    fclose(fidTemp);
                    fopen(cellSolnFileNames{i}, 'r');
                    strTemp = fgetl(fidTemp);
                    cellSolnFile = cell(1, intTempLine);
                    while ischar(strTemp)
                        cellSolnFile{intTempLine} = strTemp;
                        intTempLine = intTempLine + 1;
                        strTemp = fgetl(fidTemp);
                    end
                    fclose(fidTemp);
                    delete(cellSolnFileNames{i});
                    cellSolnAnswers{1, i.*2} = cellSolnFile;
                end
                cellSolutions{end-1} = cellSolnAnswers;
            end
            if stcSwitches.ImageTesting
                stcImageFiles = [dir('*.jpg'), dir('*.png')];
                [~, intImageFiles] = size(stcImageFiles);
                cellSolnImageNames = cell(1, intImageFiles);
                for i = 1:intImageFiles
                    cellSolnImageNames{i} = stcImageFiles(i).name;
                end
                cellSolnAnswers = cell(1, numel(cellSolnImageNames) .* 2);
                cellSolnAnswers(1:2:end) = cellCodeImageNames;
                for i = 1:intImageFiles
                    cellSolnAnswers{1, 2 .* i} = imread(stcImageFiles(i).name);
                    delete(cellCodeImageNames{i});
                end
                cellSolutions{end} = cellSolnAnswers;
            end
            if stcSwitches.PlotTesting
                strOldFolder = cd(strFolder);
                stcFigures = findobj('Type', 'Figure');
                for i = 1:numel(stcFigures)
                    if ~any(strcmp(stcFigures(i).Tag, cellReserved))
                        drawnow();
                        intSolnFigures = intSolnFigures + 1;
                        saveas(stcFigures(i), sprintf('Figure%d_Soln.jpg', intSolnFigures));
                        delete(stcFigures(i));
                    end
                end
                cd(strOldFolder);
            end
        catch ME
            if ~bContinue
                strError = sprintf('Solution File:\n%s\n%s', ME.identifier, ME.message);
                logPassed = false;
                if stcSwitches.Details
                    cViewer{intIterationNumber, 1} = sprintf('>> Argument #%d: Solution Error!', intIterationNumber); 
                    cellViewer = cell(1, intOldLines + intIterationNumber);
                    for i = 1:intOldLines
                        cellViewer{i} = strOld(i, :);
                    end
                    cellViewer(intIterationNumber+1:end) = cellViewer(1:intOldLines);
                    cellViewer(1:intIterationNumber) = cViewer(intIterationNumber:-1:1);
                    set(hViewer.tbVViewBox, 'String', strjoin(cellViewer, '\n'));
                end
                if stcSwitches.Auditing
                    audit(intIterationNumber, cellArgs, cellAnswers, cellSolutions, fidAudit);
                else
                    break
                end
            end
        end
        % Check if we are in agreement, OR if it is ok to continue!
        try
            if anyMult(isnan([cellAnswers{:}]))
                logANAN = isnan([cellAnswers{:}]);
                logSNAN = isnan([cellSolutions{:}]);
                bContinue = isequal(find(logANAN), find(logSNAN));
            end
        catch ME %#ok<NASGU>
        end
        logOut = true(1, numel(cellAnswers));
        logOut(vecOut) = false;
        cellAnswers = cellAnswers(logOut);
        cellSolutions = cellSolutions(logOut);
        if isequal(cellAnswers, cellSolutions) || bContinue
            if stcSwitches.Details
                cViewer{intIterationNumber, 1} = sprintf('>> Argument #%d: Passed!', intIterationNumber);
            end
            % Check the plots:
            if stcSwitches.PlotTesting
                try
                    strOldFolder = cd(strFolder);
                    if intSolnFigures ~= intCodeFigures
                        if stcSwitches.Details
                            cViewer{intIterationNumber, 1} = [cViewer{intIterationNumber, 1} sprintf('\n>> Iteration #%d: Mismatch of number of figures!', intIterationNumber)];
                        end
                    end
                    if intSolnFigures <= intCodeFigures
                        vecPlotTemp = zeros(1, intSolnFigures) - 1;
                        for intTemp = 1:intSolnFigures
                            drawnow();
                            imgCode = imread(sprintf('Figure%d_Code.jpg', intTemp));
                            imgSoln = imread(sprintf('Figure%d_Soln.jpg', intTemp));
                            arrCodeAvg = double(imgCode);
                            arrCodeAvg = (arrCodeAvg(:, :, 1) + arrCodeAvg(:, :, 2) + arrCodeAvg(:, :, 3)) ./ 3;
                            arrCodeAvg = uint8(arrCodeAvg);
                            arrSolnAvg = double(imgSoln);
                            arrSolnAvg = (arrSolnAvg(:, :, 1) + arrSolnAvg(:, :, 2) + arrSolnAvg(:, :, 3)) ./ 3;
                            arrSolnAvg = uint8(arrSolnAvg);
                            vecNonWhite = find(arrSolnAvg ~= 255);
                            vecNumMissed = arrSolnAvg(vecNonWhite) ~= arrCodeAvg(vecNonWhite);
                            vecPlotTemp(i) = sum(vecNumMissed) / numel(vecNonWhite);
                        end
                        delete('Figure*_*.jpg');
                        vecPlotTemp(vecPlotTemp < 0) = [];
                        vecPlotAverage(intIterationNumber) = mean(vecPlotTemp);
                        if stcSwitches.Details
                            cViewer{intIterationNumber, 1} = [cViewer{intIterationNumber, 1} sprintf('\n>> Iteration #%d: Plots Differed by %0.4f%%', vecPlotAverage(intIterationNumber))];
                        end
                    elseif stcSwitches.Details
                        cViewer{intIterationNumber, 1} = [cViewer{intIterationNumber, 1} sprintf('\n>> Iteration #%d: Mismatch of number of figures!', intIterationNumber)];
                    end
                    cd(strOldFolder);
                catch ME
                    logPassed = false;
                    strError = sprintf('Code File:\n%s\n%s', ME.identifier, ME.message);
                    if stcSwitches.Details
                        cViewer{intIterationNumber, 1} = sprintf('>> Argument #%d: Solution Error!', intIterationNumber); 
                        cellViewer = cell(1, intOldLines + intIterationNumber);
                        for i = 1:intOldLines
                            cellViewer{i} = strOld(i, :);
                        end
                        cellViewer(intIterationNumber+1:end) = cellViewer(1:intOldLines);
                        cellViewer(1:intIterationNumber) = cViewer(intIterationNumber:-1:1);
                        set(hViewer.tbVViewBox, 'String', strjoin(cellViewer, '\n'));
                    end
                    if stcSwitches.Auditing
                        audit(intIterationNumber, cellArgs, cellAnswers, cellSolutions, fidAudit);
                    else
                        break
                    end
                end
                    
            end
            % As long as we aren't at the end!
        else
            % If we are wrong, stop the process and report our error!
            logPassed = false;
            if stcSwitches.Details
                cViewer{intIterationNumber, 1} = sprintf('>> Iteration #%d: Failed!', intIterationNumber);
            end
            if stcSwitches.Auditing
                audit(intIterationNumber, cellArgs, cellAnswers, cellSolutions, fidAudit);
            else
                break;
            end
        end
        if intIterationNumber < intIterations
            % cellArgs = cellCounter;
            % Reload our Arguments:
            for i = 1:intArgs
                if stcSwitches.LoadDatabase
                    % If we are loading a database, just read the next
                    % line!
                    cellArgs{i} = cTests{intIterationNumber, i};
                elseif cellDataType{i} == 7
                    % If we have a formulaic entry, RE EVALUATE our
                    % entry!
                    [varArg, cellError] = customWorkSpace__SystemFunction(cellFormulaic{i});
                    if cellError{1}
                        cstrError = cellError{3};
                        intErrorLines = numel(cstrError);
                        logPassed = false;
                        if stcSwitches.Details
                            cViewer{intIterationNumber, 1} = sprintf('>> Argument #%d: Formulaic Error!', intIterationNumber);
                            cellTemp = cell(1, intOldLines + intIterationNumber);
                            for j = 1:intOldLines
                                cellTemp{j} = strOld(j, :);
                            end
                            cellTemp(intIterationNumber+1:end) = cellTemp(1:intOldLines);
                            cellTemp(1:intIterationNumber) = cViewer(intIterationNumber:-1:1);
                            cellViewer = cell(intErrorLines + intIterationNumber + intOldLines);
                            cellViewer(1:intErrorLines) = cstrError;
                            cellViewer((intErrorLines+1):end) = cellTemp;
                            set(hViewer.tbVViewBox, 'String', strjoin(cellViewer, '\n'));
                        end
                        break
                    else
                        cellArgs{i} = varArg;
                    end
                elseif cellDataType{i} == 1
                    % If we have a data type of 1, then re evaluate our
                    % stored variable!
                    tbBArgument = getappdata(hSoluCheck, 'tbBArgument');
                    [varArg, cellError] = customWorkSpace__SystemFunction({['out = ' tbBArgument{i}.String ';']});
                    if cellError{1}
                        cstrError = cellError{3};
                        intErrorLines = numel(cstrError);
                        logPassed = false;
                        if stcSwitches.Details
                            cViewer{intIterationNumber, 1} = sprintf('>> Argument #%d: Formulaic Error!', intIterationNumber);
                            cellTemp = cell(1, intOldLines + intIterationNumber);
                            for j = 1:intOldLines
                                cellTemp{j} = strOld(j, :);
                            end
                            cellTemp(intIterationNumber+1:end) = cellTemp(1:intOldLines);
                            cellTemp(1:intIterationNumber) = cViewer(intIterationNumber:-1:1);
                            cellViewer = cell(1, intErrorLines + intIterationNumber + intOldLines);
                            cellViewer(1:intErrorLines) = cstrError;
                            cellViewer((intErrorLines+1):end) = cellTemp;
                            set(hViewer.tbVViewBox, 'String', strjoin(cellViewer, '\n'));
                        end
                        return
                    else
                        cellArgs{i} = varArg;
                    end
                else
                    % Otherwise, step as normal. DO NOT step cell
                    % arrays or structures!
                    if (isnumeric(cellSteps{i})) && ~any(isnan(cellSteps{i})) && (~iscell(cellArgs{i}) && cellDataType{i} ~= 7 && cellDataType{i} ~= 1 && ~isstruct(cellArgs{i}))
                        cellCounter{i} = cellCounter{i} + cellSteps{i};
                        % Create a test; but keep our Counter!
                        varTest = cellArgs{i} + cellSteps{i};
                        % If we have maxes and mins, deal with them by
                        % resetting outside ranged values to be inside
                        % our range!
                        if stcSwitches.MaxMin
                            if any(varTest > cellRanges{i}(2))
                                cellArgs{i}(cellArgs{i} == cellRanges{i}(2)) = cellRanges{i}(1) - cellSteps{i};
                            end
                            if any(varTest < cellRanges{i}(1))
                                cellArgs{i}(cellArgs{i} == cellRanges{i}(1)) = cellRanges{i}(2) - cellSteps{i};
                            end
                        end
                        cellArgs{i} = cellArgs{i} + cellSteps{i};
                        % If we have exempt values, then deal with
                        % these accordingly!
                        if stcSwitches.Exempt
                            for j = 1:length(cellExempt{i})
                                if isequal(varTest, cellExempt{i}{j})
                                    % Only take the FIRST stand in
                                    % value, so that we won't get an
                                    % error!
                                    cellArgs{i}(cellArgs{i}==cellExempt{i}{j}) = cellStandIn{i}{1}(1);
                                end
                            end
                        end
                        % Resize our array, if necessary, by filling
                        % with the given value.
                        if stcSwitches.ArrSize
                            try
                                % if the array step is greater than 0,
                                % then add; otherwise, subtract for
                                % rows and columns!
                                if cellArraySizes{i}(1) > 0
                                    cellArgs{i}(end+cellArraySizes{i}(1), :) = cellArraySizes{i}(3);
                                    cellCounter{i}(end+cellArraySizes{i}(1), :) = cellArraySizes{i}(3);
                                elseif numel(cellArgs{i}) > 0
                                    cellArgs{i}((end+cellArraySizes{i}(1)+1):end, :) = [];
                                    cellCounter{i}((end+cellArraySizes{i}(1)+1):end, :) = [];
                                end

                                if cellArraySizes{i}(2) > 0
                                    cellArgs{i}(:, end+cellArraySizes{i}(2)) = cellArraySizes{i}(3);
                                    cellCounter{i}(:, end+cellArraySizes{i}(2)) = cellArraySizes{i}(3);
                                elseif numel(cellArgs{i}) > 0
                                    cellArgs{i}(:, (end+cellArraySizes{i}(2)+1):end) = [];
                                    cellCounter{i}(:, (end+cellArraySizes{i}(2)+1):end) = [];
                                end
                            catch ME
                                % Say that we were unable to step; This
                                % will NOT include if we get to an
                                % array of 0!
                                logPassed = false;
                                strError = sprintf('Argument %d: Couldn''step array size.\n%s', intIterationNumber, ME.identifier);
                                return
                            end
                        end
                        % Make sure we stay in the right data type!
                        switch cellDataType{i}
                            case 2
                                cellArgs{i} = char(cellArgs{i});
                            case 3
                                cellArgs{i} = double(cellArgs{i});
                            case 6
                                cellArgs{i} = cellArgs{i} < 2;
                        end
                    elseif iscell(cellArgs{i})
                        % NOW we step cell arrays!
                        if stcSwitches.ArrSize
                            try
                                if cellArraySizes{i}(1) > 0
                                    cellArgs{i}(end+cellArraySizes{i}(1), :) = {cellArraySizes{i}(3:end)};
                                    cellCounter{i}(end+cellArraySizes{i}(1), :) = {cellArraySizes{i}(3:end)};
                                else
                                    cellArgs{i}((end+cellArraySizes{i}(1)+1):end, :) = [];
                                    cellCounter{i}((end+cellArraySizes{i}(1)+1):end, :) = [];
                                end

                                if cellArraySizes{i}(2) > 0
                                    cellArgs{i}(:, end+cellArraySizes{i}(2)) = {cellArraySizes{i}(3:end)};
                                    cellCounter{i}(:, end+cellArraySizes{i}(2)) = {cellArraySizes{i}(3:end)};
                                else
                                    cellArgs{i}(:, (end+cellArraySizes{i}(2)+1):end) = [];
                                    cellCounter{i}(:, (end+cellArraySizes{i}(2)+1):end) = [];
                                end
                            catch ME
                                logPassed = false;
                                strError = sprintf('Argument %d: Couldn''step cell array size.\n%s', intIterationNumber, ME.identifier);
                                return
                            end
                        end
                    end
                end
            end
        end
        % Update the progress bar:
        if ishandle(hSoluCheck)
            objProgressBar.setValue(intIterationNumber);
            objProgressBar.setString(sprintf('%0.02f%%', intIterationNumber / intIterations * 100));
        end
    end
    % If we passed, update the progress bar:
    if ishandle(hSoluCheck) && (logPassed || stcSwitches.Auditing)
        objProgressBar.setMaximum(100);
        objProgressBar.setValue(100);
        objProgressBar.setString('100.00%');
    end
    % Publish our plot testing results:
    if stcSwitches.PlotTesting
        vecPlotAverage(vecPlotAverage < 0) = [];
        setappdata(hSoluCheck, 'vecPlotAverage', vecPlotAverage);
    end
    % Write to the logger:
    if stcSwitches.Details
        cellViewer = cell(1, intOldLines + intIterationNumber);
        for i = 1:intOldLines
            cellViewer{i} = strOld(i, :);
        end
        cellViewer(intIterationNumber+1:end) = cellViewer(1:intOldLines);
        cellViewer(1:intIterationNumber) = cViewer(intIterationNumber:-1:1);
        set(hViewer.tbVViewBox, 'String', strjoin(cellViewer, '\n'));
    end
    % Change our path back, and reset recycling status:
    cd(strCurrentPath);
    recycle(strOldRecycle);
end