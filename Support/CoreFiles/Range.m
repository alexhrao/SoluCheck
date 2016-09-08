function varargout = Range(varargin)
% RANGE MATLAB code for Range.fig
%   Do not call Range, as it cannot function outside of SoluCheck.
%
% See also: SoluCheck

% Last Modified by GUIDE v2.5 28-Sep-2015 08:17:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Range_OpeningFcn, ...
                   'gui_OutputFcn',  @Range_OutputFcn, ...
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


% --- Executes just before Range is made visible.
function Range_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*VANUS,*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Range (see VARARGIN)

% Choose default command line output for Range
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
iNargin = getappdata(findobj('Tag', 'uiBSoluCheck'), 'iNargin');
cstArgumentName = cell(1, iNargin);
ctbMaximum = cell(1, iNargin);
ctbMinimum = cell(1, iNargin);
cstDivider = cell(1, iNargin);
for i = 1:iNargin
    cstArgumentName{i} = uicontrol('Style', 'text', 'Tag', ['stRArgumentName' num2str(i)], 'String', sprintf('Argument #%d:', i), 'FontSize', 10.0);
    setpixelposition(cstArgumentName{i}, getpixelposition(handles.stRArgumentNameExample) + [0 (-33 .* (i-1)) 0 0]);
    ctbMinimum{i} = uicontrol('Style', 'edit', 'Tag', ['tbRMin' num2str(i)], 'FontSize', 10.0);
    setpixelposition(ctbMinimum{i}, getpixelposition(handles.tbRMinExample) + [0 (-33.*(i-1)) 0 0]);
    ctbMaximum{i} = uicontrol('Style', 'edit', 'Tag', ['tbRMax' num2str(i)], 'FontSize', 10.0);
    setpixelposition(ctbMaximum{i}, getpixelposition(handles.tbRMaxExample) + [0 (-33.*(i - 1)) 0 0]);
    cstDivider{i} = uicontrol('Style', 'text', 'Tag', ['stRDivider' num2str(i)], 'String', get(handles.stRDividerExample, 'String'));
    setpixelposition(cstDivider{i}, getpixelposition(handles.stRDividerExample) + [0 (-33 .* (i - 1)) 0 0]);

    setpixelposition(handles.pbRConfirm, getpixelposition(handles.pbRConfirm) + [0 -33 0 0]);
    setpixelposition(handles.pbRCancel, getpixelposition(handles.pbRCancel) + [0 -33 0 0]);
end
% These need to be changed to RANGE SCOPE
if isappdata(findobj('Tag', 'uiBSoluCheck'), 'celRanges')
    cMinimum = getappdata(hSoluCheck, 'ctbMinimum');
    cMaximum = getappdata(hSoluCheck, 'ctbMaximum');
    for i = 1:length(cMinimum)
        set(ctbMinimum{i}, 'String', cMinimum{i});
        set(ctbMaximum{i}, 'String', cMaximum{i});
    end
end

setappdata(hSoluCheck, 'cstArgumentName', cstArgumentName);
setappdata(hSoluCheck, 'ctbMinimum', ctbMinimum);
setappdata(hSoluCheck, 'ctbMaximum', ctbMaximum);
setappdata(hSoluCheck, 'cstDivider', cstDivider);
uistack(handles.pbRCancel, 'bottom');
uistack(handles.pbRConfirm, 'bottom');

vecPosn = getpixelposition(handles.pbRConfirm);

if vecPosn(2) < 0
    set(handles.slRYScroller, 'Visible', 'on', 'Max', abs(vecPosn(2)), 'Value', abs(vecPosn(2)));
else
    set(handles.slRYScroller, 'Visible', 'off');
end

% Choose default command line output for Range
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes Range wait for user response (see UIRESUME)
% uiwait(handles.uiRMaxMin);


% --- Outputs from this function are returned to the command line.
function varargout = Range_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function tbRMinExample_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to tbRMinExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbRMinExample as text
%        str2double(get(hObject,'String')) returns contents of tbRMinExample as a double


% --- Executes during object creation, after setting all properties.
function tbRMinExample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbRMinExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbRMaxExample_Callback(hObject, eventdata, handles)
% hObject    handle to tbRMaxExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbRMaxExample as text
%        str2double(get(hObject,'String')) returns contents of tbRMaxExample as a double


