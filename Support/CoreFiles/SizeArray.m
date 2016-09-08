function varargout = SizeArray(varargin)
% SIZEARRAY MATLAB code for SizeArray.fig
%      SIZEARRAY, by itself, creates a new SIZEARRAY or raises the existing
%      singleton*.
%
%      H = SIZEARRAY returns the handle to a new SIZEARRAY or the handle to
%      the existing singleton*.
%
%      SIZEARRAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIZEARRAY.M with the given input arguments.
%
%      SIZEARRAY('Property','Value',...) creates a new SIZEARRAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SizeArray_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SizeArray_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SizeArray

% Last Modified by GUIDE v2.5 06-Oct-2015 14:24:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SizeArray_OpeningFcn, ...
                   'gui_OutputFcn',  @SizeArray_OutputFcn, ...
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


% --- Executes just before SizeArray is made visible.
function SizeArray_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<VANUS,*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SizeArray (see VARARGIN)

% Choose default command line output for SizeArray
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

hSoluCheck = findobj('Tag', 'uiBSoluCheck');
hSizeArray = hObject;
iNargin = getappdata(hSoluCheck, 'iNargin');
cstArgument = cell(1, iNargin);
ctbRowStep = cell(1, iNargin);
ctbColumnStep = cell(1, iNargin);
ctbValue = cell(1, iNargin);

for i = 1:iNargin
    cstArgument{i} = uicontrol(hObject, 'Style', 'text', 'String', sprintf('Argument #%d:', i), 'FontSize', 10.0, 'Tag', ['stSArgument' num2str(i)]);
    setpixelposition(cstArgument{i}, getpixelposition(handles.stSArgumentExample) + [0 (-33 .* (i - 1)) 0 0]);
    ctbRowStep{i} = uicontrol(hObject, 'Style', 'edit', 'FontSize', 10.0, 'Tag', ['tbSRowStep' num2str(i)]);
    setpixelposition(ctbRowStep{i}, getpixelposition(handles.tbSRowStepExample) + [0 (-33 .* (i - 1)) 0 0]);
    ctbColumnStep{i} = uicontrol(hObject, 'Style', 'edit', 'FontSize', 10.0, 'Tag', ['tbSColumnStep' num2str(i)]);
    setpixelposition(ctbColumnStep{i}, getpixelposition(handles.tbSColumnStepExample) + [0 (-33 .* (i - 1)) 0 0]);
    ctbValue{i} = uicontrol(hObject, 'Style', 'edit', 'FontSize', 10.0, 'Tag', ['tbSValue' num2str(i)], 'HorizontalAlignment', 'left');
    setpixelposition(ctbValue{i}, getpixelposition(handles.tbSValueExample) + [0 (-33 .* (i - 1)) 0 0]);
    
    setpixelposition(handles.pbSCancel, getpixelposition(handles.pbSCancel) + [0 -33 0 0]);
    setpixelposition(handles.pbSConfirm, getpixelposition(handles.pbSConfirm) + [0 -33 0 0]);
end
setappdata(hSizeArray, 'cstArgument', cstArgument);
setappdata(hSizeArray, 'ctbRowStep', ctbRowStep);
setappdata(hSizeArray, 'ctbColumnStep', ctbColumnStep);
setappdata(hSizeArray, 'ctbValue', ctbValue);
if isappdata(findobj('Tag', 'uiBSoluCheck'), 'celArraySizes')
    celArraySizes = getappdata(findobj('Tag', 'uiBSoluCheck'), 'celArraySizes');
    if ~isempty(celArraySizes{1})
        for i = 1:iNargin
            set(ctbRowStep{i}, 'String', num2str(celArraySizes{i}(1)));
            set(ctbColumnStep{i}, 'String', num2str(celArraySizes{i}(2)));
            set(ctbValue{i}, 'String', num2str(celArraySizes{i}(3)));
        end
    end
else
    celArraySizes = cell(1, iNargin);
end
setappdata(hSoluCheck, 'celArraySizes', celArraySizes);


