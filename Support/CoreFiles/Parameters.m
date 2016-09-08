function varargout = Parameters(varargin)
% PARAMETERS MATLAB code for Parameters.fig
%      PARAMETERS, by itself, creates a new PARAMETERS or raises the existing
%      singleton*.
%
%      H = PARAMETERS returns the handle to a new PARAMETERS or the handle to
%      the existing singleton*.
%
%      PARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMETERS.M with the given input arguments.
%
%      PARAMETERS('Property','Value',...) creates a new PARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Parameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Parameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Parameters

% Last Modified by GUIDE v2.5 06-Mar-2016 10:25:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Parameters_OpeningFcn, ...
                   'gui_OutputFcn',  @Parameters_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before Parameters is made visible.
function Parameters_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<VANUS>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Parameters (see VARARGIN)

% Choose default command line output for Parameters
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

hSoluCheck = findobj('Tag', 'uiBSoluCheck');
stcSwitches = getappdata(hSoluCheck, 'stcSwitches');
if stcSwitches.VariableIn
    iNargin = getappdata(hSoluCheck, 'iNargin');
    handles.tbPVariableInputs.String = num2str(iNargin);
    handles.cbPVariableInputs.Value = true;
else
    handles.tbPVariableInputs.String = '';
    handles.cbPVariableInputs.Value = false;
end

if stcSwitches.VariableOut
    handles.cbPVariableOutputs.Value = true;
   % Whenever we figure out how to do this, we will put the code here:
   vecOut = getappdata(hSoluCheck, 'vecOut');
   vecOut = cellfun(@num2str, num2cell(vecOut), 'uni', false);
   handles.tbPOutputs.String = strjoin(vecOut, ', ');
   handles.tbPOutputs.Enable = 'on';
else
    handles.cbPVariableOutputs.Value = false;
    % Whenever we figure this out~!
    handles.tbPOutputs.Enable = 'off';
end
% UIWAIT makes Parameters wait for user response (see UIRESUME)
% uiwait(handles.uiPParameters);


% --- Outputs from this function are returned to the command line.
function varargout = Parameters_OutputFcn(hObject, eventdata, handles)  %#ok<*INUSL>
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbPCancel.
function pbPCancel_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
% hObject    handle to pbPCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
stcSwitches.VariableIn = false;
stcSwitches.VariableOut = false;
setappdata(hSoluCheck, 'stcSwitches', stcSwitches);
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
    setpixelposition(findobj('Tag', 'pbBTest'), getpixelposition(findobj('Tag', 'pbBTest')) + [0, (33 .* i), 0, 0]);
    setpixelposition(findobj('Tag', 'pbBCancel'), getpixelposition(findobj('Tag', 'pbBCancel')) + [0, (33 .* i), 0, 0]);
    setappdata(hSoluCheck, 'stBArgumentName', stBArgumentName);
    setappdata(hSoluCheck, 'tbBArgument', tbBArgument);
    setappdata(hSoluCheck, 'pmBDataType', pmBDataType);
    setappdata(hSoluCheck, 'tbBStepSize', tbBStepSize);
    setappdata(hSoluCheck, 'stBDivider', stBDivider);
end
set(findobj('Tag', 'stBTestResults'), 'String', 'Test Results', 'Background', [0.94 0.94 0.94]);
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
    cellViewer{1} = '>> Setting Custom Inputs...Aborted!';
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end
close;

