function varargout = Exempt(varargin)
% EXEMPT MATLAB code for Exempt.fig
%   Do not call Exempt, as it cannot function outside of SoluCheck.
%
% See also: SoluCheck

% Last Modified by GUIDE v2.5 30-Sep-2015 10:16:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Exempt_OpeningFcn, ...
                   'gui_OutputFcn',  @Exempt_OutputFcn, ...
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


% --- Executes just before Exempt is made visible.
function Exempt_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<VANUS,*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Exempt (see VARARGIN)

% Choose default command line output for Exempt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
hExempt = findobj('Tag', 'uiEExempt');
iNargin = getappdata(hSoluCheck, 'iNargin');

cstArgumentName = cell(1, iNargin);
ctbExemptValues = cell(1, iNargin);
ctbStandIn = cell(1, iNargin);
cstDivider = cell(1, iNargin);

for i = 1:iNargin
    cstArgumentName{i} = uicontrol('Style', 'text', 'Tag', ['stEArgumentName' num2str(i)], 'String', sprintf('Argument #%d:', i), 'FontSize', 10.0);
    setpixelposition(cstArgumentName{i}, getpixelposition(handles.stEArgumentNameExample) + [0 (-33 .* (i - 1)) 0 0]);
    ctbExemptValues{i} = uicontrol('Style', 'edit', 'Tag', ['tbEExemptValue' num2str(i)], 'FontSize', 10.0, 'HorizontalAlignment', 'left');
    setpixelposition(ctbExemptValues{i}, getpixelposition(handles.tbEExemptValuesExample) + [0 (-33 .* (i-1)) 0 0]);
    ctbStandIn{i} = uicontrol('Style', 'edit', 'Tag', ['tbEStandIn' num2str(i)], 'FontSize', 10.0);
    setpixelposition(ctbStandIn{i}, getpixelposition(handles.tbEStandInExample) + [0 (-33 .* (i - 1)) 0 0]);
    cstDivider{i} = uicontrol('Style', 'text', 'Tag', ['stEDivider' num2str(i)], 'String', get(handles.stEDividerExample, 'String'), 'HorizontalAlignment', 'left');
    setpixelposition(cstDivider{i}, getpixelposition(handles.stEDividerExample) + [0 (-33 .* (i-1)) 0 0]);
%
    setpixelposition(handles.pbEConfirm, getpixelposition(handles.pbEConfirm) + [0 -33 0 0]);
    setpixelposition(handles.pbECancel, getpixelposition(handles.pbECancel) + [0 -33 0 0]);
end
if isappdata(hSoluCheck, 'celExempt')
    ctbOldExempt = getappdata(hSoluCheck, 'ctbExemptValues');
    ctbOldStandIn = getappdata(hSoluCheck, 'ctbStandIn');
    for i = 1:iNargin
        set(ctbExemptValues{i}, 'String', ctbOldExempt{i});
        set(ctbStandIn{i}, 'String', ctbOldStandIn{i});
    end
end
setappdata(hExempt, 'cstArgumentName', cstArgumentName);
setappdata(hSoluCheck, 'ctbExemptValues', ctbExemptValues);
setappdata(hSoluCheck, 'ctbStandIn', ctbStandIn);
setappdata(hExempt, 'cstDivider', cstDivider);
uistack(handles.pbECancel, 'bottom');
uistack(handles.pbEConfirm, 'bottom');
uistack(handles.slEYScroller, 'top');
% UIWAIT makes Exempt wait for user response (see UIRESUME)
% uiwait(handles.uiEExempt);


% --- Outputs from this function are returned to the command line.
function varargout = Exempt_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when uiEExempt is resized.
function uiEExempt_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uiEExempt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function tbEExemptValuesExample_Callback(hObject, eventdata, handles)
% hObject    handle to tbEExemptValuesExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbEExemptValuesExample as text
%        str2double(get(hObject,'String')) returns contents of tbEExemptValuesExample as a double


% --- Executes during object creation, after setting all properties.
function tbEExemptValuesExample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbEExemptValuesExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbEStandInExample_Callback(hObject, eventdata, handles)
% hObject    handle to tbEStandInExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbEStandInExample as text
%        str2double(get(hObject,'String')) returns contents of tbEStandInExample as a double


