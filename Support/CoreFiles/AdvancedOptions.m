function varargout = AdvancedOptions(varargin)
% ADVANCEDOPTIONS SoluCheck figure
%   Do not call AdvancedOptions, as it cannot function ouside of SoluCheck.
%   
%   For command line access, call SoluCheckEngine from the command line,
%   then enter the required information. See Documentation for more.
% See also: SoluCheck, SoluCheckEngine

% Last Modified by GUIDE v2.5 11-Nov-2015 13:46:44
%#ok<*INUSL>
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AdvancedOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @AdvancedOptions_OutputFcn, ...
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


% --- Executes just before AdvancedOptions is made visible.
function AdvancedOptions_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<VANUS>
hSoluCheck = findobj('Tag', 'uiBSoluCheck');

if isappdata(hSoluCheck, 'stcSwitches')
    stcSwitches = getappdata(hSoluCheck, 'stcSwitches');
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
                         'VariableOut', false);
end

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AdvancedOptions (see VARARGIN)

% Choose default command line output for AdvancedOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
bFirstTime = getappdata(hSoluCheck, 'bFirstTime');
if stcSwitches.Profiler
    set(handles.pbAProfiler, 'String', 'Profiler is ON');
else
    set(handles.pbAProfiler, 'String', 'Profiler is OFF');
end

if stcSwitches.Timing
    set(handles.pbATiming, 'String', 'Timing is ON');
else
    set(handles.pbATiming, 'String', 'Timing is OFF');
end

if stcSwitches.PlotTesting
    handles.pbAPlotTesting.String = 'Plot Testing is ON';
else
    handles.pbAPlotTesting.String = 'Plot Testing is OFF';
end

if stcSwitches.FileTesting
    handles.pbAFileTesting.String = 'File Testing is ON';
else
    handles.pbAFileTesting.String = 'File Testing is OFF';
end

if stcSwitches.ImageTesting
    handles.pbAImageTesting.String = 'Image Testing is ON';
else
    handles.pbAImageTesting.String = 'Image Testing is OFF';
end

if bFirstTime
    set(handles.pbAMaxMin, 'Enable', 'off');
    set(handles.pbAExempt, 'Enable', 'off');
    set(handles.pbAArrSize, 'Enable', 'off');
    set(handles.pbAArguments, 'Enable', 'off');
else
    set(handles.pbAMaxMin, 'Enable', 'on');
    set(handles.pbAExempt, 'Enable', 'on');
    set(handles.pbAArrSize, 'Enable', 'on');
    set(handles.pbAArguments, 'Enable', 'on');
end
setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);
% UIWAIT makes AdvancedOptions wait for user response (see UIRESUME)
% uiwait(handles.uiAAdvancedOptions);


% --- Outputs from this function are returned to the command line.
function varargout = AdvancedOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbAProfiler.
function pbAProfiler_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
% hObject    handle to pbAProfiler (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
if strcmp(hObject.String, 'Profiler is OFF')
    hObject.String = 'Profiler is ON';
    strResult = 'Profiler...Enabled!';
    stcSwitches.Profiler = true;
else
    hObject.String = 'Profiler is OFF';
    strResult = 'Profiler...Disabled!';
    stcSwitches.Profiler = false;
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
    cellViewer{1} = ['>> ' strResult];
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end
setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);

% --- Executes on button press in pbATiming.
function pbATiming_Callback(hObject, eventdata, handles)
% hObject    handle to pbATiming (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
if strcmp(hObject.String, 'Timing is OFF')
    stcSwitches.Timing = true;
    strResult = 'Timing...Enabled!';
    hObject.String = 'Timing is ON';
else
    stcSwitches.Timing = false;
    strResult = 'Timing...Disabled!';
    hObject.String = 'Timing is OFF';
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
    cellViewer{1} = ['>> ', strResult];
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end
setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);

