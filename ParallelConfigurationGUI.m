function varargout = ParallelConfigurationGUI(varargin)
% PARALLELCONFIGURATIONGUI MATLAB code for ParallelConfigurationGUI.fig
%      PARALLELCONFIGURATIONGUI, by itself, creates a new PARALLELCONFIGURATIONGUI or raises the existing
%      singleton*.
%
%      H = PARALLELCONFIGURATIONGUI returns the handle to a new PARALLELCONFIGURATIONGUI or the handle to
%      the existing singleton*.
%
%      PARALLELCONFIGURATIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARALLELCONFIGURATIONGUI.M with the given input arguments.
%
%      PARALLELCONFIGURATIONGUI('Property','Value',...) creates a new PARALLELCONFIGURATIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ParallelConfigurationGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ParallelConfigurationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ParallelConfigurationGUI

% Last Modified by GUIDE v2.5 20-Dec-2011 14:06:36

% Begin initialization code - DO NOT EDIT
evalin('base','global Parallel Parallel_info')
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ParallelConfigurationGUI_OpeningFcn, ...
    'gui_OutputFcn',  @ParallelConfigurationGUI_OutputFcn, ...
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


% PARALLEL CONTEXT
% In a parallel context, this function is used to Initialize in Matlab the computational
% enviroment according with the user request.
%
% INPUTS
% Described below.
%
% OUTPUTS
% None
%
% Copyright (C) 2009-2011 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.


% --- Executes just before ParallelConfigurationGUI is made visible.
function ParallelConfigurationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ParallelConfigurationGUI (see VARARGIN)

% Choose default command line output for ParallelConfigurationGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ParallelConfigurationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% For internal computation
global Flag01 TemporaryData01

Flag01=-1;
TemporaryData01=[];

% Global variables. These variable contain ...
global Parallel Parallel_info

if isempty(Parallel) || isempty(Parallel_info)
    
    Parallel=[];
    Parallel_info=[];
    
    Parallel_info.ConfigurationFileName='C:\Documents and Settings\Ivano\Application Data\dynare.ini';
    Flag01=0;
    set(handles.ClusterName, 'String', '');
    set(handles.SlaveOpenMode,'Value',0);
    set(handles.ConsoleMode,'Value',0);
    
    % The contained the "finish.m" file, used to close, if exist
    % the slaves. This code must be execut onfly by "master" Matalab!
    
    addpath([parallelroot,filesep,'exit_from_parallel']);

end

% --- Outputs from this function are returned to the command line.
function varargout = ParallelConfigurationGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editClustersConfigurationFileName_Callback(hObject, eventdata, handles)
% hObject    handle to editClustersConfigurationFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editClustersConfigurationFileName as text
%        str2double(get(hObject,'String')) returns contents of editClustersConfigurationFileName as a double

global  Parallel_info
Parallel_info.ConfigurationFileName = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function editClustersConfigurationFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editClustersConfigurationFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global  Parallel_info
Parallel_info.ConfigurationFileName = get(hObject,'String');

% --- Executes on button press in BrowseConfigurationFileName.
function BrowseConfigurationFileName_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseConfigurationFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global  Parallel Parallel_info
global Flag01 TemporaryData01

Parallel=[];
Parallel_info=[];

set(handles.editClustersConfigurationFileName, 'String', '');
set(handles.ClusterName, 'String', '');

set(handles.SlaveOpenMode, 'Value', 0);
set(handles.ConsoleMode, 'Value', 0);
set(handles.LoadCluster, 'String', 'Load a Cluster ...');
Flag01=-1;
TemporaryData01=[];



[FileName,PathName] = uigetfile('*.txt', 'Select the configuration cluster file ...');

if isequal(FileName,0)
    return;
end

Parallel_info.ConfigurationFileName=[PathName FileName];

if length(Parallel_info.ConfigurationFileName)<20
    Flag01=1;
    set(handles.editClustersConfigurationFileName, 'String', ([Parallel_info.ConfigurationFileName]));