% --- Executes on button press in pbPConfirm.
function pbPConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to pbPConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
stcSwitches = getappdata(hSoluCheck, 'stcSwitches');
if handles.cbPVariableInputs.Value
    iNargin = str2double(handles.tbPVariableInputs.String);
    bFirstTime = getappdata(hSoluCheck, 'bFirstTime');
    if iNargin == Inf || iNargin < 0 || any(~isnumeric(iNargin)) || any(isnan(iNargin))
        msgbox('Please enter a valid amount of arguments!', 'Variable Inputs: SoluCheck')
    else
        setappdata(hSoluCheck, 'iNargin', iNargin);
        if ~bFirstTime
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
                setpixelposition(findobj('Tag', 'pbBTest'), getpixelposition(findobj('Tag', 'pbBTest')) + [0, (33 .* i), 0, 0]);
                setpixelposition(findobj('Tag', 'pbBCancel'), getpixelposition(findobj('Tag', 'pbBCancel')) + [0, (33 .* i), 0, 0]);
            end
        end
        % tells SoluCheck this is not first time any more!
        bFirstTime = false;
        % update the UI with complete information:
        setappdata(hSoluCheck, 'bFirstTime', bFirstTime);
        % Create starting cell arrays:
        stBArgumentName = cell(1, iNargin);
        tbBArgument = cell(1, iNargin);
        pmBDataType = cell(1, iNargin);
        tbBStepSize = cell(1, iNargin);
        stBDivider = cell(1, iNargin);
        % Create the UI Controls:
        for i = 0:iNargin-1
            %Set the handles for arg names
            stBArgumentName{i+1} = uicontrol(hSoluCheck, 'Tag', ['stBArgumentName' num2str(i+1)], 'Style', 'text', 'String', sprintf('Argument %d:', i+1), 'FontSize', 10.0);
            setpixelposition(stBArgumentName{i+1}, getpixelposition(findobj('Tag','stBArgumentNameExample')) + [0, (-33 .* i), 0, 0]);
            %Set handles for arguments
            tbBArgument{i+1} = uicontrol(hSoluCheck, 'Tag', ['tbBArgument' num2str(i+1)], 'Style', 'edit', 'HorizontalAlignment', 'left', 'FontSize', 10.0, 'String', '', ...
                'ButtonDownFcn', @tbBArgumentExample_ButtonDownFcn, 'KeyPressFcn', @tbBArgument_KeyPressFcn);
            setpixelposition(tbBArgument{i+1}, getpixelposition(findobj('Tag', 'tbBArgumentExample')) + [0, (-33 .* i), 0, 0]);
            %Set handles for data types
            pmBDataType{i+1} = uicontrol(hSoluCheck, 'Tag', ['pmBDataType' num2str(i+1)], 'Style', 'popupmenu', 'String', {'Select A Data Type:', 'Predefined Variable...', 'String', 'Number', 'Array',...
                'Cell Array','Logical', 'Formulaic...'}, 'FontSize', 10.0, 'Callback', @pmBData_Callback, 'Value', 1);
            setpixelposition(pmBDataType{i+1}, getpixelposition(findobj('Tag', 'pmBDataTypeExample')) + [0, (-33 .* i), 0, 0]);     
            %Set handles for the step sizes
            tbBStepSize{i+1} = uicontrol(hSoluCheck, 'Tag', ['tbBStepSize' num2str(i+1)], 'Style', 'edit', 'String', '1', 'HorizontalAlignment', 'left', 'FontSize', 10.0, ...
                'String', '1', 'KeyPressFcn', @tbBStepSize_KeyPressFcn);
            setpixelposition(tbBStepSize{i+1}, getpixelposition(findobj('Tag', 'tbBStepExample')) + [0, (-33 .* i), 0, 0]);
            %Set handles for the dividers
            stBDivider{i+1} = uicontrol(hSoluCheck, 'Tag', ['stBDivider' num2str(i+1)], 'Style', 'text', 'HorizontalAlignment', 'left', 'string', get(findobj('Tag', 'stBDividerExample'), 'string'), 'FontSize', 4);
            setpixelposition(stBDivider{i+1}, getpixelposition(findobj('Tag', 'stBDividerExample')) + [0, (-33.*i), 0, 0]);
            %Move the two buttons
            setpixelposition(findobj('Tag', 'pbBTest'), getpixelposition(findobj('Tag', 'pbBTest')) + [0, -33, 0, 0]);
            setpixelposition(findobj('Tag', 'pbBCancel'), getpixelposition(findobj('Tag', 'pbBCancel')) + [0, -33, 0, 0]);
            %adjust the tab order
            uistack(findobj('Tag', 'pbBAdvancedOptions'), 'bottom');
            uistack(findobj('Tag', 'pbBTest'), 'bottom');
            uistack(findobj('Tag', 'pbBCancel'), 'bottom');
        end
        setappdata(hSoluCheck, 'stBArgumentName', stBArgumentName);
        setappdata(hSoluCheck, 'tbBArgument', tbBArgument);
        setappdata(hSoluCheck, 'pmBDataType', pmBDataType);
        setappdata(hSoluCheck, 'tbBStepSize', tbBStepSize);
        setappdata(hSoluCheck, 'stBDivider', stBDivider);
        stcSwitches.VariableIn = true;
        setappdata(hSoluCheck, 'stcSwitches', stcSwitches);
        % Tell the user that SoluCheck has been prepped and is awaiting
        % User Orders:
        stcSounds = getappdata(hSoluCheck, 'stcSounds');
        strResult = sprintf('>> Setting Custom Inputs...%d Loaded!', iNargin);
        set(findobj('Tag', 'stBTestResults'), 'String', 'You''ve selected a valid file; now click Test to continue, or Advanced Options to customize your test.', 'ForegroundColor', 'black', 'BackgroundColor', 'white');
        hcbBMute = findobj('Tag', 'cbBMute');
        if ~hcbBMute.Value
            sound(stcSounds(1).Start{:});
        end
        cellFormulaic = cell(1, iNargin);
        setappdata(hSoluCheck, 'cellFormulaic', cellFormulaic);
        % Get the position of the testing button, so that we can determine how
        % our scroller should respond:
        vecPosn = getpixelposition(findobj('Tag', 'pbBTest'));
        vecPosn = vecPosn(2);
        if vecPosn < 0
            set(findobj('Tag', 'slBYScroller'), 'Min', 0.00, 'Max', abs(vecPosn), 'Value', abs(vecPosn), 'Visible', 'on');
        else
            set(findobj('Tag', 'slBYScroller'), 'Min', 1.0, 'Max', 1.0, 'Value', 0);
        end
        intScrollerValue = abs(vecPosn);
        setappdata(hSoluCheck, 'intScrollerValue', intScrollerValue);
        vecFirstPosn = getpixelposition(findobj('Tag', 'pbBTest'));
        setappdata(hSoluCheck, 'vecFirstPosn', vecFirstPosn);
    end
