function varargout = Notifications(varargin)
% NOTIFICATIONS
%   By itself, Notifications is useless, and will error out. Please open
%   from within SoluCheck.
% See also: SoluCheck, AdvancedOptions

% Last Modified by GUIDE v2.5 31-Oct-2015 12:50:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Notifications_OpeningFcn, ...
                   'gui_OutputFcn',  @Notifications_OutputFcn, ...
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


% --- Executes just before Notifications is made visible.
function Notifications_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<VANUS>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Notifications (see VARARGIN)

% Choose default command line output for Notifications
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if isappdata(findobj('Tag', 'uiBSoluCheck'), 'cNewPrf')
    cNewPrf = getappdata(findobj('Tag', 'uiBSoluCheck'), 'cNewPrf');
    set(handles.tbNFirstName, 'String', cNewPrf{1});
    set(handles.tbNLastName, 'String', cNewPrf{2});
    set(handles.tbNEmail, 'String', cNewPrf{3});
    set(handles.chNAttach, 'Value', cNewPrf{4});
else
    cNewPrf = {'First Name', 'Last Name', 'Email Address', false};
    setappdata(findobj('Tag', 'uiBSoluCheck'), 'cNewPrf', cNewPrf);
end

% UIWAIT makes Notifications wait for user response (see UIRESUME)
% uiwait(handles.uiNNotifications);


% --- Outputs from this function are returned to the command line.
function varargout = Notifications_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function tbNFirstName_Callback(hObject, eventdata, handles)
% hObject    handle to tbNFirstName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbNFirstName as text
%        str2double(get(hObject,'String')) returns contents of tbNFirstName as a double


% --- Executes during object creation, after setting all properties.
function tbNFirstName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbNFirstName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbNLastName_Callback(hObject, eventdata, handles)
% hObject    handle to tbNLastName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbNLastName as text
%        str2double(get(hObject,'String')) returns contents of tbNLastName as a double


% --- Executes during object creation, after setting all properties.
function tbNLastName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbNLastName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbNEmail_Callback(hObject, eventdata, handles)
% hObject    handle to tbNEmail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbNEmail as text
%        str2double(get(hObject,'String')) returns contents of tbNEmail as a double


% --- Executes during object creation, after setting all properties.
function tbNEmail_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbNEmail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbNConfirm.
function pbNConfirm_Callback(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU>
% hObject    handle to pbNConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hSoluCheck = findobj('Tag', 'uiBSoluCheck');
try
    prfOldSMTP = getpref('Internet', 'SMTP_Server');
    prfOldMail = getpref('Internet', 'E_mail');
    prfOldUser = getpref('Internet', 'SMTP_Username');
    prfOldPass = getpref('Internet', 'SMTP_Password');
catch ME
    disp(['It seems you have no stored internet preferences: ' ME.message]);
    prfOldSMTP = '';
    prfOldMail = '';
    prfOldUser = '';
    prfOldPass = '';
end
props = java.lang.System.getProperties;
prpAuth = props.getProperty('mail.smtp.auth');
prpSocketClass = props.getProperty('mail.smtp.socketFactory.class');
prpPort = props.getProperty('mail.smtp.socketFactory.port');

prfEmail = 'SoluCheck@gmail.com';
prfPass = 'SoluWorks';
setpref('Internet', 'SMTP_Server', 'smtp.gmail.com');
setpref('Internet','E_mail',prfEmail);
setpref('Internet','SMTP_Username',prfEmail);
setpref('Internet','SMTP_Password',prfPass);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

cOldPrf = {prfOldSMTP, prfOldMail, prfOldUser, prfOldPass, prpAuth, prpSocketClass, prpPort};
cNewPrf = {get(handles.tbNFirstName, 'String'), get(handles.tbNLastName, 'String'), get(handles.tbNEmail, 'String'), get(handles.chNAttach, 'Value')};
setappdata(hSoluCheck, 'cOldPrf', cOldPrf);
setappdata(hSoluCheck, 'cNewPrf', cNewPrf);
stcSwitches = getappdata(hSoluCheck, 'stcSwitches');
stcSwitches.Notifications = true;
setappdata(hSoluCheck, 'stcSwitches', stcSwitches);
cNoYes = {'No', 'Yes'};
strResult = sprintf('>> Setting Notifications...Complete! Email Address: %s; Attachments: %s', cNewPrf{3}, cNoYes{cNewPrf{4}+1});
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
close;

% --- Executes on button press in chNAttach.
function chNAttach_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to chNAttach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chNAttach


% --- Executes on button press in pbNCancel.
function pbNCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pbNCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stcSwitches = getappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches');
stcSwitches.Notifications = false;
setappdata(findobj('Tag', 'uiBSoluCheck'), 'stcSwitches', stcSwitches);
setappdata(findobj('Tag', 'uiBSoluCheck'), 'cNewPrf', {'First Name', 'Last Name', 'Email Address', false});
close;