% UIWAIT makes SizeArray wait for user response (see UIRESUME)
% uiwait(handles.uiSArrSize);


% --- Outputs from this function are returned to the command line.
function varargout = SizeArray_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function tbSRowStepExample_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
% hObject    handle to tbSRowStepExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbSRowStepExample as text
%        str2double(get(hObject,'String')) returns contents of tbSRowStepExample as a double


% --- Executes during object creation, after setting all properties.
function tbSRowStepExample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbSRowStepExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbSColumnStepExample_Callback(hObject, eventdata, handles)
% hObject    handle to tbSColumnStepExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbSColumnStepExample as text
%        str2double(get(hObject,'String')) returns contents of tbSColumnStepExample as a double


% --- Executes during object creation, after setting all properties.
function tbSColumnStepExample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbSColumnStepExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbSValueExample_Callback(hObject, eventdata, handles)
% hObject    handle to tbSValueExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbSValueExample as text
%        str2double(get(hObject,'String')) returns contents of tbSValueExample as a double


% --- Executes during object creation, after setting all properties.
function tbSValueExample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbSValueExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbSConfirm.
function pbSConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to pbSConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hSoluCheck = findobj('Tag', 'uiBSoluCheck');
hSizeArray = handles.uiSArrSize;
iNargin = getappdata(hSoluCheck, 'iNargin');
ctbRowStep = getappdata(hSizeArray, 'ctbRowStep');
ctbColumnStep = getappdata(hSizeArray, 'ctbColumnStep');
ctbValue = getappdata(hSizeArray, 'ctbValue');
celArraySizes = getappdata(hSoluCheck, 'celArraySizes');
for i = 1:iNargin
    intRowStep = str2double(get(ctbRowStep{i}, 'String'));
    if isnan(intRowStep)
        intRowStep = 0;
    end
    intColStep = str2double(get(ctbColumnStep{i}, 'String'));
    if isnan(intColStep)
        intColStep = 0;
    end
    intValue = str2double(get(ctbValue{i}, 'String'));
    if isnan(intValue)
        intValue = 0;
    end
    celArraySizes{i} = [intRowStep, intColStep, intValue];
end

stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
stcSwitches.ArrSize = true;
setappdata(hSoluCheck, 'stcSwitches', stcSwitches);
setappdata(hSoluCheck, 'celArraySizes', celArraySizes);
if stcSwitches.Details
    hViewer = findobj('Tag', 'uiVViewer');
    hViewer = hViewer.Children(3);
    vecPosns = zeros(1, iNargin);
    for i = 1:iNargin
        if ~any(isnan(celArraySizes{i}))
            vecPosns(i) = i;
        end
    end
    vecPosns = vecPosns(vecPosns ~= 0);
    cellArraySizeViewer = cell(1, numel(vecPosns) + 1);
    for i = 1:numel(vecPosns)
        cellArraySizeViewer{i} = sprintf('>> Argument #%d: Row: %d Col: %d Value: %d', ...
            vecPosns(i), celArraySizes{vecPosns(i)}(1), ...
            celArraySizes{vecPosns(i)}(2), celArraySizes{vecPosns(i)}(3));
    end
    cellArraySizeViewer(2:end) = cellArraySizeViewer(1:end-1);
    cellArraySizeViewer{1} = '>> Array Sizing...Completed!';
    strOld = get(hViewer, 'String');
    [intLines, ~] = size(strOld);
    cellViewer = cell(1, intLines + numel(cellArraySizeViewer));
    for i = 1:intLines
        cellViewer{i} = strOld(i, :);
    end
    cellViewer(numel(cellArraySizeViewer) + 1:end) = cellViewer(1:end-numel(cellArraySizeViewer));
    cellViewer(1:numel(cellArraySizeViewer)) = cellArraySizeViewer;
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end
close;


% --- Executes on button press in pbSCancel.
function pbSCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pbSCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
stcSwitches.ArrSize = false;
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
    cellViewer{1} = '>> Array Sizing...Canceled!';
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end
close;
