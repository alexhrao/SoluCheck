function varargout = Arguments(varargin)
% ARGUMENTS MATLAB code for Arguments.fig
%      ARGUMENTS, by itself, creates a new ARGUMENTS or raises the existing
%      singleton*.
%
%      H = ARGUMENTS returns the handle to a new ARGUMENTS or the handle to
%      the existing singleton*.
%
%      ARGUMENTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARGUMENTS.M with the given input arguments.
%
%      ARGUMENTS('Property','Value',...) creates a new ARGUMENTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Arguments_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Arguments_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Arguments

% Last Modified by GUIDE v2.5 30-Jan-2016 15:40:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Arguments_OpeningFcn, ...
                   'gui_OutputFcn',  @Arguments_OutputFcn, ...
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


% --- Executes just before Arguments is made visible.
function Arguments_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<VANUS,*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Arguments (see VARARGIN)

% Choose default command line output for Arguments
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

cFile = getappdata(findobj('Tag', 'uiBSoluCheck'), 'cFile');

fidFunction = fopen(cFile{2});
strLine = fgetl(fidFunction);

while isempty(strfind(strLine, 'function')) || ~isempty(strfind(strLine, '%'))
    strLine = fgetl(fidFunction);
end

cHeader = {strLine};
i = 2;
while isempty(strfind(strLine, ')')) || ~isempty(strfind(strLine, '%'))
    strLine = fgetl(fidFunction);
    cHeader{i} = strLine;
    i = i + 1;
end
set(handles.tbFHeader, 'String', strjoin(cHeader, ' '));
fclose(fidFunction);

fidFunction = fopen(cFile{2});
strLine = fgetl(fidFunction);
intLines = 0;
while ischar(strLine)
    intLines = intLines + 1;
    strLine = fgetl(fidFunction);
end
fclose(fidFunction);
fidFunction = fopen(cFile{2});
strLine = fgetl(fidFunction);

cBody = cell(1, intLines);
i = 1;
while ischar(strLine)
    cBody{i} = strLine;
    strLine = fgetl(fidFunction);
    i = i + 1;
end
set(handles.tbFBody, 'String', strjoin(cBody, '\n'));

fclose(fidFunction);
% UIWAIT makes Arguments wait for user response (see UIRESUME)
% uiwait(handles.uiFViewArguments);