else
    strResult = '>> Setting Custom Inputs...Aborted!';
end
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
if handles.cbPVariableOutputs.Value
    strFunc = getappdata(hSoluCheck, 'sFileName');
    intArgOut = nargout(strFunc);
    hOutArgs = findobj('Tag', 'tbPOutputs');
    vecOut = str2num(['[' hOutArgs.String ']']); %#ok<ST2NM>
    badInd = (vecOut < 1) | (vecOut > intArgOut);
    if any(badInd)
        vecOut = cellfun(@num2str, num2cell(find(badInd)), 'uni', false);
        strResult = sprintf('>> Setting Custom Outputs...Aborted due to a bad index at indi(ces) %s!', strjoin(vecOut, ', '));
        setappdata(hSoluCheck, 'vecOut', []);
        stcSwitches.VariableOut = false;
    else
        setappdata(hSoluCheck, 'vecOut', vecOut);
        strResult = '>> Setting Custom Outputs...Done!';
        stcSwitches.VariableOut = true;
    end
else
    strResult = '>> Setting Custom Outputs...Aborted!';
    stcSwitches.VariableOut = false;
end
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
setappdata(hSoluCheck, 'stcSwitches', stcSwitches);
close;

function tbBArgument_KeyPressFcn(~, eventdata, ~)
pbBTest_Callback = getappdata(findobj('Tag', 'uiBSoluCheck'), 'fhpbBTest_Callback');
handles = guidata(findobj('Tag', 'uiBSoluCheck'));
if strcmp('return', eventdata.Key) && strcmp(handles.pbBTest.Enable, 'on')
    pbBTest_Callback(handles.pbBTest, [], handles);
end

function tbBStepSize_KeyPressFcn(~, eventdata, ~)
pbBTest_Callback = getappdata(findobj('Tag', 'uiBSoluCheck'));
handles = guidata(findobj('Tag', 'uiBSoluCheck'));
if strcmp('return', eventdata.Key) && strcmp(handles.pbBTest.Enable, 'on')
    pbBTest_Callback(handles.pbBTest, [], handles);
end