% --- Executes during object creation, after setting all properties.
function tbEStandInExample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbEStandInExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slEYScroller_Callback(hObject, eventdata, handles)
% hObject    handle to slEYScroller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slEYScroller_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slEYScroller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pbEConfirm.
function pbEConfirm_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
% hObject    handle to pbEConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hSoluCheck = findobj('Tag', 'uiBSoluCheck');
iNargin = getappdata(hSoluCheck, 'iNargin');
ctbExemptValues = getappdata(hSoluCheck, 'ctbExemptValues');
ctbStandIn = getappdata(hSoluCheck, 'ctbStandIn');
stcSwitches = getappdata(hSoluCheck, 'stcSwitches');
celExempt = cell(1, iNargin);
celStandIn = cell(1, iNargin);
for i = 1:iNargin
    try
        celExempt{i} = evalin('base', ['{' get(ctbExemptValues{i}, 'String') '}']);
    catch ME
        strError = sprintf('Exempt Values #%d: Incorrect list syntax (%s)', i, ME.identifier);
        if stcSwitches.Details
            hViewer = findobj('Tag', 'uiVViewer');
            hViewer = hViewer.Children(3);
            strOld = get(hViewer, 'String');
            [intLines, ~] = size(strOld);
            cellViewer = cell(1, intLines + 1);
            for j = 1:intLines
                cellViewer{j} = strOld(j, :);
            end
            cellViewer(2:end) = cellViewer(1:end-1);
            cellViewer{1} = ['>> ' strError];
            set(hViewer, 'String', strjoin(cellViewer, '\n'));
        end
        msgbox(sprintf('%s\nPlease Enter valid list syntax!', strError), 'SoluCheck Exempt Values');
        beep;
    end
    ctbExemptValues{i} = get(ctbExemptValues{i}, 'String');
    try       
        celStandIn{i} = evalin('base', ['{' get(ctbStandIn{i}, 'String') '}']);
        if numel(celStandIn{i}) ~= 1 && numel(celStandIn{i}) ~= numel(celExempt{i})
            error('MATLAB:badsubscript', 'Incorrect List Length!');
        end
    catch ME
        if strcmp(ME.message, 'Incorrect List Length!')
            strError = sprintf(['Argument #%d: Please either give one stand in value, or the '...
                'same number of stand in values as exempt values!'], i);
            msgbox(strError, 'SoluCheck Exempt Values');
            beep;
        else
            strError = sprintf('Stand-In Values #%d: Incorrect list syntax (%s)', i, ME.identifier);
            msgbox(sprintf('%s\nPlease enter valid list syntax!', strError), 'SoluCheck Exempt Values');
            beep;
        end
        ctbStandIn{i} = get(ctbStandIn{i}, 'String');
        if stcSwitches.Details
            hViewer = findobj('Tag', 'uiVViewer');
            hViewer = hViewer.Children(3);
            strOld = get(hViewer, 'String');
            [intLines, ~] = size(strOld);
            cellViewer = cell(1, intLines + 1);
            for j = 1:intLines
                cellViewer{j} = strOld(j, :);
            end
            cellViewer(2:end) = cellViewer(1:end-1);
            cellViewer{1} = ['>> ' strError, '.'];
            set(hViewer, 'String', strjoin(cellViewer, '\n'));
        end
    end
    ctbStandIn{i} = get(ctbStandIn{i}, 'String');
end
setappdata(hSoluCheck, 'celExempt', celExempt);
setappdata(hSoluCheck, 'celStandIn', celStandIn);
setappdata(hSoluCheck, 'ctbExemptValues', ctbExemptValues);
setappdata(hSoluCheck, 'ctbStandIn', ctbStandIn);
stcSwitches = getappdata(hSoluCheck, 'stcSwitches');
stcSwitches.Exempt = true;
setappdata(hSoluCheck, 'stcSwitches', stcSwitches);
if stcSwitches.Details
    hViewer = findobj('Tag', 'uiVViewer');
    hViewer = hViewer.Children(3);
    intValues = 0;
    vecPosns = zeros(1, iNargin);
    for i = 1:iNargin
        if ~isempty(ctbExemptValues{i})
            intValues = intValues + 1;
            vecPosns(i) = i;
        end
    end
    vecPosns = vecPosns(vecPosns ~= 0);
    cellExemptValues = cell(1, intValues);
    j = 1;
    for i = vecPosns
        cellExemptValues{j} = ['>> Exempt Values...', ctbExemptValues{i}, '-->', ctbStandIn{i}];
        j = j + 1;
    end
    strOld = get(hViewer, 'String');
    [intLines, ~] = size(strOld);
    cellViewer = cell(1, intLines + intValues);
    for i = 1:intLines
        cellViewer{i} = strOld(i, :);
    end
    cellViewer(intValues + 1:end) = cellViewer(1:end-intValues);
    cellViewer(1:intValues) = cellExemptValues;
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end
close;

% --- Executes on button press in pbECancel.
function pbECancel_Callback(hObject, eventdata, handles)
% hObject    handle to pbECancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
stcSwitches.Exempt = false;
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
    cellViewer{1} = '>> Exempt Values...Cancelled!';
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end
close;