% --- Executes on button press in pbALoadDatabase.
function pbALoadDatabase_Callback(hObject, eventdata, handles)
% hObject    handle to pbALoadDatabase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadDatabase;

% --- Executes on button press in pbALoadVariables.
function pbALoadVariables_Callback(hObject, eventdata, handles)
% hObject    handle to pbALoadVariables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
stcSwitches.LoadVariables = true;
LoadVariables;
setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);

% --- Executes on button press in pbAViewDetails.
function pbAViewDetails_Callback(hObject, eventdata, handles)
% hObject    handle to pbAViewDetails (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(findobj('Tag', 'uiVViewer'))
    stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
    uiVViewer = figure('Name', 'SoluCheck Viewer', 'MenuBar', 'none', 'position', [100 100 500 500], 'Tag', 'uiVViewer', 'NumberTitle', 'off', 'ToolBar', 'none', 'WindowStyle', 'normal', 'HandleVisibility', 'on', 'CloseRequestFcn', @uiVViewer_Close);
    hVViewer = guihandles(uiVViewer);
    uimenu();
    hVViewer.tbVViewBox = uicontrol('Parent', uiVViewer, 'Style', 'edit', 'position', [0 50 500, 450], 'Max', 1000, 'Min', 0, 'String', '>> ', 'HorizontalAlignment', 'left', 'Enable', 'inactive', 'Units', 'Normalized', 'Tag', 'tbVViewBox');
    hVViewer.pbVClose = uicontrol(uiVViewer, 'Style', 'pushbutton', 'String', 'Close Viewer', 'Position', [250, 0, 250 50], 'Units', 'Normalized', 'Tag', 'pbVClose', 'Callback', @pbVClose_Callback);
    hVViewer.pbVClear = uicontrol(uiVViewer, 'Style', 'pushbutton', 'String', 'Clear Screen', 'Position', [0, 0, 250, 50], 'Units', 'Normalized', 'Tag', 'pbVPrint', 'Callback', @pbVClear_Callback);
    stcSwitches.Details = true;
    setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);
    guidata(uiVViewer, hVViewer);
else
    figure(findobj('Tag', 'uiVViewer'));
end
uiBMenu = getappdata(findobj('Tag', 'uiBSoluCheck'), 'uiBMenuDetails');
uiBMenu.Enable = 'on';
setappdata(findobj('Tag', 'uiBSoluCheck'), 'uiBMenuDetails', uiBMenu);

function uiVViewer_Close(hObject, callbackdata)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
stcSwitches.Details = false;
setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);
uiBMenu = getappdata(findobj('Tag', 'uiBSoluCheck'), 'uiBMenuDetails');
uiBMenu.Enable = 'off';
setappdata(findobj('Tag', 'uiBSoluCheck'), 'uiBMenuDetails', uiBMenu);
delete(gcf);

function pbVClose_Callback(hObject, callbackdata)
hDetails = findobj('Tag', 'uiVViewer');
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
stcSwitches.Details = false;
setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);
delete(hDetails);

function pbVClear_Callback(hObject, callbackdata)
hViewer = findobj('Tag', 'uiVViewer');
hViewer.Children(3).String = '>>';

% --- Executes on button press in pbAMaxMin.
function pbAMaxMin_Callback(hObject, eventdata, handles)
% hObject    handle to pbAMaxMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Range;

% --- Executes on button press in pbAExempt.
function pbAExempt_Callback(hObject, eventdata, handles)
% hObject    handle to pbAExempt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Exempt;

% --- Executes on button press in pbAArrSize.
function pbAArrSize_Callback(hObject, eventdata, handles)
% hObject    handle to pbAArrSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SizeArray;

% --- Executes on button press in pbAConfirm.
function pbAConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to pbAConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes when uiAAdvancedOptions is resized.
function uiAAdvancedOptions_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uiAAdvancedOptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pbAArguments.
function pbAArguments_Callback(hObject, eventdata, handles)
% hObject    handle to pbAArguments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Arguments;

