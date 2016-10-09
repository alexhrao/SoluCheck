function varargout = userPrefs(varargin)
% USERPREFS MATLAB code for userPrefs.fig
%      USERPREFS, by itself, creates a new USERPREFS or raises the existing
%      singleton*.
%
%      H = USERPREFS returns the handle to a new USERPREFS or the handle to
%      the existing singleton*.
%
%      USERPREFS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USERPREFS.M with the given input arguments.
%
%      USERPREFS('Property','Value',...) creates a new USERPREFS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before userPrefs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to userPrefs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help userPrefs

% Last Modified by GUIDE v2.5 09-Oct-2016 13:31:28

% Begin initialization code - DO NOT EDIT
%#ok<*DEFNU>
%#ok<*INUSL>
%#ok<*INUSD>
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @userPrefs_OpeningFcn, ...
                   'gui_OutputFcn',  @userPrefs_OutputFcn, ...
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


% --- Executes just before userPrefs is made visible.
function userPrefs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to userPrefs (see VARARGIN)

% Choose default command line output for userPrefs
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

fid = fopen('SoluCheckInfo.txt', 'r');
stcPrefs = struct('Name', 'Name', 'Email', 'Email', 'GTID', 'GT ID', 'CID', 'Course ID', 'SID', 'Section ID', 'Other', {{{}}});
cellPrefs = fieldnames(stcPrefs);
if fid ~= -1
    cText = textscan(fid, '%s', 5, 'Whitespace', '\n');
    if ~isempty(cText{1})
        for k = 1:5
            stcPrefs.(cellPrefs{k}) = cText{1}{k};
        end
    end
    cOther = textscan(fid, '%s');
    stcPrefs.Other = cOther;
    fclose(fid);
end
handles.tbRName.String = stcPrefs.Name;
handles.tbREmail.String = stcPrefs.Email;
handles.tbRGTID.String = stcPrefs.GTID;
handles.tbRCID.String = stcPrefs.CID;
handles.tbRSID.String = stcPrefs.SID;
guidata(hObject, handles);
setappdata(hObject, 'stcPrefs', stcPrefs);
% UIWAIT makes userPrefs wait for user response (see UIRESUME)
% uiwait(handles.uiRPrefs);


% --- Outputs from this function are returned to the command line.
function varargout = userPrefs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function tbRGTID_Callback(hObject, eventdata, handles)
% hObject    handle to tbRGTID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbRGTID as text
%        str2double(get(hObject,'String')) returns contents of tbRGTID as a double

% --- Executes during object creation, after setting all properties.
function tbRGTID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbRGTID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbRName_Callback(hObject, eventdata, handles)
% hObject    handle to tbRName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbRName as text
%        str2double(get(hObject,'String')) returns contents of tbRName as a double


% --- Executes during object creation, after setting all properties.
function tbRName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbRName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbREmail_Callback(hObject, eventdata, handles)
% hObject    handle to tbREmail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbREmail as text
%        str2double(get(hObject,'String')) returns contents of tbREmail as a double


% --- Executes during object creation, after setting all properties.
function tbREmail_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbREmail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbRCID_Callback(hObject, eventdata, handles)
% hObject    handle to tbRCID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbRCID as text
%        str2double(get(hObject,'String')) returns contents of tbRCID as a double


% --- Executes during object creation, after setting all properties.
function tbRCID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbRCID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbRSID_Callback(hObject, eventdata, handles)
% hObject    handle to tbRSID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbRSID as text
%        str2double(get(hObject,'String')) returns contents of tbRSID as a double


% --- Executes during object creation, after setting all properties.
function tbRSID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbRSID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbRConfirm.
function pbRConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to pbRConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hPrefs = findobj('tag', 'uiRPrefs');
stcPrefs = getappdata(hPrefs, 'stcPrefs');
stcPrefs.Name = handles.tbRName.String;
stcPrefs.Email = handles.tbREmail.String;
stcPrefs.GTID = handles.tbRGTID.String;
stcPrefs.CID = handles.tbRCID.String;
stcPrefs.SID = handles.tbRSID.String;
fid = fopen('SoluCheckInfo.txt', 'w');
cellFields = fieldnames(stcPrefs);
for k = 1:numel(cellFields) - 1
    fprintf(fid, '%s\n', stcPrefs.(cellFields{k}));
end
cellOther = stcPrefs.Other;
strOther = strjoin(cellOther{1}, '\n');
fprintf(strOther);
fclose(fid);
uiresume();
close(hPrefs);


% --- Executes on key press with focus on uiRPrefs and none of its controls.
function uiRPrefs_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uiRPrefs (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key, 'escape')
    close(findobj('tag', 'uiRPrefs'));
end


% --- Executes during object deletion, before destroying properties.
function uiRPrefs_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to uiRPrefs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume();