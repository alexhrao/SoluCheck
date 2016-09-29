function varargout = SoluCheck(varargin)
% SOLUCHECK Code for SoluCheck Platform
%      SOLUCHECK, by itself, creates a new SOLUCHECK or raises the existing
%      singleton.
% 
%      For More help, see the SoluCheck Documentation, which should have
%      been included with your installation of SoluCheck. Alternatively,
%      contact SoluCheck Services at SoluCheck@gmail.com.
%
% See also: AdvancedOptions, SoluCheckEngine
if isempty(varargin)
    fprintf('Loading SoluCheck, Please Wait...');
    [strPath, ~, ~] = fileparts(mfilename('fullpath'));
    addpath(strPath);
    addpath([strPath(1:end-9) '\Media'], [strPath(1:end-9) '\Documentation'])
    varargin{1} = true;
end
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SoluCheck_OpeningFcn, ... 
                   'gui_OutputFcn',  @SoluCheck_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end



% --- Executes just before SoluCheck is made visible.
function SoluCheck_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SoluCheck (see VARARGIN)

% Initialize our own handle, our own size, and kill all warnings:
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
warning('off', 'all');
vecOldSize = getpixelposition(hSoluCheck);
vecOldSize = vecOldSize(3:4);
% ONLY set this data if SoluCheck does NOT already exist!
if ~isappdata(hObject, 'stcSwitches')
    % Initialize starting variables
    bFirstTime = true;
    strOldDir = cd();
    % Create our starting switches:
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
    % Create our audio structure:
    [arrSound1, arrBitRate1] = audioread('Start.mp3');
    [arrSound2, arrBitRate2] = audioread('Pass1.mp3');
    [arrSound3, arrBitRate3] = audioread('Pass2.mp3');
    [arrSound4, arrBitRate4] = audioread('Pass3.mp3');
    [arrSound5, arrBitRate5] = audioread('Pass4.mp3');
    [arrSound6, arrBitRate6] = audioread('Fail1.mp3');
    [arrSound7, arrBitRate7] = audioread('Fail2.mp3');
    [arrSound8, arrBitRate8] = audioread('Fail3.mp3');
    [arrSound9, arrBitRate9] = audioread('Error1.mp3');
    [arrSound10, arrBitRate10] = audioread('Error2.mp3');
    [arrSound11, arrBitRate11] = audioread('Error3.mp3');
    stcSounds = struct('Start', {{arrSound1, arrBitRate1}, [], [], []}, ...
                       'Pass', {{arrSound2, arrBitRate2}, {arrSound3, arrBitRate3}, {arrSound4, arrBitRate4}, {arrSound5, arrBitRate5}}, ...
                       'Fail', {{arrSound6, arrBitRate6}, {arrSound7, arrBitRate7}, {arrSound8, arrBitRate8}, []}, ...
                       'Error', {{arrSound9, arrBitRate9}, {arrSound10, arrBitRate10}, {arrSound11, arrBitRate11}, []});
    % Create the UI Menu:
    uiBSoluCheckMenu = uimenu('Label', 'SoluCheck', 'Accelerator', 'C', 'Tag', 'uiBSoluCheckMenu');
    uiBSoluCheckOutputs = uimenu(uiBSoluCheckMenu, 'Tag', 'uiBSoluCheckOutputs', 'Label', 'Save Outputs...', 'Accelerator', 'S', 'Callback', @uiBSoluCheckMenuSaveOutputs_Callback);
    uiBSoluCheckMenuDetails = uimenu(uiBSoluCheckMenu, 'Tag', 'uiBSoluCheckMenuDetails', 'Label', 'Save Details...', 'Accelerator', 'D', 'Callback', @uiBSoluCheckMenuSaveDetails_Callback, 'Enable', 'off');
    uimenu(uiBSoluCheckMenu, 'Tag', 'uibSolucheckMenuPrep', 'Label', 'Prepare to Submit', 'Callback', @uiBSoluCheckMenuPrep_Callback);
    uimenu(uiBSoluCheckMenu, 'Tag', 'uiBMenuQuit', 'Label', 'Quit', 'Accelerator', 'Q', 'Callback', @uiBSoluCheckMenuQuit_Callback);
    uimenu(uiBSoluCheckMenu, 'Tag', 'uiBMenuAdvancedOptions', 'Label', 'Advanced Options...', 'Callback', @pbBAdvancedOptions_Callback, 'Accelerator', 'A');
    uiBSoluCheckMenuSettings = uimenu(uiBSoluCheckMenu, 'Tag', 'uiBMenuSettings', 'Label', 'Settings');
    uiBSoluCheckMenuMute = uimenu(uiBSoluCheckMenuSettings, 'Tag', 'uiBSettingsMute', 'Label', 'Mute', 'Checked', 'off', 'Callback', @uiBMenuMute_Callback, 'Accelerator', 'M');
    uimenu(uiBSoluCheckMenuSettings, 'Tag', 'uiBMenuUninstall', 'Label', 'Uninstall SoluCheck...', 'Callback', @uiBSoluCheckMenuUninstall_Callback);
    uimenu(uiBSoluCheckMenuSettings, 'Tag', 'uiBInstallEngine', 'Label', 'Install Stand-Alone Engine', 'Callback', @uiBSoluCheckMenuInstallEngine_Callback);
    uimenu(uiBSoluCheckMenuSettings, 'Tag', 'uiBPreferences', 'Label', 'Preferences...', 'Callback', @uiBSoluCheckMenuPref_Callback);
    uiBHelpMenu = uimenu('Tag', 'uiBHelp', 'Label', 'Help');
    uimenu(uiBHelpMenu, 'Tag', 'uiBDocumentation', 'Label', 'Documentation...', 'Callback', @uiBDocumentation_Callback, 'Accelerator', 'H');
    % Create the progress bar
    [objProgressBar, obwProgressBar] = javacomponent('javax.swing.JProgressBar', [10 30 375 20]);
    objProgressBar.setStringPainted(true);
    objProgressBar.setString('0.00%');
    objProgressBar.setMaximum(100);
    objProgressBar.setMinimum(1);
    objProgressBar.setValue(0);
    objProgressBar.setBackground(java.awt.Color(1,1,1));
    objProgressBar.setForeground(java.awt.Color(0,.75,0));
    obwProgressBar.Tag = 'objProgressBar';
    % add our current folder to the path
    stcAppInfo = matlab.apputil.getInstalledAppInfo;
    for i = 1:numel(stcAppInfo)
        if strcmp(stcAppInfo(i).name, 'SoluCheck')
            addpath(stcAppInfo(i).location);
            break
        end
    end
    % set appropriate data
    setappdata(hSoluCheck, 'stcSwitches', stcSwitches);
    setappdata(hSoluCheck, 'stcSounds', stcSounds);
    setappdata(hSoluCheck, 'uiBSoluCheckMenuMute', uiBSoluCheckMenuMute);
    setappdata(hSoluCheck, 'uiBMenuDetails', uiBSoluCheckMenuDetails);
    setappdata(hSoluCheck, 'uiBSoluCheckOutputs', uiBSoluCheckOutputs);
    setappdata(hSoluCheck, 'bFirstTime', bFirstTime);
    setappdata(hSoluCheck, 'strOldDir', strOldDir);
    setappdata(hSoluCheck, 'vecOldSize', vecOldSize);
    setappdata(hSoluCheck, 'bFirstTime', bFirstTime);
    setappdata(hSoluCheck, 'objProgressBar', objProgressBar);
    setappdata(hSoluCheck, 'obwProgressBar', obwProgressBar);
    setappdata(hSoluCheck, 'fhpbBTest_Callback', @pbBTest_Callback);
    setappdata(hSoluCheck, 'logCancel', false);
    setappdata(hSoluCheck, 'vecOut', []);
end

% Choose default command line output for SoluCheck
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes SoluCheck wait for user response (see UIRESUME)
% uiwait(handles.uiBSoluCheck);
fprintf(' SoluCheck has successfully loaded.\n');
% --- Outputs from this function are returned to the command line.
function varargout = SoluCheck_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure

varargout{1} = handles.output;

function tbBFilePath_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
% hObject    handle to tbBFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbBFilePath as text
%        str2double(get(hObject,'String')) returns contents of tbBFilePath as a double


% --- Executes during object creation, after setting all properties.
function tbBFilePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbBFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tbBSolutionPath_Callback(hObject, eventdata, handles)
% hObject    handle to tbBSolutionPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbBSolutionPath as text
%        str2double(get(hObject,'String')) returns contents of tbBSolutionPath as a double


% --- Executes during object creation, after setting all properties.
function tbBSolutionPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbBSolutionPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbBFilePath.
function pbBFilePath_Callback(hObject, eventdata, handles)
% hObject    handle to pbBFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Initialize starting variables:
bFirstTime = getappdata(findobj('Tag', 'uiBSoluCheck'), 'bFirstTime');
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
stcSounds = getappdata(hSoluCheck, 'stcSounds');
stcSwitches = getappdata(hSoluCheck, 'stcSwitches');
% Get the user's file path; will return 0 if the user cancelled!
[sFileName, sFilePath] = uigetfile('*.m');
setappdata(findobj('Tag', 'uiBSoluCheck'), 'sFileName', sFileName);
setappdata(findobj('Tag', 'uiBSoluCheck'), 'sFilePath', sFilePath);
sOriginalFileName = get(handles.tbBFilePath, 'string');
if sFilePath ~= 0
    % Tell the user that we are loading the specified file
    set(handles.stBTestResults, 'String', 'Loading...', 'ForegroundColor', 'black', 'Background', [.94 .94 .94]);
    pause('on');
    pause(1);
    pause('off');
    cd(sFilePath);
    set(handles.stBFunctionName, 'string', sFileName);
    set(handles.tbBFilePath, 'string', [sFilePath sFileName]);
    % set the solution file path accordingly:
    if strcmp(get(handles.tbBSolutionPath, 'string'), 'Select your solution file...')
        set(handles.tbBSolutionPath, 'string', [sFilePath sFileName(1:end-2) '_soln.p']);
        set(handles.tbBSolutionPath, 'string', [sFilePath sFileName(1:end-2) '_soln.p']);
        sSolutionPath = sFilePath;
        setappdata(findobj('Tag','uiBSoluCheck'), 'sSolutionPath', sSolutionPath);
        sSolutionName = [sFileName(1:end-2) '_soln.p'];
        setappdata(findobj('Tag', 'uiBSoluCheck'), 'sSolutionName', sSolutionName);
    elseif strcmp([sOriginalFileName(1:end-2) '_soln.p'], get(handles.tbBSolutionPath, 'string'))
        set(handles.tbBSolutionPath, 'string', [sFilePath sFileName(1:end-2) '_soln.p']);
        sSolutionPath = sFilePath;
        setappdata(findobj('Tag','uiBSoluCheck'), 'sSolutionPath', sSolutionPath);
        sSolutionName = [sFileName(1:end-2) '_soln.p'];
        setappdata(findobj('Tag', 'uiBSoluCheck'), 'sSolutionName', sSolutionName);
    end
    % Provide file path to outside applications:
    setappdata(handles.uiBSoluCheck, 'cFile', {sFilePath, sFileName});
    try
        % Try to determine how many arguments; if we can't tell the
        % user to select a valid file!
        addpath(sFilePath);
        iNargin = nargin([sFilePath sFileName]);
        setappdata(handles.uiBSoluCheck, 'iNargin', iNargin);
    catch
        strResult = sprintf('Loading File %s...Failed! Please select a valid function file!', sFileName);
        set(handles.stBTestResults, 'string', 'Please select a valid function file!', 'BackgroundColor', 'Yellow');
        if stcSwitches.Details
            hViewer = findobj('Tag', 'uiVViewer');
            hViewer = hViewer.Children(3);
            strOld = get(hViewer, 'String');
            [intLines, ~] = size(strOld);
            cellViewer = cell(1, intLines + 1);
            for i = 1:intLines
                cellViewer{i} = strOld(i, :);
            end
            cellViewer(2:end) = cellViewer(1:end-1);
            cellViewer{1} = strResult;
            set(hViewer, 'String', strjoin(cellViewer, '\n'));
        end
        return
    end
    % Check to make sure no varargin
    if iNargin < 0
        strResult = sprintf('Loading File %s...Failed! Please select a function that does NOT take in varargin!', sFileName);
        set(handles.stBTestResults, 'string', 'Please select a function that does NOT take in a variable number of inputs!', 'BackgroundColor', 'Yellow');
        if stcSwitches.Details
            hViewer = findobj('Tag', 'uiVViewer');
            hViewer = hViewer.Children(3);
            strOld = get(hViewer, 'String');
            [intLines, ~] = size(strOld);
            cellViewer = cell(1, intLines + 1);
            for i = 1:intLines
                cellViewer{i} = strOld(i, :);
            end
            cellViewer(2:end) = cellViewer(1:end-1);
            cellViewer{1} = strResult;
            set(hViewer, 'String', strjoin(cellViewer, '\n'));
        end
        return
    end
    % Prep SoluCheck for testing:
    try
        rmpath(handles.tbBFilePath.String);
    catch
    end
    if iNargin == 0
        set(handles.pbBTest, 'Enable', 'on');
    else
        set(handles.pbBTest, 'Enable', 'off');
    end
    % If we have previously tested, delete all the used uicontrols:
    if ~bFirstTime
        tbBIterations = findobj('Tag', 'tbBIterations');
        tbBIterations.String = '1';
        stBArgumentName = getappdata(hSoluCheck, 'stBArgumentName');
        tbBArgument = getappdata(hSoluCheck, 'tbBArgument');
        pmBDataType = getappdata(hSoluCheck, 'pmBDataType');
        tbBStepSize = getappdata(hSoluCheck, 'tbBStepSize');
        stBDivider = getappdata(hSoluCheck, 'stBDivider');
        if ~isempty(stBArgumentName)
            for i = 1:length(stBArgumentName)
                delete(stBArgumentName{i});
                delete(tbBArgument{i});
                delete(pmBDataType{i});
                delete(tbBStepSize{i});
                delete(stBDivider{i});
            end
            setpixelposition(handles.pbBTest, getpixelposition(handles.pbBTest) + [0, (33 .* i), 0, 0]);
            setpixelposition(handles.pbBCancel, getpixelposition(handles.pbBCancel) + [0, (33 .* i), 0, 0]);
        end
    end
    % tells SoluCheck this is not first time any more!
    bFirstTime = false;
    % update the UI with complete information:
    objProgressBar = getappdata(hSoluCheck, 'objProgressBar');
    objProgressBar.setValue(0);
    objProgressBar.setString('0.00%');
    setappdata(hSoluCheck, 'objProgressBar', objProgressBar);
    setappdata(hSoluCheck, 'bFirstTime', bFirstTime);
    set(handles.stBArgumentNumber, 'string', num2str(iNargin));
    % Create starting cell arrays:
    stBArgumentName = cell(1, iNargin);
    tbBArgument = cell(1, iNargin);
    pmBDataType = cell(1, iNargin);
    tbBStepSize = cell(1, iNargin);
    stBDivider = cell(1, iNargin);
    % Create the UI Controls:
    [cellInArgs, cellOutArgs] = getArgs([sFilePath sFileName]);
    for k = 1:numel(cellInArgs)
        if strcmp(cellInArgs{k}, '~')
            cellInArgs{k} = 'Input Ignored';
        end
    end
    if numel(cellInArgs) ~= iNargin
        cellInArgs((end+1):iNargin) = {'User-Defined Input'};
    end
    for i = 0:iNargin-1
        %Set the handles for arg names
        stBArgumentName{i+1} = uicontrol(handles.uiBSoluCheck, 'Tag', ['stBArgumentName' num2str(i+1)], 'Style', 'text', 'String', sprintf('%d: %s', i+1, cellInArgs{i + 1}), 'FontSize', 10.0);
        setpixelposition(stBArgumentName{i+1}, getpixelposition(handles.stBArgumentNameExample) + [0, (-33 .* i), 0, 0]);
        %Set handles for arguments
        tbBArgument{i+1} = uicontrol(handles.uiBSoluCheck, 'Tag', ['tbBArgument' num2str(i+1)], 'Style', 'edit', 'HorizontalAlignment', 'left', 'FontSize', 10.0, 'String', '', ...
            'ButtonDownFcn', @tbBArgumentExample_ButtonDownFcn, 'KeyPressFcn', @tbBArgument_KeyPressFcn);
        setpixelposition(tbBArgument{i+1}, getpixelposition(handles.tbBArgumentExample) + [0, (-33 .* i), 0, 0]);
        %Set handles for data types
        pmBDataType{i+1} = uicontrol(handles.uiBSoluCheck, 'Tag', ['pmBDataType' num2str(i+1)], 'Style', 'popupmenu', 'String', {'Select A Data Type:', 'Predefined Variable...', 'String', 'Number', 'Array',...
            'Cell Array','Logical', 'Formulaic...'}, 'FontSize', 10.0, 'Callback', @pmBData_Callback, 'Value', 1);
        setpixelposition(pmBDataType{i+1}, getpixelposition(handles.pmBDataTypeExample) + [0, (-33 .* i), 0, 0]);     
        %Set handles for the step sizes
        tbBStepSize{i+1} = uicontrol(handles.uiBSoluCheck, 'Tag', ['tbBStepSize' num2str(i+1)], 'Style', 'edit', 'String', 'N/A', 'Enable', 'off', 'HorizontalAlignment', 'left', 'FontSize', 10.0, ...
            'KeyPressFcn', @tbBStepSize_KeyPressFcn);
        setpixelposition(tbBStepSize{i+1}, getpixelposition(handles.tbBStepExample) + [0, (-33 .* i), 0, 0]);
        %Set handles for the dividers
        stBDivider{i+1} = uicontrol(handles.uiBSoluCheck, 'Tag', ['stBDivider' num2str(i+1)], 'Style', 'text', 'HorizontalAlignment', 'left', 'string', get(handles.stBDividerExample, 'string'), 'FontSize', 4);
        setpixelposition(stBDivider{i+1}, getpixelposition(handles.stBDividerExample) + [0, (-33.*i), 0, 0]);
        %Move the two buttons
        setpixelposition(handles.pbBTest, getpixelposition(handles.pbBTest) + [0, -33, 0, 0]);
        setpixelposition(handles.pbBCancel, getpixelposition(handles.pbBCancel) + [0, -33, 0, 0]);
        %adjust the tab order
        uistack(handles.pbBAdvancedOptions, 'bottom');
        uistack(handles.pbBTest, 'bottom');
        uistack(handles.pbBCancel, 'bottom');
    end
    setappdata(hSoluCheck, 'stBArgumentName', stBArgumentName);
    setappdata(hSoluCheck, 'tbBArgument', tbBArgument);
    setappdata(hSoluCheck, 'pmBDataType', pmBDataType);
    setappdata(hSoluCheck, 'tbBStepSize', tbBStepSize);
    setappdata(hSoluCheck, 'stBDivider', stBDivider);
    % Tell the user that SoluCheck has been prepped and is awaiting
    % User Orders:
    strResult = sprintf('>> Loading File %s...Loaded!', sFileName);
    strDescription = help(sFileName);
    if isempty(cellOutArgs)
        strDetails = 'This function does not output any arguments.';
    elseif numel(cellOutArgs) == 1
        strDetails = sprintf('This function outputs 1 argument: %s.', cellOutArgs{1});
    elseif numel(cellOutArgs) == 2
        strDetails = sprintf('This function outputs 2 arguments: %s and %s.', cellOutArgs{:});
    else
        strDetails = [strjoin(cellOutArgs(1:end-1), ', ') ', and ' cellOutArgs{end}];
        strDetails = sprintf('This function outputs %d arguments: %s.', numel(cellOutArgs), strDetails);
    end
    if ~isempty(strDescription)
        strDescription = sprintf('%s\n%s', strDescription, strDetails);
    else
        strDescription = strDetails;
    end
    strResults = sprintf('%s\nYou''ve selected a valid file; now click Test to continue, or Advanced Options to customize your test.', strDescription);
    set(handles.stBTestResults, 'String', strResults, 'ForegroundColor', 'black', 'BackgroundColor', 'white');
    if ~handles.cbBMute.Value
        sound(stcSounds(1).Start{:});
    end
    cellFormulaic = cell(1, iNargin);
    setappdata(findobj('Tag', 'uiBSoluCheck'), 'cellFormulaic', cellFormulaic);
