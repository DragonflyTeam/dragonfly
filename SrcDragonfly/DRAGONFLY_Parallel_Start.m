function [startFor, endFor, foutEnlarged] = DRAGONFLY_Parallel_Start(loopVar, startFor, endFor, NamFileInput)

% FUNCTION DESCRIPTION
% This function ...

% INPUTS
% o   ...                           ...
%
%
% OUTPUT
% o   ...                           ...
%


% PARALLEL CONTEXT
% ...


% Copyright (C) 2011-2013 ...
%
% This file is part of ...



% Global variables. These variable contain ...
global Parallel Parallel_info


% SERIAL COMPUTATION!

% If the global variable 'Parallel' is empty,
% the code is computed sequentially.

startTxt = startFor;
endTxt = endFor;
startFor=evalin('caller',startFor);
endFor=evalin('caller',endFor);
fout=[];

if isempty(Parallel)
    disp(' ');
    disp('Serial Computing ... wait ...');
    disp(' ');
    
    foutEnlarged=[];
    return;
end



% PARALLEL COMPUTATION!

% Resolve the start and end point for cycle 'for'.


%%% FILES MANAGEMENT %%%

% If the function requires to copy files remotely ...

%     Which files have to be copied to run remotely:
%     NamFileInput(1,:) = {'','FilaName1'};
%     NamFileInput(2,:) = {'','FilaName2'};
%     % ...
%     NamFileInput(N,:) = {'','FilaNameN'};

% ... to do ...

if nargin==3,
    NamFileInput={'','DRAGONFLY_core.m'};
else
    NamFileInput=[NamFileInput;{'','DRAGONFLY_core.m'}];
end



%%% VARIABLES MANAGEMENT %%%

% Snapshot of the current state of computing. This step is necessary to
% execute in parallel the for loop in function caller (i.e. to execute
% in a corretct way portion of code remotely or on many core).
% The mandatory variables for local/remote parallel computing are stored in
% localVars struct.

% Struct devoted to store local, global and persistent variables.
localVars=struct();

globalVars=struct();

%% Global variables for parallel routines.
globalVars = struct('Parallel',Parallel, ...
    'Parallel_info',Parallel_info);

persistentVars=struct();


% Identifying all the variables in use.
Variables=evalin('caller','whos');


% Reshape and store variables necessary for parallel/serial local/remote
% computaion.

for i=1:length(Variables)
    if strcmp('myinputs',Variables(i).name),
        continue
    end
    if strcmp(startTxt,Variables(i).name),
        continue
    end
    if strcmp(endTxt,Variables(i).name),
        continue
    end
    if Variables(i).global==1
        globalVars.([Variables(i).name])=evalin('caller',Variables(i).name);
    else
        localVars.([Variables(i).name])=evalin('caller',Variables(i).name);
    end
end



%%% _core FUNCTION GENERATION %%%

