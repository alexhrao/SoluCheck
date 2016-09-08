function varargout = LoadDatabase(varargin)
% LOADDATABASE MATLAB code for LoadDatabase.fig
%      LOADDATABASE, by itself, creates a new LOADDATABASE or raises the existing
%      singleton*.
%
%      H = LOADDATABASE returns the handle to a new LOADDATABASE or the handle to
%      the existing singleton*.
%
%      LOADDATABASE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOADDATABASE.M with the given input arguments.
%
%      LOADDATABASE('Property','Value',...) creates a new LOADDATABASE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LoadDatabase_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LoadDatabase_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LoadDatabase

% Last Modified by GUIDE v2.5 05-Oct-2015 00:26:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LoadDatabase_OpeningFcn, ...
                   'gui_OutputFcn',  @LoadDatabase_OutputFcn, ...
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


% --- Executes just before LoadDatabase is made visible.
function LoadDatabase_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<VANUS,*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LoadDatabase (see VARARGIN)

% Choose default command line output for LoadDatabase
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
if isappdata(findobj('Tag', 'uiBSoluCheck'), 'sExcelFileName')
    strFileName = getappdata(findobj('Tag', 'uiBSoluCheck'), 'sExcelFileName');
    handles.stDFilePath.String = strFileName;
end
% UIWAIT makes LoadDatabase wait for user response (see UIRESUME)
% uiwait(handles.uiDLoadDatabase);


% --- Outputs from this function are returned to the command line.
function varargout = LoadDatabase_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbDBrowse.
function pbDBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to pbDBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[sFileName, sFilePath] = uigetfile({'*.xlsx; *.xls; *.xlsm; *.xlsb;', 'All Excel Files'}, 'Select Excel File:');
if sFileName ~= 0
    set(handles.stDFilePath, 'String', sFileName);
    set(handles.pbDConfirm, 'Enable', 'on');
    addpath(sFilePath);
    [arrRange, cText, cRaw] = xlsread(sFileName, -1);
    % cText and cRaw are reserved for future releases
    setappdata(findobj('Tag', 'uiBSoluCheck'), 'sExcelFileName', sFileName);
    setappdata(findobj('Tag', 'uiBSoluCheck'), 'arrRange', arrRange);
    setappdata(findobj('Tag', 'uiBSoluCheck'), 'cText', cText);
    setappdata(findobj('Tag', 'uiBSoluCheck'), 'cRaw', cRaw);
end

% --- Executes on button press in pbDConfirm.
function pbDConfirm_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
% hObject    handle to pbDConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
stcSwitches.LoadDatabase = true;
setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);
sFileName = getappdata(findobj('Tag', 'uiBSoluCheck'), 'sExcelFileName');
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
    strResult = sprintf('>> Loading Database File %s...Loaded!', sFileName);
    cellViewer{1} = strResult;
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end
close;

% --- Executes on button press in pbDCancel.
function pbDCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pbDCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
stcSwtiches.LoadDatabase = false;
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
    cellViewer{1} = '>> Loading Database...Cancelled!';
    set(hViewer, 'String', strjoin(cellViewer, '\n'));
end
close;