elseif strcmp(get(handles.tbBFilePath, 'String'), 'Select your file...')
    % If the user cancelled, if we had not ever selected a file, then
    % don't mess with the test results! This might not be necessary.
    strResult = '>> Loading File...Cancelled!';
    set(handles.stBTestResults, 'String', 'Test Results');
else
    return
end

% Get the position of the testing button, so that we can determine how
% our scroller should respond:
vecPosn = getpixelposition(handles.pbBTest);
vecPosn = vecPosn(2);
if vecPosn < 0
    set(handles.slBYScroller, 'Min', 0.00, 'Max', abs(vecPosn), 'Value', abs(vecPosn), 'Visible', 'on');
else
    set(handles.slBYScroller, 'Min', 1.0, 'Max', 1.0, 'Value', 0);
end
intScrollerValue = abs(vecPosn);
setappdata(hSoluCheck, 'intScrollerValue', intScrollerValue);
vecFirstPosn = getpixelposition(handles.pbBTest);
setappdata(hSoluCheck, 'vecFirstPosn', vecFirstPosn);
% Write to the logger, if appropriate:
if stcSwitches.Details
    hViewer = findobj('Tag', 'uiVViewer');
    hViewer = hViewer.Children(3);
    strOld = get(hViewer, 'String');
    [intLines, ~] = size(strOld);
    cellViewer = cell(1, intLines + 1);
    for i = 1:intLines
        cellViewer{i} = strOld(i, :);
    end
    cellViewer(2:end) = cellViewer(1:end-1);
    cellViewer{1} = strResult;
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end

function pbBFilePath_KeyPressFcn(hObject, eventdata, handles)
% Launch the Browse figure if needed:
handles = guidata(hObject);
if any(strcmp({' ', 'return'}, eventdata.Key))
    pbBFilePath_Callback(hObject, [], handles);
end

function tbBArgument_KeyPressFcn(hObject, eventdata, handles)
% Launch the Browse figure if needed:
handles = guidata(hObject);
if strcmp('return', eventdata.Key) && strcmp(handles.pbBTest.Enable, 'on')
    pbBTest_Callback(handles.pbBTest, [], handles);
end

function tbBStepSize_KeyPressFcn(hObject, eventdata, handles)
% Launch Test module, if needed:
handles = guidata(hObject);
if strcmp('return', eventdata.Key) && strcmp(handles.pbBTest.Enable, 'on')
    pbBTest_Callback(handles.pbBTest, [], handles);
end

% --- Executes on button press in pbBSolutionFilePath.
function pbBSolutionFilePath_Callback(hObject, eventdata, handles)
% hObject    handle to pbBSolutionFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
% only show p files!
[sSolutionName, sSolutionPath] = uigetfile('*.p');
% if ALL of them are 0, then we need to cancel
if all(sSolutionPath == 0)
    set(handles.tbBSolutionPath, 'string', 'Select your solution file...');
else
    % otherwise, set the string!
    set(handles.tbBSolutionPath, 'string', [sSolutionPath sSolutionName]);
    setappdata(findobj('Tag', 'uiBSoluCheck'), 'sSolutionPath', sSolutionPath);
    setappdata(findobj('Tag', 'uiBSoluCheck'), 'sSolutionName', sSolutionName);
    addpath(sSolutionPath);
    strResult = 'Loading File %s...Loaded!';
end
% Log this to the details pane:
if stcSwitches.Details
    hViewer = findobj('Tag', 'uiVViewer');
    hViewer = hViewer.Children(3);
    strOld = get(hViewer, 'String');
    [intLines, ~] = size(strOld);
    cellViewer = cell(1, intLines + 1);
    for i = 1:intLines
        cellViewer{i} = strOld(i, :);
    end
    cellViewer(2:end) = cellViewer(1:end-1);
    cellViewer{1} = strResult;
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end

function pbBSolutionFilePath_KeyPressFcn(hObject, eventdata, handles)
% Launch Browse figure, if needed:
handles = guidata(hObject);
if strcmp({' ', 'return'}, eventdata.Key)
    pbBSolutionPath_Callback(hObject, [], handles);
end

% --- Executes on button press in pbBAdvancedOptions.
function pbBAdvancedOptions_Callback(hObject, eventdata, handles)
% hObject    handle to pbBAdvancedOptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AdvancedOptions;

function tbBIterations_KeyPressFcn(hObject, eventdata, handles)
% Launch Test module, if needed:
handles = guidata(hObject);
if strcmp(eventdata.Key, 'return') && strcmp(handles.pbBTest.Enable, 'on')
    pbBTest_Callback(handles.pbBTest, [], handles);
end

% --- Executes on button press in pbBCancel.
function pbBCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pbBCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if we are not testing, simply exit SoluCheck. If we ARE testing, however,
% tell the engine that it's time to stop!
if strcmp(hObject.String, 'Done')
    close;
else
    setappdata(findobj('Tag', 'uiBSoluCheck'), 'logCancel', true);
end
    
% --- Executes on button press in pbBTest.
function pbBTest_Callback(hObject, eventdata, handles)
% hObject    handle to pbBTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Initialize our handle and starting variables:
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
iNargin = getappdata(hSoluCheck, 'iNargin');
stcSwitches = getappdata(handles.uiBSoluCheck, 'stcSwitches');
sFileName = getappdata(hSoluCheck, 'sFileName');
sSolutionName = getappdata(hSoluCheck, 'sSolutionName');
stBArgumentName = getappdata(hSoluCheck, 'stBArgumentName');
tbBArgument = getappdata(hSoluCheck, 'tbBArgument');
pmBDataType = getappdata(hSoluCheck, 'pmBDataType');
tbBStepSize = getappdata(hSoluCheck, 'tbBStepSize');
stBDivider = getappdata(hSoluCheck, 'stBDivider');
stcSounds = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSounds');
bError = false;
% Set the strings to say that we have commenced testing:
set(handles.pbBCancel, 'String', 'Cancel');
set(handles.stBTestResults, 'String', 'Please Wait - Testing...', 'BackgroundColor', 'blue', 'ForegroundColor', 'white'); 
% Allow the UI to reload
drawnow();
% Create our cell arrays of data:
cstBArgumentName = cell(1, iNargin);
ctbBArgument = cell(1, iNargin);
cDataType = cell(1, iNargin);
ctbBStepSize = cell(1, iNargin);
cstBDivider = cell(1, iNargin);
cArgs = cell(1, iNargin .* 2);

%Data Types
%1. Select A Data Type:
%1. Predefined Variable...
%2. String
%3. Number
%4. Array
%5. Cell Array
%6. Logical
%7. Formulaic...
cClass = {'Predefined Variable...', 'String', 'Number', 'Array', 'Cell Array', 'Logical', 'Formulaic...'};
% If it is loading from a database, this supercedes anything else, and
% SoluCheck Engine deals with conversion factors.
strError = '';
if stcSwitches.LoadDatabase
    for i = 1:iNargin
        ctbBArgument{i} = 1;
        ctbBStepSize{i} = 0;
        cArgs{2 .* i -1} = ctbBArgument{i};
        cArgs{2 .* i} = ctbBStepSize{i};
    end