% Retrive information about the function caller.
fCallerInformation=evalin('caller', 'dbstack(1)');
fName=fCallerInformation.file;
fPath=[evalin('caller', 'pwd') '\'];
fPathAndName=[evalin('caller', 'pwd') '\' fName];
fID=fopen(fPathAndName);

% Estract code from the function caller.
fContent=fscanf(fID,'%c');

% Remouve the comment in matlab code ...
% This step is necessary to remouve the Parallel keywords descriptions.
warning('OFF');
fContent=mlstripcommentsstr(fContent);
warning('ON');

StartLine=strfind(fContent, 'DRAGONFLY_Parallel_Start');
EndLine=strfind(fContent, 'DRAGONFLY_Parallel_Block_End');

% ERRORS management.

% The parallel keywords doesn't match!
if length(StartLine)~=length(EndLine)
    h=errordlg('The parallel keywords doesn t match! ... Serial execution ...');
    uiwait(h);
    startFor=eval('startFor');
    endFor= eval('endFor');
    return
end

% There are two or more portion of code to parallelize.
if (length(StartLine)>1) && (length(EndLine)>1)
    h = warndlg('There are two or more portion of code to parallelize ... NOT YET IMPLEMENTED ... Serial execution ...');
    uiwait(h);
    startFor=eval('startFor');
    endFor= eval('endFor');
    return
end


% Remove parallel keywords and some space.
parallelBlock=fContent(StartLine:EndLine-1);
parallelnewBlock=fContent(StartLine:EndLine-1); % To be deleted
parallelnewBlock=regexprep(parallelnewBlock,' +',' ');

leftexpr= ['[\s(,]',loopVar];
rightexpr= [loopVar,'[)\s,]'];
[NonServe left]=regexp(parallelnewBlock,leftexpr);
[NonServe rigth]=regexp(parallelnewBlock,rightexpr);
LoopVarOcc=intersect(left,rigth-1);
Loop_String=['endFor-startFor+1'];


for i=1:size(LoopVarOcc,2)
   if (i==1) 
      parallelBlockFinal=parallelnewBlock(1:LoopVarOcc(i)-length(loopVar));
      parallelBlockFinal=[parallelBlockFinal,Loop_String];
   else
      parallelBlockFinal=[parallelBlockFinal,parallelnewBlock(LoopVarOcc(i-1)+1:LoopVarOcc(i)-length(loopVar))];
      parallelBlockFinal=[parallelBlockFinal,Loop_String];
   end
end

parallelBlock=[parallelBlockFinal, parallelnewBlock(LoopVarOcc(end)+1:end)];




eL=regexp(parallelBlock,'\n');



% We have to find the control variable

parallelBlock=parallelBlock(eL(1):eL(end));

% fFor=regexp(parallelBlock,'for');
% parallelBlock(1:fFor(1)-1)='';


% Check if exist the tic/toc command in the for cycle.
tictocExist=regexp(parallelBlock,'tic');



% % Insert parameters in loop for ...
% parallelBlockTemp=parallelBlock;
% 
% parallelBlockTemp=parallelBlock;
% forPo=regexp(parallelBlock,'for');
% S1=parallelBlockTemp(1:forPo(1)-1);
% parallelBlockTemp(1:forPo(1)-1)='';
% endL=regexp(parallelBlockTemp,'\n');
% S3=parallelBlockTemp(endL(1):end);
% S2=['for ', loopVar,'=','sPoint',':', 'endPoint'];
% parallelBlock=[S1 S2 S3];


% Insert the code to display Local/Remote computational state
% in graphical or textual mode.

% waitbarExist=regexp(parallelBlock,'waitbar');
%
% if ~isempty(waitbarExist)
endPaBlock=regexp(parallelBlock,'end');
% parallelBlock(endPaBlock(end):end)='';
parallelBlock=...
    strcat...
    (parallelBlock(1:endPaBlock(end)-1), ...
    ['\n\n    if mod(',loopVar,',max(10000,fix(',endTxt,'/100)))==0\n       dyn_waitbar((',loopVar,'-',startTxt,')/',endTxt,',hl);\n    end\n\n'], ...
    parallelBlock(endPaBlock(end):end));
% end
% ... to do.

% ... 'break' management ...

BreakExist=regexp(parallelBlock,'break');

if ~isempty(BreakExist)
    S1=parallelBlock(1:BreakExist(1)-1);
    S3=parallelBlock(BreakExist(1):end);
    S2=['\n       if whoiam\n          myoutput.CloseAllSlaves = 1;\n       end\n'];
    parallelBlock=[S1 S2 S3];
end


% The code that will be write in _core matlab function.
CoreCode=[];

r0=['function [myoutput] = DRAGONFLY_core(myinputs,',startTxt,',',endTxt,',whoiam,ThisMatlab)\n\n'];
r1=['tic\n\n'];
r2=('global Parallel Parallel_info\n\n');

% Input variable will be concatenate in out for cycle.
FieldsLoVar=fieldnames(localVars);

for i=1:length(FieldsLoVar)
    if strcmp(FieldsLoVar{i},'FileList')
        FieldsLoVar(i)='';
        break
    end
end

for i=1:length(FieldsLoVar)
    r3{i}=[FieldsLoVar{i},'=','myinputs.',FieldsLoVar{i},';\n'];
end

r3end=['clear myinputs myoutput;\n'];
r4=['\nprct={0,whoiam,Parallel(ThisMatlab)};\n'];
r5=['\nhl = dyn_waitbar(prct,[''Please wait... ''],''Name'', ''Sequential Computing of ...'');\n\n'];

% ParallelBlock is inserted here ...%%%%%%%%%%%%%%%%%%%%%

r6=['\nVaWo=whos;\n\n'];
r7=['for i=1:length(VaWo)\n'];
r8=['   if VaWo(i).global==0\n'];
r9=['       myoutput.([VaWo(i).name])=eval(VaWo(i).name);\n'];
r10=['   end\n'];
r11=['end\n\n'];


r12=['\nComputationalTime=toc\n'];
r13=['myoutput.ComputationalTime =ComputationalTime;\n\n'];
r14=['dyn_waitbar_close(hl)'];

% Waitbar managemant ...
% if isempty(waitbarExist)
% end

% Computational time managemant: tic/toc ...
if isempty(tictocExist)
    r1='';
    r12='';
    r13='';
end



CoreCode=([r0,r1,r2,r3{:},r3end,r4,r5,parallelBlock,r6,r7,r8,r9,r10,r11,r12]);



fid = fopen('DRAGONFLY_core.m', 'w+');
fprintf(fid,CoreCode, '%s');
fclose(fid);


disp(' ');
disp('Go Parallel ...');
disp(' ');


[fout, nBlockPerCPU, totCPU] = masterParallel(Parallel, startFor, endFor,NamFileInput,'DRAGONFLY_core', localVars, globalVars,Parallel_info);

% Compact the information returned by masterParallel ...
AddOutInf=struct;
AddOutInf=setfield(AddOutInf,'nBlockPerCPU',nBlockPerCPU);
AddOutInf=setfield(AddOutInf,'totCPU',totCPU);


foutEnlarged=struct;

foutEnlarged=setfield(foutEnlarged,'fout',fout);
foutEnlarged=setfield(foutEnlarged,'AddOutInf',AddOutInf);



% Reshape the result of parallell remote/locale computation ...

% Can be grouped ...
% keyboard
% Variables declared in keyword DRAGONFLY_Parallel_Start ...
% for i=1:(length(varargin)-1)
%     if isfield(fout, varargin{i})
%         vTempGlo=[];
%         for j=1:totCPU
%             vTempGlo=[vTempGlo fout(j).([varargin{i}])];
%         end
%         assignin('caller', varargin{i}, vTempGlo);
%     end
% end


% Local variables ...
% loVaName=fieldnames(localVars);


% Global variables ...
% gloVaName=fieldnames(globalVars);


% To jump the cycle in function caller ...
startFor=0;
endFor=-1;

% Delete the dynamic _core.m file.
delete('DRAGONFLY_core.m');
for j=1:size(NamFileInput,1),
    if ~isempty(NamFileInput{j,1}),
        tmpFolder=[Parallel_info.RemoteTmpFolder filesep NamFileInput{j,1}];
    else
        tmpFolder=Parallel_info.RemoteTmpFolder;
    end
    dynareParallelDelete(NamFileInput{j,2},tmpFolder,Parallel);
end