% --- Executes during object creation, after setting all properties.
function tbRMaxExample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbRMaxExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slRYScroller_Callback(hObject, eventdata, handles)
% hObject    handle to slRYScroller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
iNargin = getappdata(hSoluCheck, 'iNargin');
cstArgumentName = getappdata(hSoluCheck, 'cstArgumentName');
ctbMaximum = getappdata(hSoluCheck, 'ctbMaximum');
ctbMinimum = getappdata(hSoluCheck, 'ctbMinimum');
stDivider = getappdata(hSoluCheck, 'stDivider');
if isappdata(handles.uiRMaxMin, 'intScrollerValue')
    intScrollerValue = getappdata(handles.uiRMaxMin, 'intScrollerValue');
else
    intScrollerValue = get(hObject, 'Max');
end
intTop = getpixelposition(handles.stRTop);
celNames = {cstArgumentName, ctbMaximum, ctbMinimum, stDivider};
intDifference = -(get(hObject, 'Value') - intScrollerValue);

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
setpixelposition(handles.pbRConfirm, getpixelposition(handles.pbRConfirm) + [0 intDifference 0 0]);
setpixelposition(handles.pbRCancel, getpixelposition(handles.pbRCancel) + [0 intDifference 0 0]);


intScrollerValue = get(hObject, 'Value');
setappdata(findobj('Tag', 'uiRMaxMin'), 'intScrollerValue', intScrollerValue);

% --- Executes during object creation, after setting all properties.
function slRYScroller_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slRYScroller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pbRConfirm.
function pbRConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to pbRConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ctbMaximum = getappdata(findobj('Tag', 'uiBSoluCheck'), 'ctbMaximum');
ctbMinimum = getappdata(findobj('Tag', 'uiBSoluCheck'), 'ctbMinimum');
iNargin = getappdata(findobj('Tag', 'uiBSoluCheck'), 'iNargin');
celRanges = cell(1, length(ctbMaximum));
ctbMaximumInts = cell(1, length(ctbMaximum));
ctbMinimumInts = cell(1, length(ctbMinimum));
for i = 1:length(ctbMaximum)
    celRanges{i} = [str2double(get(ctbMinimum{i}, 'String')), str2double(get(ctbMaximum{i}, 'String'))];
    ctbMaximumInts{i} = get(ctbMaximum{i}, 'String');
    ctbMinimumInts{i} = get(ctbMinimum{i}, 'String');
end
setappdata(findobj('Tag', 'uiBSoluCheck'), 'celRanges', celRanges);
setappdata(findobj('Tag', 'uiBSoluCheck'), 'ctbMaximum', ctbMaximumInts);
setappdata(findobj('Tag', 'uiBSoluCheck'), 'ctbMinimum', ctbMinimumInts);
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
stcSwitches.MaxMin = true;
setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);
if stcSwitches.Details
    hViewer = findobj('Tag', 'uiVViewer');
    hViewer = hViewer.Children(3);
    vecPosns = zeros(1, iNargin);
    for i = 1:iNargin
        if ~strcmp(ctbMaximumInts{i}, '')
            vecPosns(i) = i;
        end
    end
    vecPosns = vecPosns(vecPosns ~= 0);
    cellRangeViewer = cell(1, numel(vecPosns) + 1);
    for i = 1:numel(vecPosns)
        cellRangeViewer{i} = sprintf('>> Argument #%d: %s - %s', vecPosns(i), ctbMinimumInts{vecPosns(i)}, ctbMaximumInts{vecPosns(i)});
    end
    cellRangeViewer(2:end) = cellRangeViewer(1:end-1);
    cellRangeViewer{1} = '>> Ranges...Completed!';
    strOld = get(hViewer, 'String');
    [intLines, ~] = size(strOld);
    cellViewer = cell(1, intLines + numel(cellRangeViewer));
    for i = 1:intLines
        cellViewer{i} = strOld(i, :);
    end
    cellViewer(numel(cellRangeViewer) + 1:end) = cellViewer(1:end-numel(cellRangeViewer));
    cellViewer(1:numel(cellRangeViewer)) = cellRangeViewer;
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end
close;

% --- Executes on button press in pbRCancel.
function pbRCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pbRCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
stcSwitches.MaxMin = false;
setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);
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
    cellViewer{1} = '>> Ranges...Canceled!';
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end
close;

% --- Executes when uiRMaxMin is resized.
function uiRMaxMin_SizeChangedFcn(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to uiRMaxMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
