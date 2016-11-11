function varargout = Posture_GUI(varargin)
% POSTURE_GUI MATLAB code for Posture_GUI.fig
%      POSTURE_GUI, by itself, creates a new POSTURE_GUI or raises the existing
%      singleton*.
%
%      H = POSTURE_GUI returns the handle to a new POSTURE_GUI or the handle to
%      the existing singleton*.
%
%      POSTURE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POSTURE_GUI.M with the given input arguments.
%
%      POSTURE_GUI('Property','Value',...) creates a new POSTURE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Posture_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Posture_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Posture_GUI

% Last Modified by GUIDE v2.5 18-Oct-2016 16:00:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Posture_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Posture_GUI_OutputFcn, ...
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


% --- Executes just before Posture_GUI is made visible.
function Posture_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Posture_GUI (see VARARGIN)

% Choose default command line output for Posture_GUI
handles.output = hObject;

handles.angle_test = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Posture_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Posture_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes on button press in timeAboveButton.
function timeAboveButton_Callback(hObject, eventdata, handles)
% hObject    handle to timeAboveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in binButton.
function binButton_Callback(hObject, eventdata, handles)
% hObject    handle to binButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Bin the data:
% TODO: figure out how to do this, once data can be read correctly.
% Test bins for acc_v(:,1)
%x < -2
%-1 > x > -2
%0 > x > -1
% 0 < x < 1
% x > 1
% a = handles.acc_v(:,1);
% bin1 = length(find(a > 1));
% bin2 = length(find(a > 0)) - bin1;
% bin3 = length(find(a > -1)) - bin2 - bin1;
% bin4 = length(find(a > -2)) - bin3 - bin2 - bin1;
% bin5 = length(a) - (bin4 + bin3 + bin2 + bin1);
% 
% bins = [bin1, bin2, bin3, bin4, bin5];
% bin_perc = bins/length(a);
% disp(bins);
% disp(bin_perc);
% 
% bar3(bin_perc,'green');
% xlabel('Bin Num.');
% title('Bins of Accleration Data');
% ylabel('Percentage');

if handles.angle_test
    posture_mag = abs(handles.posture + handles.angle_adj);
else
    posture_mag = abs(handles.posture);
end
total = length(posture_mag);

% Compute bins.
neutral_bin = length(find(posture_mag < 20));    % < 20 degrees of bending in any direction.
mild_bin = length(find(posture_mag < 45)) - neutral_bin; % 21 - 45 degrees of bending.
severe_bin = length(posture_mag) - (mild_bin + neutral_bin);  % > 45 degrees of bending.
bins = [neutral_bin , mild_bin , severe_bin];

% Compute percentages.
neutral_perc = neutral_bin/total;
mild_perc = mild_bin/total;
severe_perc = severe_bin/total;
bin_perc = [neutral_perc, mild_perc, severe_perc];

% Make a bin plot.
bar3(bin_perc,'red');
title('Bins of Posture Data (Percentages)');

% TODO: Add info to the table so we have actual numbers.
bin_data = {'Neutral',neutral_perc,neutral_bin; 'Mild',mild_perc,mild_bin; 'Severe',severe_perc,severe_bin};
set(handles.infoTable,'Data',bin_data);


% --- Executes on button press in insideSelectButton.
function insideSelectButton_Callback(hObject, eventdata, handles)
% hObject    handle to insideSelectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Import an Excel format posture file.
% Check to determine if we are on Windows or OSX
str = computer;
% Read the data file.
% TODO: get this working!
if strcmp(str,'MACI64')
    [input_filename,filepath] = uigetfile('*.csv','Select a File to Open');
    filename = (strcat(filepath,input_filename));
    disp('Reading file:');
    disp(filename);
    handles.acc_v = csvread(filename,1,1);
    %handles.acc_l = csvread(filename,1,2,[1,2,300,2]);
    %handles.acc_s = csvread(filename,1,3,[1,3,300,3]);
    %handles.phi = csvread(filename,1,4,[1,4,300,4]);
    %handles.theta = csvread(filename,1,5,[1,5,300,5]);
else
    % Reading Excel files works correctly on Windows systems. It is
    % somewhat painfully slow. TODO: consider ways to ditch this processing
    % step, or script it into something that can be run overnight, separate
    % from the GUI.
    [input_filename,filepath] = uigetfile('*.xlsx','Select a File to Open');
    filename = (strcat(filepath,input_filename));
    disp('Reading file:');
    disp(filename);
    handles.acc_v = xlsread(filename,3,'B:B');
    handles.acc_l = xlsread(filename,3,'C:C');
    handles.acc_s = xlsread(filename,3,'D:D');
    % These angles do not appear to be needed.
%    handles.phi = xlsread(filename,3,'F:F');
%    handles.theta = xlsread(filename,3,'G:G');
end
disp('File read successfully');

% FOR TESTING PURPOSES ONLY!
handles.posture = 45*handles.acc_v(:,1);

guidata(hObject,handles);



% --- Executes on button press in outsideSelectbutton.
function outsideSelectbutton_Callback(hObject, eventdata, handles)
% hObject    handle to outsideSelectbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Import an Excel format acceleration data file.




% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