% --- Outputs from this function are returned to the command line.
function varargout = Arguments_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function tbFHeader_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
% hObject    handle to tbFBody (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbFBody as text
%        str2double(get(hObject,'String')) returns contents of tbFBody as a double


% --- Executes during object creation, after setting all properties.
function tbFHeader_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbFBody (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tbFBody_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
% hObject    handle to tbFBody (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbFBody as text
%        str2double(get(hObject,'String')) returns contents of tbFBody as a double


% --- Executes during object creation, after setting all properties.
function tbFBody_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbFBody (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbFAnalyze.
function pbFAnalyze_Callback(hObject, eventdata, handles)
% hObject    handle to pbFAnalyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hObject.String = 'Loading...';
drawnow();
fstFileName = getappdata(findobj('Tag', 'uiBSoluCheck'), 'cFile');
fstFileName = [fstFileName{2}];
stcFlags = codeAnalyzer(fstFileName);
if ~isempty(findobj('Tag', 'uiFFlags'))
    delete(findobj('Tag', 'uiFFlags'));
end
uiFFlags = figure('Tag', 'uiFFlags', 'Position', [100 100 750 500], 'toolbar', 'none', 'menubar', 'none', ...
    'numbertitle', 'off', 'Name', ['Code Analysis for ' fstFileName], 'Resize', 'off');
stFFlags = uicontrol(uiFFlags, 'Tag', 'stFFlags', 'Style', 'text', 'Position', [0 0 750 500], ...
    'HorizontalAlignment', 'left', 'Max', 100, 'Min', 1, 'FontSize', 10.0, 'BackgroundColor', [1 1 1]);
cellStr = {'', '', '', '', '', '', ''};
if numel(fieldnames(stcFlags)) == 1
    cellStr = {['Your Code contains the error ' stcFlags.Error], ''};
end
if stcFlags.total == 0
    cellStr{1} = 'Your code contains no flags.';
else
    if stcFlags.total == 1
        cellStr{1} = 'Your code contains 1 flag. Here''s the breakdown:';
    else
        cellStr{1} = sprintf('Your code contains %d flags. Here''s the breakdown:', stcFlags.total);
    end
    if numel(stcFlags.noClose) > 1
        cellStr{end-1} = sprintf('     Unclosed Files: %d flags were found, and the file names are:\n%s\n', numel(stcFlags.noClose), sprintf('            %s', strjoin(stcFlags.noClose, '\n            ')));
    elseif numel(stcFlags.noClose) == 1
        cellStr{end-1} = sprintf('     Unclosed File: 1 flag was found, and the file name was: %s.', strjoin(stcFlags.noClose, ''));
    else
        cellStr(end-1) = [];
    end
    if numel(stcFlags.unsuppressed) > 1
        cellStr{5} = sprintf('     Unsuppressed Lines: %d flags were found, on lines %s.', numel(stcFlags.unsuppressed), listCreate(stcFlags.unsuppressed));
    elseif numel(stcFlags.unsuppressed) == 1
        cellStr{5} = sprintf('     Unsuppressed Line: 1 flag was found, on line %d.', stcFlags.unsuppressed);
    else
        cellStr(5) = [];
    end
    if numel(stcFlags.badFun) > 1
        cellStr{4} = sprintf('     Bad Functions: %d flags were found, on lines %s.', numel(stcFlags.badFun), strjoin(cellfun(@num2str, num2cell(stcFlags.badFun), 'uni', false), ', '));
    elseif numel(stcFlags.badFun) == 1
        cellStr{4} = sprintf('     Bad Functions: %d flag was found, on line %s.', numel(stcFlags.badFun), strjoin(cellfun(@num2str, num2cell(stcFlags.badFun), 'uni', false), ', '));
    else
        cellStr(4) = [];
    end
    if numel(stcFlags.loop) > 1
        cellStr{3} = sprintf('     Loops: %d flags were found, on lines %s.', numel(stcFlags.loop), listCreate(stcFlags.loop));
    elseif numel(stcFlags.loop) == 1
        cellStr{3} = sprintf('     Loops: 1 flag was found, on line %s.', num2str(stcFlags.loop));
    else
        cellStr(3) = [];
    end
    if numel(stcFlags.imgVar) > 1
        cellStr{2} = sprintf('     Bad Variable Names: %d flags were found, on lines %s.', numel(stcFlags.imgVar), listCreate(stcFlags.imgVar));
    elseif numel(stcFlags.imgVar) == 1
        cellStr{2} = sprintf('     Bad Variable Name: 1 flag was found, on line %s.', num2str(stcFlags.imgVar));
    else
        cellStr(2) = [];
    end
    cellStr{end} = sprintf('Code Analysis Complete.');
end
[cellStr, ~] = textwrap(stFFlags, cellStr);
stFFlags.String = sprintf(strjoin(cellStr, '\n'));
hObject.String = 'Analyze';
drawnow();

% --- Executes on button press in pbFEdit.
function pbFEdit_Callback(hObject, eventdata, handles)
% hObject    handle to pbFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cFile = getappdata(findobj('Tag', 'uiBSoluCheck'), 'cFile');
hArguments = findobj('Tag', 'uiFViewArguments');
if ~isempty(findobj('Tag', 'uiFFlags'))
    delete(findobj('Tag', 'uiFFlags'));
end
if ~isempty(hArguments) && ~isempty(cFile)
    delete(hArguments);
    edit(cFile{2});
else
    msgbox('Error: File Not Found!', 'SoluCheck');
end