else
    Flag01=2;
    TemporaryData01=Parallel_info.ConfigurationFileName;
    bS=regexp([Parallel_info.ConfigurationFileName],'\');
    pT=regexp([Parallel_info.ConfigurationFileName],'.txt');
    set(handles.editClustersConfigurationFileName, 'String', ([Parallel_info.ConfigurationFileName(bS(end)+1:pT-1)]));
end

function ClusterName_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ClusterName as text
%        str2double(get(hObject,'String')) returns contents of ClusterName as a double

global  Parallel_info
Parallel_info.ClusterName = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function ClusterName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClusterName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global Parallel_info
Parallel_info.ClusterName = get(hObject,'String');


% --- Executes on button press in SlaveOpenMode.
function SlaveOpenMode_Callback(hObject, eventdata, handles)
% hObject    handle to SlaveOpenMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SlaveOpenMode

global Parallel_info
Parallel_info.leaveSlaveOpen=get(hObject,'Value');

% --- Executes on button press in ConsoleMode.
function ConsoleMode_Callback(hObject, eventdata, handles)
% hObject    handle to ConsoleMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ConsoleMode

global Parallel_info
Parallel_info.console_mode=get(hObject,'Value');

% --- Executes on button press in LoadCluster.
function LoadCluster_Callback(hObject, eventdata, handles)
% hObject    handle to LoadCluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global Flag01 TemporaryData01
global Parallel Parallel_info

if ~isfield(Parallel_info, 'ConfigurationFileName')
    set(handles.LoadCluster, 'String', 'Load a Cluster ...');
    set(handles.editClustersConfigurationFileName, 'String', '');
    set(handles.ClusterName, 'String', '');
    return
end


switch Flag01
    case 0
    case 1
        Parallel_info.ConfigurationFileName = get(handles.editClustersConfigurationFileName,'String');
    case 2
        Parallel_info.ConfigurationFileName = TemporaryData01;
end

Parallel_info.ClusterName = get(handles.ClusterName,'String');


Parallel_info.leaveSlaveOpen=get(handles.SlaveOpenMode,'Value');
Parallel_info.console_mode=get(handles.ConsoleMode,'Value');


if (isfield(Parallel_info, 'ConfigurationFileName')) && (isfield(Parallel_info, 'ClusterName'))
    [Parallel ErrorCode] = ParallelParser(Parallel_info.ConfigurationFileName,Parallel_info.ClusterName);
else
    return
end


if (ErrorCode)
    Parallel=[];
    set(handles.LoadCluster, 'String', 'Load a Cluster ...');
    return;
end

disp(' ');
disp('Cluster Parsing ---> Ok!');
disp(' ');


% This is simple and check!
% The default value for the field MatlabOctavePath now is 'matlab' or
% 'octave'. Then if the field is empty it is necessary to fill it with the
% default value.

for j=1:length(Parallel),
    if isempty(Parallel(j).MatlabOctavePath),
        if exist('OCTAVE_VERSION')
            Parallel(j).MatlabOctavePath = 'octave';
        else
            Parallel(j).MatlabOctavePath = 'matlab';
        end
    end
%     if Parallel(j).Local && isempty(Parallel(j).ProgramPath),
%         % Completare!
%     end
end



% Invoke masterParallel with 8 arguments and the last equal to 1. With this shape
% for input data, masterParallel only create a new directory for remote
% computation. The name of this directory is time depending. For local
% parallel computations with Strategy == 1 delete the traces (if exists) of
% previous computations.

% If the computation is only 'local' this value is unchanched!
Parallel_info.RemoteTmpFolder='';

delete(['P_slave_*End.txt']);
masterParallel(Parallel,[],[],[],[],[],[],Parallel_info,1);


%  We sort in the user CPUWeight and most important the Parallel vector
%  in accord with this operation.

lP=length(Parallel);
for j=1:lP
    CPUWeight(j)=str2num(Parallel(j).NodeWeight);
end

NewPosition=ones(1,lP)*(-1);
CPUWeightTemp=ones(1,lP)*(-1);

CPUWeightTemp=CPUWeight;

for i=1:lP
    [NoNServe mP]=max(CPUWeightTemp);
    NewPosition(i)=mP;
    CPUWeightTemp(mP)=-1;
end

CPUWeight=sort(CPUWeight,'descend');


for i=1:lP
    ParallelTemp(i)=Parallel(NewPosition(i));
end

Parallel=[];
Parallel=ParallelTemp;



% Deactivate some 'Parallel/Warning' message in Octave!
% Comment the line 'warning('off');' in order to view the warning message
% in Octave!

if exist('OCTAVE_VERSION'),
    warning('off');
end


switch Flag01
    case 0
        set(hObject,'String', 'The Default Cluster is Active!');
    case {1, 2}
        set(hObject,'String', 'A Cluster is Active!');
end


% --- Executes on button press in ClearScreen.
function ClearScreen_Callback(hObject, eventdata, handles)
% hObject    handle to ClearScreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc;


% --- Executes on button press in TestCluster.
function TestCluster_Callback(hObject, eventdata, handles)
% hObject    handle to TestCluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Parallel Parallel_info

if isempty(Parallel)
    return;
end

% Text the user cluster ...
AnalyseComputationalEnvironment(Parallel, Parallel_info);

% --- Executes on button press in ResetAll.
function ResetAll_Callback(hObject, eventdata, handles)
% hObject    handle to ResetAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global  Parallel Parallel_info
global  Flag01 TemporaryData01


try
    if isfield(Parallel_info,'RemoteTmpFolder')
        s=warning('off');
        closeSlave(Parallel, Parallel_info.RemoteTmpFolder);
        disp(' ');
        disp('Slave(s), closed!');
        disp(' ');
        s=warning('on');
    end
catch
    s=warning('on');
    disp(' ');
    disp('Some error(s)occurred while try to close the "Slaves"!');
    disp(' ');
end


Parallel=[];
Parallel_info=[];

set(handles.editClustersConfigurationFileName, 'String', '');
set(handles.ClusterName, 'String', '');

set(handles.SlaveOpenMode, 'Value', 0);
set(handles.ConsoleMode, 'Value', 0);
set(handles.LoadCluster, 'String', 'Load a Cluster ...');
Flag01=-1;
TemporaryData01=[];

disp(' ');
disp('All data are DELETED!');
disp(' ');


% --- Executes on button press in CloseSlave.
function CloseSlave_Callback(hObject, eventdata, handles)
% hObject    handle to CloseSlave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global  Parallel Parallel_info

try
    if isfield(Parallel_info,'RemoteTmpFolder')
        s=warning('off');
        closeSlave(Parallel, Parallel_info.RemoteTmpFolder);
        disp(' ');
        disp('Slave(s), closed!');
        disp(' ');
        s=warning('on');
    end
catch
    s=warning('on');
    disp(' ');
    disp('Some error(s)occurred while try to close the "Slaves"!');
    disp(' ');
end



% --- Executes on button press in MapRemoteDrive.
function MapRemoteDrive_Callback(hObject, eventdata, handles)
% hObject    handle to MapRemoteDrive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global  Parallel Parallel_info

for i=1:length(Parallel)
    if (Parallel(i).Local==0)
        if (Parallel_info.RemoteTmpFolder)
            dynareParallelSendFiles('*.*',Parallel_info.RemoteTmpFolder,Parallel);
            disp(' ');
            disp(['Mapping of Remote Drive on ', Parallel(i).ComputerName, ' Macchine ok!']);
            disp(' ');
        end
    end
end



% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;


% --- Executes on button press in Visualize.
function Visualize_Callback(hObject, eventdata, handles)
% hObject    handle to Visualize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global  Parallel Parallel_info

if ~isempty(Parallel)
    disp(' ');
    for i=1:length(Parallel)
        disp(['Cluster Node ', num2str(i)]);
        disp([Parallel(i)]);
    end
    if ~isempty(Parallel_info)
        disp(' ');
        disp('Addidiotanl Information:');
        disp(' ');
        disp([Parallel_info]);
        disp(' ');
    end
else
    disp(' ');
    disp('There are no data to visualize!');
    disp(' ');
end


% --- Executes on button press in Edit.
function Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global  Parallel_info

if isfield(Parallel_info, 'ConfigurationFileName')
    
    if(ispc)
        [NonServeL NonServeR]=system (['notepad ', Parallel_info.ConfigurationFileName]);
    end
else
    disp(' ');
    disp('There are no file to edit!');
    disp(' ')
end