% --- Executes on button press in pbANotifications.
function pbANotifications_Callback(hObject, eventdata, handles)
% hObject    handle to pbANotifications (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Notifications;


% --- Executes on button press in pbAPlotTesting.
function pbAPlotTesting_Callback(hObject, eventdata, handles)
% hObject    handle to pbAPlotTesting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
if stcSwitches.PlotTesting
    hObject.String = 'Plot Testing is OFF';
    stcSwitches.PlotTesting = false;
    strResult = '>> Plot Testing...Disabled!';
else
    hObject.String = 'Plot Testing is ON';
    stcSwitches.PlotTesting = true;
    strResult = '>> Plot Testing...Enabled!';
end
setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);
if stcSwitches.Details
    hViewer = findobj('Tag', 'uiVViewer');
    hViewer = hViewer.Children(3);
    strOld = hViewer.String;
    [intLines, ~] = size(strOld);
    cellViewer = cell(1, intLines + 1);
    for i = 1:intLines
        cellViewer{i} = strOld(i, :);
    end
    cellViewer(2:end) = cellViewer(1:end-1);
    cellViewer{1} = strResult;
    hViewer.String = strjoin(cellViewer, '\n');
end

% --- Executes on button press in pbAFileTesting.
function pbAFileTesting_Callback(hObject, eventdata, handles)
% hObject    handle to pbAFileTesting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
if stcSwitches.FileTesting
    hObject.String = 'File Testing is OFF';
    stcSwitches.FileTesting = false;
    strResult = '>> File Testing...Disabled!';
else
    hObject.String = 'File Testing is ON';
    stcSwitches.FileTesting = true;
    strResult = '>> File Testing...Enabled!';
end
if stcSwitches.Details
    hViewer = findobj('Tag', 'uiVViewer');
    hViewer = hViewer.Children(3);
    strOld = hViewer.String;
    [intLines, ~] = size(strOld);
    cellViewer = cell(1, intLines + 1);
    for i = 1:intLines
        cellViewer{i} = strOld(i, :);
    end
    cellViewer(2:end) = cellViewer(1:end-1);
    cellViewer{1} = strResult;
    hViewer.String = strjoin(cellViewer, '\n');
end
setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);


% --- Executes on button press in pbAImageTesting.
function pbAImageTesting_Callback(hObject, eventdata, handles)
% hObject    handle to pbAImageTesting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
if stcSwitches.ImageTesting
    stcSwitches.ImageTesting = false;
    hObject.String = 'Image Testing is OFF';
    strResult = '>> Image Testing...Disabled!';
else
    stcSwitches.ImageTesting = true;
    hObject.String = 'Image Testing is ON';
    strResult = '>> Image Testing...Enabled!';
end
if stcSwitches.Details
    hViewer = findobj('Tag', 'uiVViewer');
    hViewer = hViewer.Children(3);
    strOld = hViewer.String;
    [intLines, ~] = size(strOld);
    cellViewer = cell(1, intLines + 1);
    for i = 1:intLines
        cellViewer{i} = strOld(i, :);
    end
    cellViewer(2:end) = cellViewer(1:end-1);
    cellViewer{1} = strResult;
    hViewer.String = strjoin(cellViewer, '\n');
end
setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);

% --- Executes on button press in pbAParameters.
function pbAParameters_Callback(hObject, eventdata, handles)
% hObject    handle to pbAParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Parameters;


% --- Executes on mouse press over figure background.
function uiAAdvancedOptions_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uiAAdvancedOptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on uiAAdvancedOptions and none of its controls.
function uiAAdvancedOptions_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uiAAdvancedOptions (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(findobj('Tag', 'uiAAdvancedOptions'));
if strcmp('escape', eventdata.Key)
    pbAConfirm_Callback(handles.pbAConfirm, [], handles);
end
