function varargout = ParallelConfiguration(varargin)
% PARALLELCONFIGURATION MATLAB code for ParallelConfiguration.fig
%      PARALLELCONFIGURATION, by itself, creates a new PARALLELCONFIGURATION or raises the existing
%      singleton*.
%
%      H = PARALLELCONFIGURATION returns the handle to a new PARALLELCONFIGURATION or the handle to
%      the existing singleton*.
%
%      PARALLELCONFIGURATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARALLELCONFIGURATION.M with the given input arguments.
%
%      PARALLELCONFIGURATION('Property','Value',...) creates a new PARALLELCONFIGURATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ParallelConfiguration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ParallelConfiguration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ParallelConfiguration

% Last Modified by GUIDE v2.5 30-Nov-2011 10:20:48

% Begin initialization code - DO NOT EDIT
evalin('base','global Parallel Parallel_info')
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ParallelConfiguration_OpeningFcn, ...
                   'gui_OutputFcn',  @ParallelConfiguration_OutputFcn, ...
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
% In a parallel context, this function is used to Initialize the computational
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



% --- Executes just before ParallelConfiguration is made visible.
function ParallelConfiguration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ParallelConfiguration (see VARARGIN)

% Choose default command line output for ParallelConfiguration
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ParallelConfiguration wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Global variables. These variable contain ...
global Parallel Parallel_info

% For local functions computation:
global  ConfigurationFileName ClusterName

Parallel=[];

Parallel_info.leaveSlaveOpen=0;
Parallel_info.console_mode=0;
Parallel_info.RemoteTmpFolder= '';


% --- Outputs from this function are returned to the command line.
function varargout = ParallelConfiguration_OutputFcn(hObject, eventdata, handles) 
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

global  ConfigurationFileName
ConfigurationFileName = get(hObject,'String');


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

global  ConfigurationFileName
ConfigurationFileName = get(hObject,'String');

% --- Executes on button press in BrowseConfigurationFileName.
function BrowseConfigurationFileName_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseConfigurationFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ClusterName_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ClusterName as text
%        str2double(get(hObject,'String')) returns contents of ClusterName as a double

global  ClusterName
ClusterName = get(hObject,'String');

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

global  ClusterName
ClusterName = get(hObject,'String');


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

global Parallel Parallel_info
global ConfigurationFileName ClusterName


[Parallel ErrorCode] = ParallelParser(ConfigurationFileName,ClusterName);


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
    if Parallel(j).Local && isempty(Parallel(j).ProgramPath),
        % Completare!
    end
end



% Invoke masterParallel with 8 arguments and the last equal to 1. With this shape
% for input data, masterParallel only create a new directory for remote
% computation. The name of this directory is time depending. For local
% parallel computations with Strategy == 1 delete the traces (if exists) of
% previous computations.

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



set(hObject,'String', 'The Abobe Cluster is Active!');


% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;

% --- Executes on button press in TestCluster.
function TestCluster_Callback(hObject, eventdata, handles)
% hObject    handle to TestCluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Parallel Parallel_info


% Solo per prova fino a quando non riesco a risolvere il problema delle
% variabili persistenti:

Parallel_info.RemoteTmpFolder='Cocco';

AnalyseComputationalEnvironment(Parallel, Parallel_info);

% --- Executes on button press in ResetData.
function ResetData_Callback(hObject, eventdata, handles)
% hObject    handle to ResetData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
