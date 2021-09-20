%
%   TWISTR_application.m
%   Calvin Boyle - 2021
%   Carnegie Mellon University
%
%   This script is run by the TWISTR main script to create the control
%   figure. Figure is edited via GUIDE.
%

function varargout = TWISTR_application(varargin)
% TWISTR_APPLICATION MATLAB code for TWISTR_application.fig
%      TWISTR_APPLICATION, by itself, creates a new TWISTR_APPLICATION or raises the existing
%      singleton*.
%
%      H = TWISTR_APPLICATION returns the handle to a new TWISTR_APPLICATION or the handle to
%      the existing singleton*.
%
%      TWISTR_APPLICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TWISTR_APPLICATION.M with the given input arguments.
%
%      TWISTR_APPLICATION('Property','Value',...) creates a new TWISTR_APPLICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TWISTR_application_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TWISTR_application_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TWISTR_application


% Last Modified by GUIDE v2.5 20-Sep-2021 13:05:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TWISTR_application_OpeningFcn, ...
                   'gui_OutputFcn',  @TWISTR_application_OutputFcn, ...
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


% --- Executes just before TWISTR_application is made visible.
function TWISTR_application_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TWISTR_application (see VARARGIN)

% Choose default command line output for TWISTR_application
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TWISTR_application wait for user response (see UIRESUME)
% uiwait(handles.figureTWISTR);

set(handles.buttonMotorForward, 'Value', 0);
set(handles.buttonMotorReverse, 'Value', 0);

%HEBI Setup
HebiLookup.initialize();

familyName = 'MOONRANGER';
moduleNames = 'TWISTR';
global group;
group = HebiLookup.newGroupFromNames( familyName, moduleNames );
global cmd;
cmd = CommandStruct();

global test_status
test_status = false;

global a;
a = arduino();



% --- Outputs from this function are returned to the command line.
function varargout = TWISTR_application_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonStartTest.
function buttonStartTest_Callback(hObject, eventdata, handles)
% hObject    handle to buttonStartTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global cmd;
global group;
axes(handles.chartLeft);

global test_status
test_status = true;

global torque_data
global torque_raw_data
torque_data = [];
torque_raw_data = [];

global pos_data
pos_data = [];

global tension_data
tension_data = [];

global a;

fbk = group.getNextFeedback();
start_pos = fbk.position;

while test_status
    cmd.velocity = str2double(get(handles.boxMotorSpeed, 'string'));
    group.send(cmd);
    
    fbk = group.getNextFeedback();
    tor=fbk.effort; 
    pos=fbk.position-start_pos;
    
    torque_data = [torque_data (-1*(-13.98*tor + 3.2349))];
    torque_raw_data = [torque_raw_data tor];
    
    pos_data = [pos_data rad2deg(pos)];
    
    tension_data = [tension_data (1891.6*readVoltage(a, 'A0') + 35.42)];
        
    plot(handles.chartLeft, pos_data, torque_data, 'r-');
    plot(handles.chartRight, torque_data, tension_data, 'r-');
    
    drawnow;
end


% --- Executes on button press in buttonEndTest.
function buttonEndTest_Callback(hObject, eventdata, handles)
% hObject    handle to buttonEndTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global test_status
test_status = false;


% --- Executes on button press in buttonMotorStop.
function buttonMotorStop_Callback(hObject, eventdata, handles)
% hObject    handle to buttonMotorStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.buttonMotorForward, 'Value', 0);
set(handles.buttonMotorReverse, 'Value', 0);



function boxMotorSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to boxMotorSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boxMotorSpeed as text
%        str2double(get(hObject,'String')) returns contents of boxMotorSpeed as a double



% --- Executes during object creation, after setting all properties.
function boxMotorSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxMotorSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonMotorForward.
function buttonMotorForward_Callback(hObject, eventdata, handles)
% hObject    handle to buttonMotorForward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonMotorForward
global cmd;
global group;

while get(hObject, 'value')
    cmd.velocity = str2double(get(handles.boxMotorSpeed, 'string'));
    group.send(cmd);
    drawnow;
end

% --- Executes on button press in buttonMotorReverse.
function buttonMotorReverse_Callback(hObject, eventdata, handles)
% hObject    handle to buttonMotorReverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonMotorReverse

global cmd;
global group;

while get(hObject, 'value')
    cmd.velocity = -1*str2double(get(handles.boxMotorSpeed, 'string'));
    group.send(cmd);
    drawnow;
end


% --- Executes on button press in buttonSaveData.
function buttonSaveData_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSaveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file, path] = uiputfile;

global pos_data
global torque_data
global torque_raw_data
global tension_data

data = [pos_data.' torque_data.' torque_raw_data.' tension_data.'];
T = array2table(data);
T.Properties.VariableNames(1:4) = {'Angular Position (deg)', 'Calibrated Effort (inlbs)', 'Raw Effort (??)', 'Preload (lbf)'};
writetable(T, string(path) + string(file) + ".csv");

figure
sm1=smooth(torque_data);
plot(pos_data, sm1, 'r-');
grid on
grid minor
set(gcf, 'position', [10, 10, 600, 800]);
title(string(file) + ' - Angle vs Torque');
xlabel('Angular Position (degrees)');
ylabel('Torque (inlbs)');
saveas(gcf, string(path) + string(file) + "_AvsT.png");

figure
sm2=smooth(tension_data);
plot(sm1, sm2, 'r-');
grid on
grid minor
set(gcf, 'position', [10, 10, 600, 800]);
title(string(file) + ' - Torque vs Preload');
xlabel('Torque (inlbs)');
ylabel('Preload (lbf)');
saveas(gcf, string(path) + string(file) + "_TvsP.png");




% --- Executes on selection change in popLoadCellSize.
function popLoadCellSize_Callback(hObject, eventdata, handles)
% hObject    handle to popLoadCellSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLoadCellSize contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLoadCellSize


% --- Executes during object creation, after setting all properties.
function popLoadCellSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLoadCellSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