function tbBArgumentExample_ButtonDownFcn(hObject, eventdata, handles)
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
tbBArgument = getappdata(hSoluCheck, 'tbBArgument');
pmBDataType = getappdata(hSoluCheck, 'pmBDataType');
strName = hObject.Tag;
intArgument = str2double(strName(12:end));
if ~strcmp(hObject.Enable, 'on')
    if pmBDataType{intArgument}.Value == 8
        cellFormulaic = getappdata(findobj('Tag', 'uiBSoluCheck'), 'cellFormulaic'); 
        uiCCommandWindow = figure('Visible', 'off', 'Name', ['SoluCheck: Formulaic Entry #', strName(12:end)] , 'NumberTitle', 'off', 'position', [350 50 500 550], 'Tag', 'uiCCommandWindow');
        tbCCommandLine = uicontrol('Style', 'edit', 'position', [0, 50, 500, 500], 'HorizontalAlignment', 'left', 'Max', 100, 'Min', 0, 'Units', 'Normalized', 'String', '>> ', 'FontSize', 10.0, 'ToolTip', sprintf(['Please enter your code in the following field as it would be entered into the command line.\n**Assign the desired argument value to the out variable!\n'... 
                        'Note that you may utilize the current iteration by calling the variable intIterationNumber']));
        pbCConfirm = uicontrol('Style', 'pushbutton', 'string', 'Confirm', 'position', [250, 0, 250, 50], 'Callback', {@pbCConfirm_Callback, hObject.Tag}, 'Units', 'Normalized'); %#ok<NASGU>
        pbCCancel = uicontrol('Style', 'pushbutton', 'String', 'Cancel', 'position', [0, 0, 250, 50], 'Callback', {@pbCEditCancel_Callback, hObject.Tag}, 'Units', 'Normalized'); %#ok<NASGU>
        uiCCommandWindow.Visible = 'on';
        cellFormulaic{intArgument}{1} = ['>> ' cellFormulaic{intArgument}{1}];
        tbCCommandLine.String = strjoin(cellFormulaic{intArgument}, '\n');
        setappdata(hSoluCheck, 'tbCCommandLine', tbCCommandLine);
    elseif pmBDataType{intArgument}.Value == 2
        cellVariables = evalin('base', 'who');
        uiWWorkSpace = figure('Visible', 'off', 'Name', ['SoluCheck: WorkSpace Variable #', strName(12:end)], 'NumberTitle', 'off', 'position', [350 50 500 450], 'Tag', 'uiWWorkSpace', 'Units', 'Normalized');
        lbWVariables = uicontrol('Style', 'listbox', 'Tag', 'lbWVariables', 'String', cellVariables, 'FontSize', 10.0, 'Callback', {@lbWVariables_Callback, hObject.Tag});
        vecPosn = getpixelposition(uiWWorkSpace);
        vecPosn(1:2) = 0;
        setpixelposition(lbWVariables, vecPosn);
        uiWWorkSpace.Visible = 'on';
        set(tbBArgument{intArgument}, 'Enable', 'off');
    end
end

function pbCEditCancel_Callback(hObject, callbackdata, strName)
close;
function pmBData_Callback(hObject, ~)
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
hpbBTest = findobj('Tag', 'pbBTest');
tbBArgument = getappdata(hSoluCheck, 'tbBArgument');
pmBDataType = getappdata(hSoluCheck, 'pmBDataType');
tbBStepSize = getappdata(hSoluCheck, 'tbBStepSize');
strName = hObject.Tag;
intName = str2double(strName(12:end));
iNargin = getappdata(hSoluCheck, 'iNargin');
if hObject.Value == 8
    uiCCommandWindow = figure('Visible', 'off', 'Name', ['SoluCheck: Formulaic Entry #', strName(12:end)], 'NumberTitle', 'off', 'position', [350 50 500 550], 'Tag', 'uiCCommandWindow');
    tbCCommandLine = uicontrol('Style', 'edit', 'position', [0, 50, 500, 500], 'HorizontalAlignment', 'left', 'Max', 100, 'Min', 0, 'Units', 'Normalized', 'String', '>> ', 'FontSize', 10.0, 'ToolTip',...
        sprintf(['Please enter your code in the following field as it would be entered into the command line.\n**Assign the desired argument value to the out variable!\n'... 
                        'Note that you may utilize the current iteration by calling the variable intIterationNumber.']));
    pbCConfirm = uicontrol('Style', 'pushbutton', 'string', 'Confirm', 'position', [250, 0, 250, 50], 'Callback', {@pbCConfirm_Callback, hObject.Tag}, 'Units', 'Normalized'); %#ok<NASGU>
    pbCCancel = uicontrol('Style', 'pushbutton', 'String', 'Cancel', 'position', [0, 0, 250, 50], 'Callback', {@pbCCancel_Callback, hObject.Tag}, 'Units', 'Normalized'); %#ok<NASGU>
    uiCCommandWindow.Visible = 'on';
    set(tbBArgument{intName}, 'Enable', 'inactive');
    setappdata(hSoluCheck, 'tbCCommandLine', tbCCommandLine);