else
    % Otherwise, switch among the different possible cases:
    for i = 1:iNargin
        cstBArgumentName{i} = get(stBArgumentName{i}, 'string');
        ctbBArgument{i} = get(tbBArgument{i}, 'string');
        % Subtract 1, so that 1-7 is the data types; this will cause a 0
        % though!!!!
        cDataType{i} = get(pmBDataType{i}, 'value') - 1;
        switch cDataType{i}
            case 0
                % if it is 0, then the user done messed up. Return with
                % error and log to viewer, if possible:
                bError = true;
                strError = [strError sprintf('Argument #%d: The Data type must be defined!', i)]; %#ok<AGROW>
            case 1
                try
                    % If it is case 1, then we need to convert a predefined
                    % variable; this part is really more vestigial, seeing
                    % as it is dynamically defined in the Engine!
                    ctbBArgument{i} = 'IN ENGINE';
                catch ME
                    bError = true;
                    if strcmp(ME.identifier, 'MATLAB:UndefinedFunction')
                        % if the variable is NOT defined, say so (though
                        % this should never be able to happen! Oh, except
                        % if user clears data!
                        strError = [strError sprintf('Argument #%d: The variable is not currently defined.\n', i)];    %#ok<AGROW>
                    else
                        strError = [strError sprintf('Argument #%d: Evaluation failed.\n', i)];  %#ok<AGROW>
                    end
                end
            case 2
                try
                    % Try to create a string array:
                    ctbBArgument{i} = char(ctbBArgument{i});
                    [ctbBArgument{i}, ~] = strtok(ctbBArgument{i}, '''');
                    % check if this created any NaN values?
                    if any(any(isnan(ctbBArgument{i})))
                        bError = true;
                        % if there is a NaN, say so!
                        strError = [strError sprintf('Argument #%d: Conversion to class %s resulted in a null value.\n', i, cClass{2})];  %#ok<AGROW>
                    end
                catch %#ok<*CTCH>
                    bError = true;
                    % if we error out, say so!
                    strError = [strError sprintf('Argument #%d: Conversion to class %s failed.\n', i, cClass{2})];   %#ok<AGROW>
                end
            case 3
                try
                    % Try to create a STATIC number from the argument!
                    ctbBArgument{i} = str2double(ctbBArgument{i});
                    if isempty(ctbBArgument{i}) || any(any(isnan(ctbBArgument{i})))
                        % if NaN OR Empty (subject for further review),
                        % then say so!
                        bError = true;
                        strError = [strError sprintf('Argument #%d: Conversion to class %s resulted in a null value.\n', i, cClass{3})];    %#ok<AGROW>
                    end
                catch
                    % if we error out, say so!
                    bError = true;
                    strError = [strError sprintf('Argument #%d: Conversion to class %s failed.\n', i, cClass{3})];  %#ok<AGROW>
                end
            case 4
                try
                    % try to make an array; this will literally just
                    % evaluate the given arguments. Kind of unsafe, but I
                    % have no better way to do this!
                    ctbBArgument{i} = eval(ctbBArgument{i});
                    if any(any(isnan(ctbBArgument{i})))
                        % if we get NaN values, say so!
                        bError = true;
                        strError = [strError sprintf('Argument #%d: Conversion to class %s resulted in a NaN value.\n', i, cClass{4})];    %#ok<AGROW>
                    end
                    if isempty(ctbBArgument{i})
                        % if it is empty, say so!
                        strError = [strError sprintf('Argument #%d: Conversion to class %s resulted in a null value.\n', i, cClass{4})];    %#ok<AGROW>
                    end
                catch
                    % if we error out, say so!
                    bError = true;
                    strError = [strError sprintf('Argument #%d: Conversion to class %s failed.\n', i, cClass{4})];   %#ok<AGROW>
                end
            case 5
                try
                    % try to evaluate a cell array, if we get a non-cell
                    % array, say so!
                    ctbBArgument{i} = eval(ctbBArgument{i});
                    if ~iscell(ctbBArgument{i})
                        bError = true;
                        strError = [strError sprintf('Argument #%d: No cell array detected.\n', i)]; %#ok<AGROW>
                    else
                        % No error here, but we need to say that IF we have
                        % a cell array, no stepping!
                        strError = [strError sprintf('Argument #%d: A cell array was detected and was not stepped.\n', i)]; %#ok<AGROW>
                    end
                catch
                    % if we error, say so!
                    bError = true;
                    strError = [strError sprintf('Argument #%d: Conversion to class %s failed.\n', i, cClass{5})];    %#ok<AGROW>
                end
            case 6
                % if we have a logical vector, evaluate the string, then
                % convert ot logical. IF IT IS NOT A LOGICAL, THROW AN
                % ERROR!
                try
                    ctbBArgument{i} = logical(eval(ctbBArgument{i}));
                    if ~islogical(ctbBArgument{i})
                        bError = true;
                        strError = [strError sprintf('Argument #%d: No logical vector detected. Please enter it in the form of either [1 0 ...] or [true, false, ...]\n', i)];  %#ok<AGROW>
                    end
                catch
                    % if we error, say so!
                    bError = true;
                    strError = [strError sprintf('Argument #%d: Conversion to class %s failed.\n', i, cClass{7})];      %#ok<AGROW>
                end
            case 7
                try
                    % just say that we have a stored formula; this will be
                    % dynamically redefined in SoluCheck Engine!
                    ctbBArgument{i} = 'Stored Formula';
                    strError = [strError sprintf('Argument #%d: A Formulaic Entry was detected and was not stepped.\n', i)];    %#ok<AGROW>
                catch ME
                    % if we somehow error, say so (I guess. This should
                    % never happen).
                    bError = true;
                    strError = [strError sprintf('Argument #%d: Unable to evaluate formula. Error Message:\n%s\n', i, ME.message)]; %#ok<AGROW>
                end
            otherwise
                % if we have exhausted all cases, and we somehow get a
                % larger number, say that we have NO idea what happened
                bError = true;
                strError = [strError sprintf('Argument #%d: Undefined data type.\n', i)]; %#ok<AGROW>
        end
        % Each time we run, convert our step size to N/A if need be!
        ctbBStepSize{i} = get(tbBStepSize{i}, 'string');
        if strcmp(ctbBStepSize{i}, '0') || isempty(ctbBStepSize) || strcmp(ctbBStepSize{i}, 'N/A')
            ctbBStepSize{i} = 'N/A';
        else
            % otherwise, just convert it to a number!
            ctbBStepSize{i} = str2double(ctbBStepSize{i});
        end
        % create our dividers
        cstBDivider{i} = get(stBDivider{i}, 'string');
        % store our cell array of arguments to be passed to SoluCheck:
        cArgs{2 .* i -1} = ctbBArgument{i};
        cArgs{2 .* i} = ctbBStepSize{i};
    end
end
% create our iterations; if it does not work, say so!
try
    intIterations = str2double(handles.tbBIterations.String);
catch
    bError = true;
    strError = [strError sprintf('Iteration Amount: Please enter a number!')];
end
% check if the iteration number is less than 0 or infinity; act accordingly
if intIterations == inf || intIterations <= 0 || isnan(intIterations)
    bError = true;
    strError = [strError sprintf('Iteration Amount: Please enter a positive, finite entry!\n')];
end

% IF there were no thrown errors (NOT to be confused with a non-empty
% strError), DO NOT execute the SoluCheck Engine, and instead immediately
% report back. 
if ~bError
    fprintf('Please Wait - SoluCheck is Testing...');
    % Retrieve ALL of the outputs from SoluCheck Engine, using the
    % arguments we've created above. The Engine is literally called
    % SoluCheckEngine
    [logPassed, strEngineError, intArgNumber, cellFinalArgs, cellAnswers, cellSolutions, vecCodeTime, vecSolnTime, fidAudit] = ...
        SoluCheckEngine(sFileName(1:end-2),sSolutionName(1:end-2), round(intIterations), cDataType, cArgs{:});
    % set the app data as public data:
    fprintf(' SoluCheck has finished testing. Analyzing Results...\n');
    setappdata(hSoluCheck, 'cFinalArgs', cellFinalArgs);
    setappdata(hSoluCheck, 'cAnswers', cellAnswers);
    setappdata(hSoluCheck, 'cSolutions', cellSolutions);
    % set the string for iteration number!
    if intArgNumber == 1
        sArgNumber = '1 iteration';
    else
        sArgNumber = sprintf('%d iterations', intArgNumber);
    end
    % if we are testing plots, retrieve the plot data, and alert the user:
    if stcSwitches.PlotTesting
        vecPercents = getappdata(handles.uiBSoluCheck, 'vecPlotAverage');
        strError = [strError sprintf('Average Plot Difference: %0.4f%%', (mean(vecPercents) / numel(vecPercents)) * 100)];
    end
    % ONLY do the following things IF WE PASSED
    if logPassed
        % tell the user we passed; play audio
        strResult = sprintf(['We have successfully tested your function. Using %s, we found no disagreements between your function and the given solution file.\nTest Passed!'...
            '\nAlerts Generated:\n%s'], sArgNumber, strError);
        set(handles.stBTestResults, 'string', strResult, 'BackgroundColor', 'Green', 'ForegroundColor', 'black');
        if ~handles.cbBMute.Value
            intChoice = randi([1, 4]);
            sound(stcSounds(intChoice).Pass{:});
        end
    elseif isempty(strEngineError)
            % tell the user that they failed! Play the sound as well.
        strResult = sprintf(['We have successfully tested your function, and we found a disagreement. The iteration number was %d, and the arguments used for this iteration, '...
            'as well as your answers and the solutions, have been output to the command line.\nTest Failed!\nAlerts Generated:\n%s'], intArgNumber, strError);
        set(handles.stBTestResults, 'string', strResult, 'BackgroundColor', 'Red', 'ForegroundColor', 'white');
        if ~handles.cbBMute.Value
            intChoice = randi([1, 3]);
            sound(stcSounds(intChoice).Fail{:});
        end
    else
        % tell the user we ERRORED; this DOES NOT (necessarily) MEAN A
        % FAILURE! Play the audio as well.
        strResult = sprintf('We were unsuccessful in testing the functions; Here''s the error message that was last produced:\n%s\nTest Error!', strEngineError);
        set(handles.stBTestResults, 'string', strResult, 'BackgroundColor', 'Yellow', 'ForegroundColor', 'black');
        if ~handles.cbBMute.Value
            intChoice = randi([1, 3]);
            sound(stcSounds(intChoice).Error{:});
        end
    end
    % update the UI
    pause('on');
    pause(1/10000);
    pause('off');
    % assign the variables in the base.
    assignin('base', 'cArguments', cellFinalArgs);
    assignin('base', 'cAnswers', cellAnswers);
    assignin('base', 'cSolutions', cellSolutions);
    % if we were timing, create the plots for timing;
    if stcSwitches.Timing && numel(vecCodeTime) == intArgNumber
        assignin('base', 'cTiming', {vecCodeTime, vecSolnTime});
        uiPPlots = figure('Tag', 'uiPPlots', 'ToolBar', 'none', 'MenuBar', 'None', 'Name', 'SoluCheck Code Analyzer', 'NumberTitle', 'off');
        plot(1:intArgNumber, vecCodeTime, 1:intArgNumber, vecSolnTime);
        legend(sprintf('Code Time, Average of %ds', mean(vecCodeTime)), sprintf('Solution Time, Average of %ds', mean(vecSolnTime)));
        title(sprintf('SoluCheck Code Analyzer: %s', sFileName));
        xlabel('Number of Iterations');
        ylabel('Time to compute, in seconds');
        % give the user the ability to save the results!
        pbPSave = uicontrol(uiPPlots, 'Style', 'pushbutton', 'String', 'Save', 'Callback', @pbPSave_Callback, 'FontSize', 10.0, 'HorizontalAlignment', 'center', 'Units', 'Normalized');
        uiPPlotsPosn = getpixelposition(uiPPlots);
        setpixelposition(pbPSave, [uiPPlotsPosn(3) - 40, 0, 40, 30]);
    end
    % open our profiler, if need be:
    if stcSwitches.Profiler
        profile('viewer');
    end
    % publish our file, if need be!
    if fidAudit ~= -1
        fclose(fidAudit);
        fidAudit = publish([cd '\auditFile.m'], struct('outputDir', cd, 'evalCode', false));
        delete([cd '\auditFile.m']);
        web(fidAudit, '-browser');
    end
else
    % if we errored out DURING THE CONVERSION PROCESS (NOT IN THE ENGINE),
    % do NOT run the engine; report back IMMEDIATELY!
    strResult = sprintf('There were one or more errors in your arguments. Please try again. Details:\n%s', strError);
    set(handles.stBTestResults, 'string', strResult, 'BackgroundColor', 'Yellow', 'ForegroundColor', 'black');
    if ~handles.cbBMute.Value
        intChoice = randi([1, 3]);
        sound(stcSounds(intChoice).Error{:})
    end
end
% if the user wanted to be notified, send the email:
if stcSwitches.Notifications
    cOldPrf = getappdata(handles.uiBSoluCheck, 'cOldPrf');
    cNewPrf = getappdata(handles.uiBSoluCheck, 'cNewPrf');
    if logPassed
        strResult = sprintf('Passed!\nDetails:\n\n%s', strResult);
    elseif bError
        strResult = sprintf('Errored Out!\nDetails:\n\n%s', strResult);
    else
        strResult = sprintf('Failed!\nDetails:\n\n%s', strResult);
    end
    try
        % send the emails!
        if cNewPrf{4}
            save('results.mat', 'cellFinalArgs', 'cellAnswers', 'cellSolutions', 'vecCodeTime', 'vecSolnTime');
            sendmail(cNewPrf{3}, 'SoluCheck Complete!', sprintf('Dear %s,\n\nSoluCheck has finished testing your code. Your code %s\n\nThe SoluWorks Team', [cNewPrf{1} ' ' cNewPrf{2}], strResult), 'results.mat');
        else
            sendmail(cNewPrf{3}, 'SoluCheck Complete!', sprintf('Dear %s,\n\nSoluCheck has finished testing your code. Your code %s\n\nThe SoluWorks Team', [cNewPrf{1} ' ' cNewPrf{2}], strResult));
        end
    catch ME
        % tell the user if we failed to send the notification
        msgbox(sprintf('Notification Failed!\n\nError:\n%s\n%s', ME.identifier, ME.message))
    end
    try
        % reset the preferences; this is prone to errors, and I think that
        % it *might* be due to if the user never set these properties.
        if cNewPrf{4}
            prfRecycleState = recycle;
            recycle('off');
            delete('results.mat');
            recycle(prfRecycleState);
        end
        % set the properties, as per what was previously entered:
        setpref('Internet', 'SMTP_Server', cOldPrf{1});
        setpref('Internet','E_mail', cOldPrf{2});
        setpref('Internet','SMTP_Username', cOldPrf{2});
        setpref('Internet','SMTP_Password', cOldPrf{3});
        props = java.lang.System.getProperties;
        props.setProperty('mail.smtp.auth', cOldPrf{4});
        props.setProperty('mail.smtp.socketFactory.class', cOldPrf{5});
        props.setProperty('mail.smtp.socketFactory.port',cOldPrf{6});
    catch
        msgbox('Your message was sent, but we ran into problems reverting back to the old settings.\n');
    end
end
% if we have details to log, log them!
if stcSwitches.Details
    hViewer = findobj('Tag', 'uiVViewer');
    hViewer = hViewer.Children(3);
    strOld = get(hViewer, 'String');
    [intLines, ~] = size(strOld);
    cellViewer = cell(1, intLines + 1);
    for i = 1:intLines
        cellViewer{i} = strOld(i, :);
    end
    cellViewer(2:end) = cellViewer(1:end-1);
    cellViewer{1} = strResult;
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end
fprintf(' Analyzed!\n');
% tell the user that we are completely done!
set(handles.pbBCancel, 'String', 'Done');

function pbBTest_KeyPressFcn(hObject, eventdata, handles)
% run the Test Module for key presses
handles = guidata(hObject);
if any(strcmp({' ', 'return'}, eventdata.Key)) && strcmp(handles.pbBTest.Enable, 'on')
    pbBTest_Callback(handles.pbBTest, [], handles);
end

function pbBCancel_KeyPressFcn(hObject, eventdata, handles)
% run the cancel callback, for key presses:
handles = guidata(hObject);
if any(strcmp({' ', 'return'}, eventdata.Key))
    pbBCancel_Callback(handles.pbBCancel, [], handles);
end

function pbPSave_Callback(hObject, callbackdata)
[strName, strPath] = uiputfile({'*.jpg'}, 'Save As:', 'CodeAnalyzer.jpg');
strFileName = [strPath, strName];
if strName ~= 0
    saveas(hObject.Parent, strFileName);
end 
    
function tbBIterations_Callback(hObject, eventdata, handles)
% hObject    handle to tbBIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbBIterations as text
%        str2double(get(hObject,'String')) returns contents of tbBIterations as a double


% --- Executes during object creation, after setting all properties.
function tbBIterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbBIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tbBArgumentExample_Callback(hObject, eventdata, handles)
% hObject    handle to tbBArgumentExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbBArgumentExample as text
%        str2double(get(hObject,'String')) returns contents of tbBArgumentExample as a double


% --- Executes during object creation, after setting all properties.
function tbBArgumentExample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbBArgumentExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tbBArgumentExample_ButtonDownFcn(hObject, eventdata, handles)
% if we click the argument text box, we *might* need to do something; here
% we figure out what to do!
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
tbBArgument = getappdata(hSoluCheck, 'tbBArgument');
pmBDataType = getappdata(hSoluCheck, 'pmBDataType');
strName = hObject.Tag;
intArgument = str2double(strName(12:end));
% ONLY if our text box is NOT enabled in some way should we even react!
if ~strcmp(hObject.Enable, 'on')
    if pmBDataType{intArgument}.Value == 8
        % 8 means a stored formula; reload our previous formulaic entry and
        % write it to a formulaic window
        cellFormulaic = getappdata(findobj('Tag', 'uiBSoluCheck'), 'cellFormulaic'); 
        uiCCommandWindow = figure('Visible', 'off', 'Name', ['SoluCheck: Formulaic Entry #', strName(12:end)] , 'NumberTitle', 'off', 'position', [350 50 500 550], 'Tag', 'uiCCommandWindow',...
            'WindowStyle', 'modal', 'MenuBar', 'none', 'CloseRequestFcn', {@pbCCancel_Callback, hObject.Tag});
        tbCCommandLine = uicontrol('Style', 'edit', 'Tag', 'tbCCommandLine', 'KeyPressFcn', @tbCCommandLine_KeyPressFcn, 'position', [0, 50, 500, 500], 'HorizontalAlignment', 'left', 'Max', 100, 'Min', 0, 'Units', 'Normalized', 'String', '>> ', 'FontSize', 10.0, 'ToolTip', sprintf(['Please enter your code in the following field as it would be entered into the command line.\n**Assign the desired argument value to the out variable!\n'... 
                        'Note that you may utilize the current iteration by calling the variable intIterationNumber']), 'CreateFcn', @tbCCommandLine_CreateFcn);
        pbCConfirm = uicontrol('Style', 'pushbutton', 'string', 'Confirm', 'position', [250, 0, 250, 50], 'Callback', {@pbCConfirm_Callback, hObject.Tag}, 'Units', 'Normalized'); %#ok<NASGU>
        pbCCancel = uicontrol('Style', 'pushbutton', 'String', 'Cancel', 'position', [0, 0, 250, 50], 'Callback', {@pbCCancel_Callback, hObject.Tag}, 'Units', 'Normalized'); %#ok<NASGU>
        uiCCommandWindow.Visible = 'on';
        uiCCommandWindow.WindowStyle = 'modal';
        %make the window visible and add our code!
        cellFormulaic{intArgument}{1} = ['>> ' cellFormulaic{intArgument}{1}];
        tbCCommandLine.String = strjoin(cellFormulaic{intArgument}, '\n');
        setappdata(hSoluCheck, 'tbCCommandLine', tbCCommandLine);
    elseif pmBDataType{intArgument}.Value == 2
        % if the value is 2, then we have a predefined variable; reload the
        % predefined variable list!
        cellVariables = evalin('base', 'who');
        uiWWorkSpace = figure('Visible', 'off', 'Name', ['SoluCheck: WorkSpace Variable #',...
        strName(12:end)], 'NumberTitle', 'off', 'position', [350 50 500 450], 'Tag', 'uiWWorkSpace', ...
            'Units', 'Normalized', 'KeyPressFcn', {@uiWWorkSpace_KeyPressFcn, hObject.Tag}, ...
            'CloseRequestFcn', {@uiWWorkSpace_CloseRequestFcn, hObject.Tag}, 'WindowStyle', 'modal');
        lbWVariables = uicontrol('Style', 'listbox', 'Tag', 'lbWVariables', 'String', cellVariables, 'FontSize', 10.0, 'KeyPressFcn', {@lbWVariables_KeyPressFcn, hObject.Tag});
        vecPosn = getpixelposition(uiWWorkSpace);
        vecPosn(1:2) = 0;
        setpixelposition(lbWVariables, vecPosn);
        %set the correct pixel positions, and make it visible!
        uiWWorkSpace.Visible = 'on';
        uiWWorkSpace.WindowStyle = 'modal';
        set(tbBArgument{intArgument}, 'Enable', 'inactive');
    end
end

function tbCCommandLine_CreateFcn(hObject, callbackdata)
strFormulaic = getappdata(hObject, 'strFormulaicEntry');
hFormulaicText = findobj('Tag', 'tbCCommandLine');
if isempty(strFormulaic)
    hFormulaicText.String = '>> ';
else
    hFormulaicText.String = strFormulaic;
end

function tbCCommandLine_KeyPressFcn(hObject, eventdata, handles)

function tbBStepExample_Callback(hObject, eventdata, handles)
% hObject    handle to tbBStepExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbBStepExample as text
%        str2double(get(hObject,'String')) returns contents of tbBStepExample as a double


% --- Executes during object creation, after setting all properties.
function tbBStepExample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbBStepExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pmBDataTypeExample.
function pmBDataTypeExample_Callback(hObject, eventdata, handles)
% hObject    handle to pmBDataTypeExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pmBDataTypeExample contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmBDataTypeExample


% --- Executes during object creation, after setting all properties.
function pmBDataTypeExample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmBDataTypeExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    
function pmBData_Callback(hObject, callbackdata)
% when we select a choice, work accordingly!
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
hpbBTest = findobj('Tag', 'pbBTest');
% load in our textboxes and pop up menus, and get starting variables
tbBArgument = getappdata(hSoluCheck, 'tbBArgument');
pmBDataType = getappdata(hSoluCheck, 'pmBDataType');
tbBStepSize = getappdata(hSoluCheck, 'tbBStepSize');
strName = hObject.Tag;
intName = str2double(strName(12:end));
iNargin = getappdata(hSoluCheck, 'iNargin');
stcSwitches = getappdata(hSoluCheck, 'stcSwitches');
if hObject.Value == 8
    % if we have a formulaic entry (8), work accordingly (as shown above):
    uiCCommandWindow = figure('Visible', 'on', 'Name', ['SoluCheck: Formulaic Entry #', ...
        strName(12:end)], 'NumberTitle', 'off', 'position', [350 50 500 550], 'Tag', 'uiCCommandWindow',...
        'WindowStyle', 'modal', 'CloseRequestFcn', {@pbCCancel_Callback, hObject.Tag}, 'MenuBar', 'none');
    tbCCommandLine = uicontrol('Style', 'edit',  'Tag', 'tbCCommandLine', 'position', [0, 50, 500, 500], 'HorizontalAlignment', 'left', ...
        'Max', 100, 'Min', 0, 'Units', 'Normalized', 'String', '>> ', 'KeyPressFcn', @tbCCommandLine_KeyPressFcn, 'FontSize', 10.0, 'ToolTip',...
        sprintf(['Please enter your code in the following field as it would be entered into the command line.\n**Assign the desired argument value to the out variable!\n'... 
                        'Note that you may utilize the current iteration by calling the variable intIterationNumber.']), 'CreateFcn', @tbCCommandLine_CreateFcn);
    uicontrol('Style', 'pushbutton', 'string', 'Confirm', 'position', [250, 0, 250, 50], 'Callback', {@pbCConfirm_Callback, hObject.Tag}, 'Units', 'Normalized');
    uicontrol('Style', 'pushbutton', 'String', 'Cancel', 'position', [0, 0, 250, 50], 'Callback', {@pbCCancel_Callback, hObject.Tag}, 'Units', 'Normalized');
    uiCCommandWindow.Visible = 'on';
    uiCCommandWindow.WindowStyle = 'normal';
    set(tbBArgument{intName}, 'Enable', 'inactive');
    setappdata(hSoluCheck, 'tbCCommandLine', tbCCommandLine);
elseif hObject.Value == 2
    % if we have a predefined variable (2), work accordingly (as shown
    % above):
    cellVariables = evalin('base', 'who')';
    if stcSwitches.LoadVariables
        cellFiles = getappdata(hSoluCheck, 'cellFileNames');
        for i = 1:numel(cellFiles)
            stcDetails = whos(matfile(cellFiles{i}{2}));
            cellNames = {stcDetails.name};
            cellVariables = [cellVariables cellNames]; %#ok<AGROW>
        end
    end
    uiWWorkSpace = figure('Visible', 'off', 'Name', ['SoluCheck: WorkSpace Variable #',...
        strName(12:end)], 'NumberTitle', 'off', 'position', [350 50 500 450], 'Tag', 'uiWWorkSpace', ...
        'Units', 'Normalized', 'KeyPressFcn', {@uiWWorkSpace_KeyPressFcn, hObject.Tag}, ...
        'CloseRequestFcn', {@uiWWorkSpace_CloseRequestFcn, hObject.Tag}, 'WindowStyle', 'modal');
    lbWVariables = uicontrol('Style', 'listbox', 'Tag', 'lbWVariables', ...
        'String', cellVariables, 'FontSize', 10.0, 'KeyPressFcn', ...
        {@lbWVariables_KeyPressFcn, hObject.Tag});
    vecPosn = getpixelposition(uiWWorkSpace);
    vecPosn(1:2) = 0;
    setpixelposition(lbWVariables, vecPosn);
    uiWWorkSpace.Visible = 'on';
    uiWWorkSpace.WindowStyle = 'modal';
    set(tbBArgument{intName}, 'Enable', 'inactive', 'String', '');
else
    % Otherwise, just make sure the text box is enabled:
    set(tbBArgument{intName}, 'Enable', 'on');
end
% if the value is 1, 2, 6, or 8 (Undefined, Predefined, Cell Array, or
% Formulaic), then DO NOT allow a step size! Otherwise, we should.
switch hObject.Value
    case {1}
        set(tbBStepSize{intName}, 'Enable', 'off', 'string', 'N/A');
        set(tbBArgument{intName}, 'Enable', 'on', 'String', '');
    case {2, 6, 8}
        set(tbBStepSize{intName}, 'Enable', 'off', 'string', 'N/A')
    case {3, 4, 5, 7}
        if strcmp(tbBStepSize{intName}.String, 'N/A')
            tbBStepSize{intName}.String = '1';
        end
        set(tbBStepSize{intName}, 'Enable', 'on');
end
% allow testing by default, but if any of the other pop up menus are not
% ready, then DISABLE testing!
set(hpbBTest, 'Enable', 'on');
for i = 1:iNargin
    intChoice = pmBDataType{i}.Value;
    if intChoice == 1
        set(hpbBTest, 'Enable', 'off');
    break
    end
end

function uiWWorkSpace_KeyPressFcn(hObject, eventdata, strName)
hObject = hObject.Children(1);
lbWVariables_KeyPressFcn(hObject, eventdata, strName);

function uiWWorkSpace_CloseRequestFcn(hObject, eventdata, strName)
tbBArgument = getappdata(findobj('Tag', 'uiBSoluCheck'), 'tbBArgument');
if strcmp(tbBArgument{str2double(strName(12:end))}.String, '')
    pmBDataType = getappdata(findobj('Tag', 'uiBSoluCheck'), 'pmBDataType');
    pmBDataType{str2double(strName(12:end))}.Value = 1;
    tbBArgument{str2double(strName(12:end))}.Enable = 'on';
    delete(hObject);
end

function pbCConfirm_Callback(hObject, callbackdata, strName)
% write our formulaic data to the cell array for evaluation within the
% Engine itself!
tbBArgument = getappdata(findobj('Tag', 'uiBSoluCheck'), 'tbBArgument');
tbCCommandLine = getappdata(findobj('Tag', 'uiBSoluCheck'), 'tbCCommandLine');
cellFormulaic = getappdata(findobj('Tag', 'uiBSoluCheck'), 'cellFormulaic');
strCode = tbCCommandLine.String;
if numel(strCode) ~= 0
    [strFirst, strSecond] = strtok(strCode(1, :), '> ');
else
    [strCode, strFirst, strSecond] = deal('');
end
    intLines = size(strCode, 1);
cellCode = cell(1, intLines);
cellCode{1} = [strFirst, strSecond];
for i = 2:intLines
    cellCode{i} = strCode(i, :);
end
intArgument = str2double(strName(12:end));
cellFormulaic{intArgument} = cellCode;
% this code is no longer useful, as of now, at least.
% what if we instead STORE the code in the app? Then it could be evaluated
% every time!!!!
% To do this, we would need to have standardized method for storing data!
% We would also need to open the engine, but we will deal with that later.
% Our naming method: 
% strResult = evalc(strjoin(cellCode, '\n'));
% [~, strResult] = strtok(strResult, '=');
% [~, strResult] = strtok(strResult, ' =');
% strResult = strtok(strResult);
setappdata(findobj('Tag', 'uiBSoluCheck'), 'cellFormulaic', cellFormulaic);
set(tbBArgument{intArgument}, 'String', 'Stored Formula:');
delete(hObject.Parent);

function pbCCancel_Callback(hObject, callbackdata, strName)
% if we cancel, change the data type to Undefined!
pmBDataType = getappdata(findobj('Tag', 'uiBSoluCheck'), 'pmBDataType');
hPopMenu = pmBDataType{str2double(strName(12:end))};
hPopMenu.Value = 1;
pmBData_Callback(hPopMenu, []);
close;

function lbWVariables_KeyPressFcn(hObject, eventdata, strName)
if strcmp('return', eventdata.Key)
    tbBArgument = getappdata(findobj('Tag', 'uiBSoluCheck'), 'tbBArgument');
    intChoice = hObject.Value;
    cellChoices = hObject.String;
    tbBArgument{str2double(strName(12:end))}.String = cellChoices{intChoice};
    setappdata(findobj('Tag', 'uiBSoluCheck'), 'tbBArgument', tbBArgument);
    delete(findobj('Tag', 'uiWWorkSpace'));
end

% --- Executes when uiBSoluCheck is resized.
function uiBSoluCheck_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uiBSoluCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
% if we are first starting, set the starting variables:
if ~isappdata(hSoluCheck, 'vecOldSize')
    vecOldSize = getpixelposition(hSoluCheck);
    vecOldSize = vecOldSize(3:4);
else
    vecOldSize = getappdata(hSoluCheck, 'vecOldSize');
end
if ~isappdata(hSoluCheck, 'bFirstTime')
    bFirstTime = true;
else
    bFirstTime = getappdata(hSoluCheck, 'bFirstTime');
end
% get all the data that we need. Of note; if this is run FOR THE FIRST
% TIME, iNargin is empty, and so is cell names; thus, none of this code is
% really run.
vecSize = getpixelposition(hSoluCheck);
if vecSize(4) <= 209
    setpixelposition(hSoluCheck, [vecSize(1:3) 209]);
end
% Get our iNargin and all the uiControls that move.
iNargin = getappdata(hSoluCheck, 'iNargin');
stBArgumentName = getappdata(hSoluCheck, 'stBArgumentName');
tbBArgument = getappdata(hSoluCheck, 'tbBArgument');
pmBDataType = getappdata(hSoluCheck, 'pmBDataType');
tbBStepSize = getappdata(hSoluCheck, 'tbBStepSize');
stBDivider = getappdata(hSoluCheck, 'stBDivider');
% get the new position, and set the new size:
vecPosition = getpixelposition(hObject);
vecNewSize = vecPosition(3:4);
% get the difference: we DO NOT view x coordinate changes!
vecDifference = [0, (vecNewSize(2)-vecOldSize(2)), 0, 0];
% get the names of our handles, and add the objProgressBar to it!
cellNames = fieldnames(handles)';
cellNames = [cellNames, {'objProgressBar'}];
cellFields = {stBArgumentName, tbBArgument, pmBDataType, tbBStepSize, stBDivider};
cellReserved = {'pbBAdvancedOptions', 'pbBHelp', 'cbBMute', 'output', 'uiBSoluCheck', ...
    'objProgressBar', 'stBTestResults', 'cxBAudit'};
% for each of the names, if it is NOT one of the reserved tags, move it
% accordingly
for i = 1:length(cellNames)
    if ~any(strcmp(cellNames{i}, cellReserved))
        k = findobj('Tag', cellNames{i});
        setpixelposition(k, getpixelposition(k) + vecDifference);
    end
end
% for each field, set the pixel position IF WE ARE NOT ON THE FIRST TIME
if ~bFirstTime
    for i = 1:length(cellFields)
        for j = 1:iNargin
            k = cellFields{i}{j};
            setpixelposition(k, getpixelposition(k) + vecDifference);
        end
    end
end
stBViewingPane = findobj('Tag', 'stBTestResults');
vecPosn = getpixelposition(stBViewingPane);
if all(vecPosn + [0 0 0 vecDifference(2)] > 0)
    setpixelposition(stBViewingPane, vecPosn + [0 0 0 vecDifference(2)]);
end
% get the slider position; this is for resizing the scroller
vecSliderPosn = getpixelposition(handles.slBYScroller);
vecTopPosn = getpixelposition(handles.stBTop);
vecNewPosn = [vecSliderPosn(1), 0, vecSliderPosn(3), vecTopPosn(2)];
% find the change needed for the slider;
    setpixelposition(handles.slBYScroller, vecNewPosn);
vecTestButtonPosn = getpixelposition(handles.pbBTest);
% if the test button is ABOVE the y = 0 line, then make it invisible.
% Otherwise, show it!
if vecTestButtonPosn(2) >= 0
    set(handles.slBYScroller, 'Visible', 'off');
    if (get(handles.slBYScroller, 'Value') ~= get(handles.slBYScroller, 'Max')) && ~bFirstTime
        % Code that moves everything back up. We know the value of max, and
        % we know the value. so, we should act like we are moving
        % everything back up, right? To do this, we should move everything
        % by the value of our scroller, right?
        intDifference = get(handles.slBYScroller, 'Value') - get(handles.slBYScroller, 'Max');
        for i = 1:length(cellFields)
            for j = 1:iNargin
                k = cellFields{i}{j};
                setpixelposition(k, getpixelposition(k) + [0 intDifference 0 0]);
                k.Visible = 'on';
            end
        end
        handles.slBYScroller.Value = handles.slBYScroller.Max;
        setpixelposition(handles.pbBTest, getpixelposition(handles.pbBTest) + [0 intDifference 0 0]);
        setpixelposition(handles.pbBCancel, getpixelposition(handles.pbBCancel) + [0 intDifference 0 0]);
    end
else
    intScrollerValue = abs(vecTestButtonPosn(2));
    setappdata(hSoluCheck, 'intScrollerValue', intScrollerValue);
    set(handles.slBYScroller, 'Visible', 'on', 'Max', abs(vecTestButtonPosn(2)), 'Value', abs(vecTestButtonPosn(2)));
end

% 
% if vecTestButtonPosn(2) >= 0
%     set(handles.slBYScroller, 'Max', 1.0, 'Min', 1.0, 'Value', 0.0);
% else
%     set(handles.slBYScroller, 'Min', 0.00, 'Max', abs(vecTestButtonPosn(2)), 'Value', abs(vecTestButtonPosn(2)));
%     intScrollerValue = abs(vecTestButtonPosn(2));
% end
% reload our old size to reflect the new old size!
vecOldSize = vecNewSize;
setappdata(findobj('Tag', 'uiBSoluCheck'), 'vecOldSize', vecOldSize);

% --- Executes on slider movement.
function slBYScroller_Callback(hObject, eventdata, handles)
% hObject    handle to slBYScroller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get starting values
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
iNargin = getappdata(hSoluCheck, 'iNargin');
intScrollerValue = getappdata(hSoluCheck, 'intScrollerValue');
stBArgumentName = getappdata(hSoluCheck, 'stBArgumentName');
tbBArgument = getappdata(hSoluCheck, 'tbBArgument');
pmBDataType = getappdata(hSoluCheck, 'pmBDataType');
tbBStepSize = getappdata(hSoluCheck, 'tbBStepSize');
stBDivider = getappdata(hSoluCheck, 'stBDivider');
bFirstTime = getappdata(findobj('Tag', 'uiBSoluCheck'), 'bFirstTime');
if isempty(intScrollerValue)
    intScrollerValue = get(hObject, 'Max');
end
% define the top of our slider:
intTop = getpixelposition(handles.stBTop);
celNames = {stBArgumentName, tbBArgument, pmBDataType, tbBStepSize, stBDivider};
intDifference = -(get(hObject, 'Value') - intScrollerValue);
% if this is NOT our first time, reload the uiControls!
if ~bFirstTime
    for i = 1:length(celNames)
        for j = 1:iNargin
            k = celNames{i}{j};
            setpixelposition(k, getpixelposition(k) + [0 intDifference 0 0]);
            intPosn = getpixelposition(k);
            if intPosn(2) + intPosn(4) >= intTop(2)
                set(k, 'Visible', 'off');
            else
                set(k, 'Visible', 'on');
            end
        end
    end
setpixelposition(handles.pbBTest, getpixelposition(handles.pbBTest) + [0 intDifference 0 0]);
setpixelposition(handles.pbBCancel, getpixelposition(handles.pbBCancel) + [0 intDifference 0 0]);
end

intScrollerValue = get(hObject, 'Value');
setappdata(hSoluCheck, 'intScrollerValue', intScrollerValue);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slBYScroller_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slBYScroller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on scroll wheel click while the figure is in focus.
function uiBSoluCheck_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to uiBSoluCheck (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)

% basically, load the uicontrols just like in the scroller function!
bFirstTime = getappdata(findobj('Tag', 'uiBSoluCheck'), 'bFirstTime');
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
iNargin = getappdata(hSoluCheck, 'iNargin');
stBArgumentName = getappdata(hSoluCheck, 'stBArgumentName');
tbBArgument = getappdata(hSoluCheck, 'tbBAgument');
pmBDataType = getappdata(hSoluCheck, 'pmBDataType');
tbBStepSize = getappdata(hSoluCheck, 'tbBStepSize');
stBDivider = getappdata(hSoluCheck, 'stBDivider');
vecFirstPosn = getappdata(hSoluCheck, 'vecFirstPosn');
if isempty(vecFirstPosn)
    vecFirstPosn = getpixelposition(handles.pbBTest);
    setappdata(hSoluCheck, 'vecFirstPosn', vecFirstPosn);
end
vecChange = [0 ((eventdata.VerticalScrollCount ./ abs(eventdata.VerticalScrollCount) .* eventdata.VerticalScrollAmount)) 0 0];

vecPosn = getpixelposition(handles.pbBTest);

if (vecPosn(2) + vecChange(2) <= vecFirstPosn(2)) && (vecChange(2) < 0)
    return
end

if vecPosn(2) + vecChange(2) >= 0
    vecChange = [0 vecPosn(2) 0 0];
end
celFields = {stBArgumentName, tbBArgument, pmBDataType, tbBStepSize, stBDivider};

if ~bFirstTime && vecPosn(2) < 0
    %Don't scroll if the y posn is not less than 0!!
    %Also, if we WOULD scroll past the end, we need to just go to the end;
    %not pass it!!!!
    % We need to find the distance to the end (pbBTest = 0), then apply
    % this to the given formula
    for i = 1:length(celFields)
        for j = 1:iNargin
            k = celFields{i}{j};
            setpixelposition(k, getpixelposition(k) + vecChange);
            vecKPosition = getpixelposition(k);
            vecTopPosition = getpixelposition(handles.stBTop);
            if vecKPosition(2) + vecKPosition(4) >= vecTopPosition(2)
                set(k, 'Visible', 'off');
            else
                set(k, 'Visible', 'on');
            end
        end
    end
    setpixelposition(handles.pbBTest, getpixelposition(handles.pbBTest) + vecChange);
    setpixelposition(handles.pbBCancel, getpixelposition(handles.pbBCancel) + vecChange);
    vecPosn = getpixelposition(handles.pbBTest);
    intScrollerValue = get(handles.slBYScroller, 'Value');
    set(handles.slBYScroller, 'Value', abs(vecPosn(2)));
    setappdata(hSoluCheck, 'intScrollerValue', intScrollerValue);
end

% --- Executes on button press in cbBMute.
function cbBMute_Callback(hObject, eventdata, handles)
% hObject    handle to cbBMute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbBMute
% this is vestigial; eventually, it will be replaced exclusively by the
% uimenu option!

function uiBSoluCheckMenuSaveOutputs_Callback(hObject, eventdata, handles)
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
% save our ouputs from the LAST run!
if isappdata(hSoluCheck, 'cFinalArgs')
    cellFinalArgs = getappdata(hSoluCheck, 'cFinalArgs'); %#ok<NASGU>
    cellFinalCode = getappdata(hSoluCheck, 'cAnswers'); %#ok<NASGU>
    cellFinalSoln = getappdata(hSoluCheck, 'cSolutions'); %#ok<NASGU>
    vecCodeTime = getappdata(hSoluCheck, 'vecTime1'); %#ok<NASGU>
    vecSolnTime = getappdata(hSoluCheck, 'vecTime2'); %#ok<NASGU>
    intIterationNumber = getappdata(hSoluCheck, 'intIterationNumber'); %#ok<NASGU>
    uisave({'cellFinalArgs', 'cellFinalCode', 'cellFinalSoln', 'vecCodeTime', ...
            'vecSolnTime', 'intIterationNumber'}, 'Save SoluCheck Outputs:');
end

function uiBSoluCheckMenuSaveDetails_Callback(hObject, eventdata, handles)
% save our details screen, as it is shown at the moment this function is
% called!
hViewer = findobj('Tag', 'uiVViewer');
hViewer = hViewer.Children(3);
strOld = hViewer.String;
[intLines, ~] = size(strOld);
cellDetails = cell(1, intLines);
for i = 1:intLines
    cellDetails{i} = strOld(i, :);
end
[strFileName, strFilePath] = uiputfile('LogDetails.txt', 'Save Log As:');
if strFileName ~= 0
    fstFileName = [strFilePath, strFileName];
    fidDetails = fopen(fstFileName, 'w');
    for i = 1:intLines
        fprintf(fidDetails, '%s', cellDetails{i});
    end
    fclose(fidDetails);
end

function uiBSoluCheckMenuPrep_Callback(hObject, eventdata, ~)
    [~, strPath] = readySubmit();
    dos(['explorer ' strPath]);
    
function uiBMenuMute_Callback(hObject, eventdata, ~)
% eventually, changing the check box for mute will NOT be needed!
handles = guidata(findobj('Tag', 'uiBSoluCheck'));
if strcmp(hObject.Checked, 'on')
    handles.cbBMute.Value = false;
    hObject.Checked = 'off';
else
    handles.cbBMute.Value = true;
    hObject.Checked = 'on';
end


function uiBSoluCheckMenuQuit_Callback(hObject, eventdata, handles)
% quit SoluCheck!
close(findobj('Tag', 'uiBSoluCheck'));

function uiBDocumentation_Callback(hObject, eventdata, handles)
% open the documentation
winopen('SoluCheckDocumentation.pdf');

function uiBSoluCheckMenuUninstall_Callback(hObject, eventdata, handles)
% prompt the user for confirmation, then if yes, uninstall SoluCheck!
hUserPrompt = dialog('Name', 'SoluCheck Uninstallation:', 'Position', [100 100 250 125], 'Tag', 'uiUUninstallSoluCheck');
stUExplain = uicontrol(hUserPrompt, 'Style', 'text', 'String', sprintf('Are you sure you would like to Uninstall SoluCheck? This cannot be undone!'), ...
    'Tag', 'stUExplain', 'HorizontalAlignment', 'center', 'FontSize', 10.0);
setpixelposition(stUExplain, [0 0 250 100]);
pbUYes = uicontrol(hUserPrompt, 'Style', 'pushbutton', 'String', 'Yes', 'Callback', @pbUYes_Callback, 'KeyPressFcn', @pbUYes_Callback, ...
    'Tag', 'pbUYes', 'FontSize', 10.0);
pbUNo = uicontrol(hUserPrompt, 'Style', 'pushbutton', 'String', 'No', 'Callback', @pbUNo_Callback, 'KeyPressFcn', @pbUNo_Callback, ...
    'Tag', 'pbUNo', 'FontSize', 10.0);
setpixelposition(pbUNo, [15 15 100 25]);
setpixelposition(pbUYes, [130 15 100 25]);

function pbUNo_Callback(hObject, eventdata, handles)
if strcmp(class(eventdata), 'matlab.ui.eventdata.UIClientComponentKeyEvent') %#ok<STISA>
    if ~any(strcmp(eventdata.Key, {'return', 'space'}))
        return
    end
end
hUserPrompt = findobj('Tag', 'uiUUninstallSoluCheck');
delete(hUserPrompt);


function pbUYes_Callback(hObject, eventdata, handles)
if strcmp(class(eventdata), 'matlab.ui.eventdata.UIClientComponentKeyEvent') %#ok<STISA>
    if ~any(strcmp(eventdata.Key, {'return', 'space'}))
        return
    end
end
fprintf('Uninstalling SoluCheck...');
stcApps = matlab.apputil.getInstalledAppInfo;
for i = stcApps
    if strcmp(i.name, 'SoluCheck')
        strID = i.id;
        break
    end
end
if ~isempty(strID)
    matlab.apputil.uninstall(strID);
end
fprintf(' SoluCheck has successfully uninstalled.\n');
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
hUserPrompt = findobj('Tag', 'uiUUninstallSoluCheck');
delete(hUserPrompt);
delete(hSoluCheck);

function uiBSoluCheckMenuInstallEngine_Callback(hObject, eventdata, handles)
[strPath] = uigetdir('C:\Uers', 'Place SoluCheckEngine');
if ~all(strPath == 0) && numel(strPath) ~= 1
    strOldDir = cd(strPath);
    addpath(strOldDir);
    pcode SoluCheckEngine.m;
    cd(strOldDir);
end

function uiBSoluCheckMenuPref_Callback(hObject, eventdata, handles)
userPrefs();

% --- Executes on button press in pbBHelp.
function pbBHelp_Callback(hObject, eventdata, handles)
% hObject    handle to pbBHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% show our help menu; basically join our string into one long line,
% separated by \n.
fihHelp = findobj('Tag', 'uiHHelp');
if ~isempty(fihHelp)
    figure(fihHelp);
    return;
end
fihHelp = figure('Visible', 'off', 'Name', 'SoluCheck: Help', 'Resize', 'off', ...
    'NumberTitle', 'off', 'position', [350 50 475 400], 'Tag', 'uiHHelp', ...
    'menubar', 'none', 'toolbar', 'none');
tbHHelp = uicontrol('Style', 'edit', 'Enable', 'inactive', 'Tag', 'tbHHelp', 'Max', 100, 'Min', 0, 'FontSize', 10.0, 'HorizontalAlignment', 'left');
vecPosn = getpixelposition(fihHelp);
vecPosn = [0 50 vecPosn(3) vecPosn(4) - 50];
setpixelposition(tbHHelp, vecPosn);
cellHelp = {'Hi, welcome to the SoluCheck in-app Documentation!', ...
            'Here you will find answers to most common questions. When in doubt,',...
            'refer to the standalone documentation that came with SoluCheck.', ...
            '', ...
            'I. How do I get started?', ...
            '    First select a file to test using the ''Browse...'' button,', ...
            'Then, the solution file path will be autofilled, and you can now fill', ...
            'in your values. Fill in a value, then select the data type, then ', ...
            'select a step size. Please be advised that cell arrays and structures', ...
            'can NOT be stepped at this time. Then, hit the test button.'...
            '', ...
            'II. What are Advanced Options?', ...
            '    Advanced Options give you much greater control over how SoluCheck', ...
            'attempts to test your code. For example, using Advanced Options, one', ...
            'can step array sizes, view details of multiple runs, set up notifications,', ...
            'Or load database tests. This is not a comprehensive list, but to use', ...
            'Advanced Options, look at the standalone Documentation or run the', ...
            'Help command on AdvancedOptions.', ...
            '', ...
            'III. How do I report possible bugs?', ...
            '    To report a bug, simply write an email to SoluCheck@gmail.com,', ...
            'and explain exactly what caused SoluCheck to crash. If you received', ...
            'an error message, please include that and any other media', ...
            'that you deem helpful. Please send bug reports! We can only', ...
            'solve a problem if we know it exists!', ...
            '', ...
            'Thanks for reading, and have fun!', ...
            'The SoluCheck Team'  };
strHelp = strjoin(cellHelp, '\n');
tbHHelp.String = strHelp;
pbHDocumentation = uicontrol('Style', 'pushbutton', 'FontSize', 10.0, 'String', 'Open Documentation...', 'Callback', @pbHDocumentation_Callback, 'HorizontalAlignment', 'center');
setpixelposition(pbHDocumentation, [0 0 vecPosn(3) 50]);
fihHelp.Visible = 'on';

function pbHDocumentation_Callback(hObject, eventdata, handles)
% Basically, it should open the documentation as shown above:
winopen('SoluCheckDocumentation.pdf');

% --- Executes when user attempts to close uiBSoluCheck.
function uiBSoluCheck_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to uiBSoluCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
fprintf('Closing SoluCheck, Please Wait...');

% get the original directory:
strOldDir = getappdata(findobj('Tag', 'uiBSoluCheck'), 'strOldDir');

% a cell array of all possible figure tags:
cellFigures = {'uiAAdvancedOptions', 'uiFViewArguments', 'uiPPlots', 'uiEExempt',...
    'uiDLoadDatabase', 'uiLLoadVariables', 'uiNNotifications', 'uiRMaxMin', ...
    'uiSArrSize', 'uiVViewer', 'uiHHelp', 'uiWWorkSpace', 'uiPParameters', ...
    'uiRPrefs'};
% if we can find the figure, delete it!
for i = 1:numel(cellFigures)
    if ~isempty(findobj('Tag', cellFigures{i}))
        delete(findobj('Tag', cellFigures{i}));
    end
end
cd(strOldDir);
delete(hObject);
fprintf(' SoluCheck has successfully closed.\n');

% --- Executes on button press in cxBAudit.
function cxBAudit_Callback(hObject, eventdata, handles)
% hObject    handle to cxBAudit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('tag', 'uiBSoluCheck'), 'stcSwitches');
stcSwitches.Auditing = get(hObject, 'Value');
setappdata(findobj('tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);
% Hint: get(hObject,'Value') returns toggle state of cxBAudit


% --- Executes on key press with focus on uiBSoluCheck and none of its controls.
function uiBSoluCheck_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uiBSoluCheck (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% basically, do NOT allow a button press to go back to the command prompt!