elseif hObject.Value == 2
    cellVariables = evalin('base', 'who');
    uiWWorkSpace = figure('Visible', 'off', 'Name', ['SoluCheck: WorkSpace Variable #', strName(12:end)], 'NumberTitle', 'off', 'position', [350 50 500 450], 'Tag', 'uiWWorkSpace', 'Units', 'Normalized');
    lbWVariables = uicontrol('Style', 'listbox', 'Tag', 'lbWVariables', 'String', cellVariables, 'FontSize', 10.0, 'Callback', {@lbWVariables_Callback, hObject.Tag});
    vecPosn = getpixelposition(uiWWorkSpace);
    vecPosn(1:2) = 0;
    setpixelposition(lbWVariables, vecPosn);
    uiWWorkSpace.Visible = 'on';
    set(tbBArgument{intName}, 'Enable', 'off');
else
    set(tbBArgument{intName}, 'Enable', 'on');
end

switch hObject.Value
    case {1, 2, 6, 8}
        set(tbBStepSize{intName}, 'Enable', 'off', 'string', '')
    case {3, 4, 5, 7}
        set(tbBStepSize{intName}, 'Enable', 'on');
end
set(hpbBTest, 'Enable', 'on');
for i = 1:iNargin
    intChoice = pmBDataType{i}.Value;
    if intChoice == 1
        set(hpbBTest, 'Enable', 'off');
    break
    end
end

function pbCConfirm_Callback(hObject, callbackdata, strName)
tbBArgument = getappdata(findobj('Tag', 'uiBSoluCheck'), 'tbBArgument');
tbCCommandLine = getappdata(findobj('Tag', 'uiBSoluCheck'), 'tbCCommandLine');
cellFormulaic = getappdata(findobj('Tag', 'uiBSoluCheck'), 'cellFormulaic');
strCode = tbCCommandLine.String;
[strFirst, strSecond] = strtok(strCode(1, :), '> ');
[intLines, ~] = size(strCode);
cellCode = cell(1, intLines);
cellCode{1} = [strFirst strSecond];
for i = 2:intLines
    cellCode{i} = strCode(i, :);
end
intArgument = str2double(strName(12:end));
cellFormulaic{intArgument} = cellCode;
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
close;

function pbCCancel_Callback(hObject, callbackdata, strName)
pmBDataType = getappdata(findobj('Tag', 'uiBSoluCheck'), 'pmBDataType');
hPopMenu = pmBDataType{str2double(strName(12:end))};
hPopMenu.Value = 1;
close;

function lbWVariables_Callback(hObject, callbackdata, strName)
tbBArgument = getappdata(findobj('Tag', 'uiBSoluCheck'), 'tbBArgument');
intChoice = hObject.Value;
cellChoices = hObject.String;
tbBArgument{str2double(strName(12:end))}.String = cellChoices{intChoice};
setappdata(findobj('Tag', 'uiBSoluCheck'), 'tbBArgument', tbBArgument);
close;

function tbPVariableInputs_Callback(hObject, eventdata, handles)
% hObject    handle to tbPVariableInputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbPVariableInputs as text
%        str2double(get(hObject,'String')) returns contents of tbPVariableInputs as a double


% --- Executes during object creation, after setting all properties.
function tbPVariableInputs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbPVariableInputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbPVariableInputs.
function cbPVariableInputs_Callback(hObject, eventdata, handles)
% hObject    handle to cbPVariableInputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbPVariableInputs


% --- Executes on button press in cbPVariableOutputs.
function cbPVariableOutputs_Callback(hObject, eventdata, handles)
% hObject    handle to cbPVariableOutputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbPVariableOutputs
hOut = findobj('Tag', 'tbPOutputs');
if hObject.Value
    hOut.Enable = 'on';
else
    hOut.Enable = 'off';
end

function tbPOutputs_Callback(hObject, eventdata, handles)
% hObject    handle to tbPOutputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbPOutputs as text
%        str2double(get(hObject,'String')) returns contents of tbPOutputs as a double


% --- Executes during object creation, after setting all properties.
function tbPOutputs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbPOutputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
