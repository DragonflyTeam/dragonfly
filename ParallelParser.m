function [Parallel ErrorCode] = ParallelParser(ParallelConfigurationFile, ClusterName, Visualize)

% FUNCTION DESCRIPTION
% ...

% INPUTS
% o   ParallelConfigurationFile [string]        The name of the file
%                                               containig the clusters
%                                               definitions.
%
% o   ClusterName [string]                      The Name of the Cluster selected in
%                                               ParallelConfigurationFile.
%                                               If is the empty strig the
%                                               first cluster will be
%                                               considered.
%
% o   Visualize   [integer]                     If it is equal to 1, at the
%                                               and of computing visualize
%                                               the parser analysis
%                                               results!
%
%
%
% OUTPUT
% Parallel          [Array of Struct]           The fields are: ...
% ErrorCode         [Integer]                   The values are: [1:N].



if nargin<3
    Visualize=0;
end

% Function Resources.
Parallel=[];
ErrorCode=0;

Nodes=[];


% Open, Read and Close, the input file ...
try
    FileConfigurationID=fopen(ParallelConfigurationFile);
    [FileText NonServe]=fscanf(FileConfigurationID,'%c');
    fclose(FileConfigurationID);
catch
    ErrorCode=10;
    Reaction=ParallelGlobalErrorHandling(ErrorCode);
    return
end


% Analyze FileText to build Parallel.


% First we check if the general structure of the file is correct, i.e. the
% file must contain a cluster definition, ..., a node.

% Keys definitions:
Key01= strfind(FileText,'[cluster]');


Key02= strfind(FileText,'Name = ');
% Try to find others string similar to Key02 in configuration file header.
if isempty(Key02)
    Key02= strfind(FileText,'Name= ');
    if isempty(Key02)
        Key02= strfind(FileText,'Name =');
        if isempty(Key02)
            Key02= strfind(FileText,'Name=');
        end
    end
end


Key03= strfind(FileText,'Members = ');
% Try to find others string similar to Key03 in configuration file header.
if isempty(Key03)
    Key03= strfind(FileText,'Members= ');
    if isempty(Key03)
        Key03= strfind(FileText,'Members =');
        if isempty(Key03)
            Key03= strfind(FileText,'Members=');
        end
    end
end


Key04= strfind(FileText,'[node]');

% In Cluster Header one or more key word is (are) missing.
if (isempty(Key01) || (isempty(Key02)) || (isempty(Key03)) || (isempty(Key04)))
    ErrorCode=1;
    Reaction=ParallelGlobalErrorHandling(ErrorCode);
    return
end




% Analyze the 'Cluster' portion in FileText.


% Exstract the Members for ClusterName and when (and if) necessary the Cluster Name.

% In a text file we have only one [cluster] key.
if length(Key01)==1
    
    % In this case the variable 'Name' is un-necessary!
    
    % Fix the exact form of the key 'Member'.
    
    Key03='';
    
    Key03Partial= strfind(FileText,'Members');
    % We have two or more keywords 'Members'!
    if length(Key03Partial)>1
        ErrorCode=1;
        Reaction=ParallelGlobalErrorHandling(ErrorCode);
        return
    end
    
    Key03= strfind(FileText,'Members = ');
    lKey03=length('Members = ');
    if isempty(Key03)
        Key03= strfind(FileText,'Members= ');
        lKey03=length('Members = ')-1;
        if isempty(Key03)
            Key03= strfind(FileText,'Members =');
            lKey03=length('Members = ')-1;
            if isempty(Key03)
                Key03= strfind(FileText,'Members=');
                lKey03=length('Members = ')-2;
            end
        end
    end
    
    
    
    FindKey03=regexp(FileText(Key03(1)+lKey03:end),'\n');
    Members=FileText(Key03(1)+lKey03:Key03(1)+lKey03+FindKey03(1)-3);
    
    % Check if string a Members is empty!
    
    MembersTemp=Members;
    MembersTemp(isspace(MembersTemp))='';
    
    if isempty(MembersTemp)
        ErrorCode=1;
        Reaction=ParallelGlobalErrorHandling(ErrorCode);
        return
    end
    
    
    
else    % We have two or more [cluster] keys.
    
    
    % We have two or more [cluster] keys and the cluster name in function
    % call is empty! So for default we consider the first.
    
    if isempty(ClusterName)
        
        % Fix the exact form of the key 'Name'.
        % Nevertheless the variable 'Name' is now un-used!
        
        Key02='';
        
        Key02Temp= strfind(FileText,'Name');
        
        if strcmp(FileText(Key02Temp(1):Key02Temp(1)+6),'Name = ')
            Key02= strfind(FileText,'Name = ');
            lKey02=length('Name = ');
        end
        
        if strcmp(FileText(Key02Temp(1):Key02Temp(1)+5),'Name= ')
            Key02= strfind(FileText,'Name= ');
            lKey02=length('Name = ')-1;
        end
        
        if strcmp(FileText(Key02Temp(1):Key02Temp(1)+5),'Name =')
            Key02= strfind(FileText,'Name =');
            lKey02=length('Name = ')-1;
        end
        
        if strcmp(FileText(Key02Temp(1):Key02Temp(1)+4),'Name=')
            Key02= strfind(FileText,'Name=');
            lKey02=length('Name = ')-2;
        end
        
        
        % Fix the exact form of the key 'Members'.
        Key03='';
        
        Key03Temp= strfind(FileText,'Members');
        
        if strcmp(FileText(Key03Temp(1):Key03Temp(1)+9),'Members = ')
            Key03= strfind(FileText,'Members = ');
            lKey03=length('Members = ');
        end
        if strcmp(FileText(Key03Temp(1):Key03Temp(1)+8),'Members= ')
            Key03= strfind(FileText,'Members= ');
            lKey03=length('Members = ')-1;
        end
        if strcmp(FileText(Key03Temp(1):Key03Temp(1)+8),'Members =')
            Key03= strfind(FileText,'Members =');
            lKey03=length('Members = ')-1;
        end
        if strcmp(FileText(Key03Temp(1):Key03Temp(1)+7),'Members=')
            Key03= strfind(FileText,'Members=');
            lKey03=length('Members = ')-2;
        end
        
        
        if isempty(Key02) || isempty(Key03)
            ErrorCode=1;
            Reaction=ParallelGlobalErrorHandling(ErrorCode);
            return
        end
        
        FindKey02=regexp(FileText(Key02(1)+lKey02:end),'\n');
        Name=FileText(Key02(1)+lKey02:Key02(1)+lKey02+FindKey02(1)-3);
        
        FindKey03=regexp(FileText(Key03(1)+lKey03:end),'\n');
        Members=FileText(Key03(1)+lKey03:Key03(1)+lKey03+FindKey03(1)-3);
        
        
        % Check if string a Members is empty!
        
        MembersTemp=Members;
        MembersTemp(isspace(MembersTemp))='';
        
        if isempty(MembersTemp)
            ErrorCode=1;
            Reaction=ParallelGlobalErrorHandling(ErrorCode);
            return
        end
        
    else
        
        % We have two or more [cluster] keys in a configuration file then we find the cluster name
        % write by user in function call!
        
        FindClusterName=regexp(FileText,ClusterName);
        if isempty(FindClusterName)
            ErrorCode=2;
            Reaction=ParallelGlobalErrorHandling(ErrorCode);
            return
        end
        
        Key03='';
        
        % Extract the portion of code relative to the ClusterName in input.
        
        FileTextTemp=FileText((FindClusterName+length(ClusterName)):end);
        Key01Temp= strfind(FileTextTemp,'[cluster]');
        
        if isempty(Key01Temp)
            PortionFileText=FileTextTemp;
        else
            PortionFileText=FileTextTemp(1:Key01Temp(1)-1);
        end
        
        Key03Partial= strfind(PortionFileText,'Members');
        % We have two or more keywords 'Members'!
        if length(Key03Partial)>1
            ErrorCode=1;
            Reaction=ParallelGlobalErrorHandling(ErrorCode);
            return
        end
        
        Key03= strfind(PortionFileText,'Members = ');
        lKey03=length('Members = ');
        if isempty(Key03)
            Key03= strfind(PortionFileText,'Members= ');
            lKey03=length('Members = ')-1;
            if isempty(Key03)
                Key03= strfind(PortionFileText,'Members =');
                lKey03=length('Members = ')-1;
                if isempty(Key03)
                    Key03= strfind(PortionFileText,'Members=');
                    lKey03=length('Members = ')-2;
                end
            end
        end
        
        
        FindKey03=regexp(PortionFileText(Key03(1)+lKey03:end),'\n');
        Members=PortionFileText(Key03(1)+lKey03:Key03(1)+lKey03+FindKey03(1)-3);
        
        % Check if string a Members is empty!
        
        MembersTemp=Members;
        MembersTemp(isspace(MembersTemp))='';
        
        if isempty(MembersTemp)
            ErrorCode=1;
            Reaction=ParallelGlobalErrorHandling(ErrorCode);
            return
        end
        
    end
end

% At this point we have the Cluster name and a string with all the cluster's
% members.


% Extract the single member (Node) Name and Compute the Node Weight.
if exist('OCTAVE_VERSION')
    if isempty(regexp(Members,'\('))
        NoWeight=1;
    else
        NoWeight=0;
    end
else
    if isempty(regexp(Members,'('))
        NoWeight=1;
    else
        NoWeight=0;
    end
end


MembersName=[];
j=1;
Slide=1;
% Find spaces in string Members.
nPositions=strfind(Members,' ');
for i=1:length(nPositions)+1
    if i==length(nPositions)+1
        MembersName(j).Name=Members(Slide:end);
    else
        MembersName(j).Name=Members(Slide:nPositions(i)-1);
        Slide=nPositions(i);
    end
    j=j+1;
end

% Remove from MembersName 'space' and 'empty' strings, if exist.
MembersNameTemp=MembersName;
MembersName=[];
j=1;
for i=1:length(MembersNameTemp)
    nS=MembersNameTemp(i).Name;
    if (nS==' ')
    else
        eS=~isempty(nS);
        if eS
            MembersName(j).Name=MembersNameTemp(i).Name;
            j=j+1;
        end
    end
end

% Extract and Compute the Node Weight.
if NoWeight==1
    NodeWeight=ones(1,length(MembersName));
else
    for i=1:length(MembersName)
        
        sTemp=MembersName(i).Name;
        
        pA=regexp(sTemp,'(');
        pC=regexp(sTemp,')');
        
        % An error in weight definition!
        if isempty(pA) || isempty(pC) || (pC-pA)==1
            ErrorCode=4;
            Reaction=ParallelGlobalErrorHandling(ErrorCode);
            return
        end
        
        NodeWeight(i)=str2num(MembersName(i).Name(pA:pC));
        MembersName(i).Name(pA:pC)='';
        
    end
    NodeWeight=NodeWeight/sum(NodeWeight);
end


% Check if the Member name are in configuration file.

% This control is un-necessary has already been made ??above.
SplitPoint=strfind(FileText,'[node]');

% In FileText we have no node definitions.
if (isempty(SplitPoint))
    ErrorCode=1;
    Reaction=ParallelGlobalErrorHandling(ErrorCode);
    return
end

% Split FileText in two parts:
ClusterHeader=FileText(1:SplitPoint-1);
NodeDefinitions=FileText(SplitPoint:end);

for i=1:length(MembersName)
    FindNode=strfind(NodeDefinitions,MembersName(i).Name);
    if (isempty(FindNode))
        ErrorCode=3;
        Reaction=ParallelGlobalErrorHandling(ErrorCode);
        return
    end
    
end


% At this poin we have the member (Node) for the cluster.


% Analyze the node definitions...

% Key definitions:

% The Key 'Local' is not necessary because the field Local is assigned on the basis of 'ComputerName' value.
% The Key 'NodeWeight' is not necessary because we know the NodeWeight value!
NumKeys=11;
nOP=4;

Key05(1).ComputerName='ComputerName = ';
Key05(2).ComputerName='ComputerName= ';
Key05(3).ComputerName='ComputerName =';
Key05(4).ComputerName='ComputerName=';
lKey05=length('ComputerName = ');

Key06(1).CPUnbr='CPUnbr = ';
Key06(2).CPUnbr='CPUnbr= ';
Key06(3).CPUnbr='CPUnbr =';
Key06(4).CPUnbr='CPUnbr=';
lKey06=length('CPUnbr = ');

Key07(1).UserName='UserName = ';
Key07(2).UserName='UserName= ';
Key07(3).UserName='UserName =';
Key07(4).UserName='UserName=';
lKey07=length('UserName = ');

Key08(1).Password='Password = ';
Key08(2).Password='Password= ';
Key08(3).Password='Password =';
Key08(4).Password='Password=';
lKey08=length('Password = ');

Key09(1).RemoteDrive='RemoteDrive = ';
Key09(2).RemoteDrive='RemoteDrive= ';
Key09(3).RemoteDrive='RemoteDrive =';
Key09(4).RemoteDrive='RemoteDrive=';
lKey09=length('RemoteDrive = ');

Key10(1).RemoteDirectory='RemoteDirectory = ';
Key10(2).RemoteDirectory='RemoteDirectory= ';
Key10(3).RemoteDirectory='RemoteDirectory =';
Key10(4).RemoteDirectory='RemoteDirectory=';
lKey10=length('RemoteDirectory = ');

Key11(1).ProgramPath='ProgramPath = ';
Key11(2).ProgramPath='ProgramPath= ';
Key11(3).ProgramPath='ProgramPath =';
Key11(4).ProgramPath='ProgramPath=';
lKey11=length('ProgramPath = ');

Key12(1).ProgramConfig='ProgramConfig = ';
Key12(2).ProgramConfig='ProgramConfig= ';
Key12(3).ProgramConfig='ProgramConfig =';
Key12(4).ProgramConfig='ProgramConfig=';
lKey12=length('ProgramConfig = ');

Key13(1).MatlabOctavePath='MatlabOctavePath = ';
Key13(2).MatlabOctavePath='MatlabOctavePath= ';
Key13(3).MatlabOctavePath='MatlabOctavePath =';
Key13(4).MatlabOctavePath='MatlabOctavePath=';
lKey13=length('MatlabOctavePath = ');

Key14(1).OperatingSystem ='OperatingSystem = ';
Key14(2).OperatingSystem='OperatingSystem= ';
Key14(3).OperatingSystem='OperatingSystem =';
Key14(4).OperatingSystem='OperatingSystem=';
lKey14=length('OperatingSystem = ');

Key15(1).SingleCompThread ='SingleCompThread = ';
Key15(2).SingleCompThread='SingleCompThread= ';
Key15(3).SingleCompThread='SingleCompThread =';
Key15(4).SingleCompThread='SingleCompThread=';
lKey15=length('SingleCompThread = ');



% Parallel data construction.

for i=1:length(MembersName)
    
    % Parallel initialization.
    Parallel(i).Local=1;
    Parallel(i).ComputerName='';
    Parallel(i).CPUnbr='';
    Parallel(i).UserName='';
    Parallel(i).Password='';
    Parallel(i).RemoteDrive='';
    Parallel(i).RemoteDirectory='';
    Parallel(i).ProgramPath='';
    Parallel(i).ProgramConfig='';
    Parallel(i).MatlabOctavePath='';
    Parallel(i).OperatingSystem='';
    Parallel(i).NodeWeight=1;
    Parallel(i).SingleCompThread='';
    
    % Extract the node definition.
    Key04Partial=strfind(NodeDefinitions,'[node]');
    NodeNamePosition=strfind(NodeDefinitions,MembersName(i).Name);
    EndPoint=min(find(Key04Partial>=NodeNamePosition));
    StartPoint=max(find(Key04Partial<=NodeNamePosition));
    if isempty(EndPoint)
        NodeBlock=NodeDefinitions(Key04Partial(StartPoint):end);
    else
        NodeBlock=NodeDefinitions(Key04Partial(StartPoint):Key04Partial(EndPoint)-1);
    end
    
    NodeBlockEndOfLine=regexp(NodeBlock,'\n');
    
    % Note:
    % If in a node definition we have two o more egual key, we simply
    % consider the first definition.
    
    
    % Find Key05.
    Key05Position=[];
    for k=1:nOP
        Key05Position=regexp(NodeBlock,Key05(k).ComputerName);
        if ~isempty(Key05Position)
            if k==4
                lKey05=lKey05-1;
            end
            break;
        end
    end
    Key05Position(2:end)=[];
    
    if ~isempty(Key05Position)
        StartPoint=max(find(Key05Position>=NodeBlockEndOfLine));
        EndPoint=min(find(Key05Position<=NodeBlockEndOfLine));
        if isempty(EndPoint)
            Parallel(i).ComputerName=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey05:end);
        else
            Parallel(i).ComputerName=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey05: NodeBlockEndOfLine(EndPoint)-1);
        end
        % Remove from the string ' ', '\r', '\n', etc.
        Parallel(i).ComputerName(isspace(Parallel(i).ComputerName))='';
        Parallel(i).ComputerName(regexp(Parallel(i).ComputerName,'\n'))='';
        Parallel(i).ComputerName(regexp(Parallel(i).ComputerName,'\r'))='';
    end
    % No string found!
    if isempty(Parallel(i).ComputerName)
        Parallel(i).ComputerName='';
    end
    lKey05=length('ComputerName = ');
    
    
    
    % Find Key06.
    Key06Position=[];
    for k=1:nOP
        Key06Position=regexp(NodeBlock,Key06(k).CPUnbr);
        if ~isempty(Key06Position)
            if k==4
                lKey06=lKey06-1;
            end
            break;
        end
    end
    Key06Position(2:end)=[];
    
    if ~isempty(Key06Position)
        StartPoint=max(find(Key06Position>=NodeBlockEndOfLine));
        EndPoint=min(find(Key06Position<=NodeBlockEndOfLine));
        if isempty(EndPoint)
            Parallel(i).CPUnbr=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey06:end);
        else
            Parallel(i).CPUnbr=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey06: NodeBlockEndOfLine(EndPoint)-1);
        end
        % Remove from the string ' ', '\r', '\n', etc.
        Parallel(i).CPUnbr(isspace(Parallel(i).CPUnbr))='';
        Parallel(i).CPUnbr(regexp(Parallel(i).CPUnbr,'\n'))='';
        Parallel(i).CPUnbr(regexp(Parallel(i).CPUnbr,'\r'))='';
    end
    % No string found!
    if isempty(Parallel(i).CPUnbr)
        Parallel(i).CPUnbr='';
    else
        
        % Format the CPU number.
        if exist('OCTAVE_VERSION')
            aQ=regexp(Parallel(i).CPUnbr,'\[');
            cQ=regexp(Parallel(i).CPUnbr,'\]');
        else
            
            aQ=regexp(Parallel(i).CPUnbr,'[');
            cQ=regexp(Parallel(i).CPUnbr,']');
        end
        
        if (length(aQ) > 1) || (length(cQ)>1)
            ErrorCode=8;
            Reaction=ParallelGlobalErrorHandling(ErrorCode);
            return
        end
        
        if (isempty(aQ) && isempty(cQ))
            sN=str2num(Parallel(i).CPUnbr);
            if (sN==0)
                ErrorCode=8;
                Reaction=ParallelGlobalErrorHandling(ErrorCode);
                return
            end
            Parallel(i).CPUnbr=[0:sN-1];
            
        else
            dP=regexp(Parallel(i).CPUnbr,':');
            if length(dP)~=1
                ErrorCode=8;
                Reaction=ParallelGlobalErrorHandling(ErrorCode);
                return
            end
            
            fN=Parallel(i).CPUnbr(aQ+1:dP-1);
            sN=Parallel(i).CPUnbr(dP+1:cQ-1);
            
            fN=str2num(fN);
            sN=str2num(sN);
            
            if (fN==0) || (fN>sN)
                ErrorCode=8;
                Reaction=ParallelGlobalErrorHandling(ErrorCode);
                return
            else
                Parallel(i).CPUnbr=[fN-1:sN-1];
            end
        end
    end
    lKey06=length('CPUnbr = ');
    
    
    
    % Find Key07.
    Key07Position=[];
    for k=1:nOP
        Key07Position=regexp(NodeBlock,Key07(k).UserName);
        if ~isempty(Key07Position)
            if k==4
                lKey07=lKey07-1;
            end
            break;
        end
    end
    Key07Position(2:end)=[];
    
    if ~isempty(Key07Position)
        StartPoint=max(find(Key07Position>=NodeBlockEndOfLine));
        EndPoint=min(find(Key07Position<=NodeBlockEndOfLine));
        if isempty(EndPoint)
            Parallel(i).UserName=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey07:end);
        else
            Parallel(i).UserName=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey07: NodeBlockEndOfLine(EndPoint)-1);
        end
        % Remove from the string ' ', '\r', '\n', etc.
        Parallel(i).UserName(isspace(Parallel(i).UserName))='';
        Parallel(i).UserName(regexp(Parallel(i).UserName,'\n'))='';
        Parallel(i).UserName(regexp(Parallel(i).UserName,'\r'))='';
    end
    % No string found!
    if isempty(Parallel(i).UserName)
        Parallel(i).UserName='';
    end
    lKey07=length('UserName = ');
    
    
    
    % Find Key08.
    Key08Position=[];
    for k=1:nOP
        Key08Position=regexp(NodeBlock,Key08(k).Password);
        if ~isempty(Key08Position)
            if k==4
                lKey08=lKey08-1;
            end
            break;
        end
    end
    Key08Position(2:end)=[];
    
    if ~isempty(Key08Position)
        StartPoint=max(find(Key08Position>=NodeBlockEndOfLine));
        EndPoint=min(find(Key08Position<=NodeBlockEndOfLine));
        if isempty(EndPoint)
            Parallel(i).Password=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey08:end);
        else
            Parallel(i).Password=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey08: NodeBlockEndOfLine(EndPoint)-1);
        end
        % Remove from the string ' ', '\r', '\n', etc.
        Parallel(i).Password(isspace(Parallel(i).Password))='';
        Parallel(i).Password(regexp(Parallel(i).Password,'\n'))='';
        Parallel(i).Password(regexp(Parallel(i).Password,'\r'))='';
    end
    % No string found!
    if isempty(Parallel(i).Password)
        Parallel(i).Password='';
    end
    lKey08=length('Password = ');
    
    
    
    % Find Key09.
    Key09Position=[];
    for k=1:nOP
        Key09Position=regexp(NodeBlock,Key09(k).RemoteDrive);
        if ~isempty(Key09Position)
            if k==4
                lKey09red=lKey09-1;
            end
            break;
        end
    end
    Key09Position(2:end)=[];
    
    if ~isempty(Key09Position)
        StartPoint=max(find(Key09Position>=NodeBlockEndOfLine));
        EndPoint=min(find(Key09Position<=NodeBlockEndOfLine));
        if isempty(EndPoint)
            Parallel(i).RemoteDrive=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey09:end);
        else
            Parallel(i).RemoteDrive=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey09: NodeBlockEndOfLine(EndPoint)-1);
        end
        % Remove from the string ' ', '\r', '\n', etc.
        Parallel(i).RemoteDrive(isspace(Parallel(i).RemoteDrive))='';
        Parallel(i).RemoteDrive(regexp(Parallel(i).RemoteDrive,'\n'))='';
        Parallel(i).RemoteDrive(regexp(Parallel(i).RemoteDrive,'\r'))='';
    end
    % No string found!
    if isempty(Parallel(i).RemoteDrive)
        Parallel(i).RemoteDrive='';
    end
    lKey09=length('RemoteDrive = ');
    
    
    
    % Find Key10.
    Key10Position=[];
    for k=1:nOP
        Key10Position=regexp(NodeBlock,Key10(k).RemoteDirectory);
        if ~isempty(Key10Position)
            if k==4
                lKey10red=lKey10-1;
            end
            break;
        end
    end
    Key10Position(2:end)=[];
    
    if ~isempty(Key10Position)
        StartPoint=max(find(Key10Position>=NodeBlockEndOfLine));
        EndPoint=min(find(Key10Position<=NodeBlockEndOfLine));
        if isempty(EndPoint)
            Parallel(i).RemoteDirectory=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey10:end);
        else
            Parallel(i).RemoteDirectory=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey10: NodeBlockEndOfLine(EndPoint)-1);
        end
        % Remove from the string ' ', '\r', '\n', etc.
        Parallel(i).RemoteDirectory(isspace(Parallel(i).RemoteDirectory))='';
        Parallel(i).RemoteDirectory(regexp(Parallel(i).RemoteDirectory,'\n'))='';
        Parallel(i).RemoteDirectory(regexp(Parallel(i).RemoteDirectory,'\r'))='';
    end
    
    % No string found!
    if isempty(Parallel(i).RemoteDirectory)
        Parallel(i).RemoteDirectory='';
    end
    lKey10=length('RemoteDirectory = ');
    
    
    
    % Find Key11.
    Key11Position=[];
    for k=1:nOP
        Key11Position=regexp(NodeBlock,Key11(k).ProgramPath);
        if ~isempty(Key11Position)
            if k==4
                lKey11=lKey11-1;
            end
            break;
        end
    end
    Key11Position(2:end)=[];
    
    if ~isempty(Key11Position)
        StartPoint=max(find(Key11Position>=NodeBlockEndOfLine));
        EndPoint=min(find(Key11Position<=NodeBlockEndOfLine));
        if isempty(EndPoint)
            Parallel(i).ProgramPath=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey11:end);
        else
            Parallel(i).ProgramPath=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey11: NodeBlockEndOfLine(EndPoint)-1);
        end
        % Remove from the string ' ', '\r', '\n', etc.
        Parallel(i).ProgramPath(isspace(Parallel(i).ProgramPath))='';
        Parallel(i).ProgramPath(regexp(Parallel(i).ProgramPath,'\n'))='';
        Parallel(i).ProgramPath(regexp(Parallel(i).ProgramPath,'\r'))='';
    end
    % No string found!
    if isempty(Parallel(i).ProgramPath)
        Parallel(i).ProgramPath='';
    end
    lKey11=length('ProgramPath = ');
    
    
    
    % Find Key12.
    Key12Position=[];
    for k=1:nOP
        Key12Position=regexp(NodeBlock,Key12(k).ProgramConfig);
        if ~isempty(Key12Position)
            if k==4
                lKey12=lKey12-1;
            end
            break;
        end
    end
    Key12Position(2:end)=[];
    
    if ~isempty(Key12Position)
        StartPoint=max(find(Key12Position>=NodeBlockEndOfLine));
        EndPoint=min(find(Key12Position<=NodeBlockEndOfLine));
        if isempty(EndPoint)
            Parallel(i).ProgramConfig=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey12:end);
        else
            Parallel(i).ProgramConfig=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey12: NodeBlockEndOfLine(EndPoint)-1);
        end
        % Remove from the string ' ', '\r', '\n', etc.
        Parallel(i).ProgramConfig(isspace(Parallel(i).ProgramConfig))='';
        Parallel(i).ProgramConfig(regexp(Parallel(i).ProgramConfig,'\n'))='';
        Parallel(i).ProgramConfig(regexp(Parallel(i).ProgramConfig,'\r'))='';
    end
    % No string found!
    if isempty(Parallel(i).ProgramConfig)
        Parallel(i).ProgramConfig='';
    end
    lKey12=length('ProgramConfig = ');
    
    
    
    % Find Key13.
    Key13Position=[];
    for k=1:nOP
        Key13Position=regexp(NodeBlock,Key13(k).MatlabOctavePath);
        if ~isempty(Key13Position)
            if k==4
                lKey13=lKey13-1;
            end
            break;
        end
    end
    Key13Position(2:end)=[];
    
    if ~isempty(Key13Position)
        StartPoint=max(find(Key13Position>=NodeBlockEndOfLine));
        EndPoint=min(find(Key13Position<=NodeBlockEndOfLine));
        if isempty(EndPoint)
            Parallel(i).MatlabOctavePath=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey13:end);
        else
            Parallel(i).MatlabOctavePath=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey13: NodeBlockEndOfLine(EndPoint)-1);
        end
        % Remove from the string ' ', '\r', '\n', etc.
        Parallel(i).MatlabOctavePath(isspace(Parallel(i).MatlabOctavePath))='';
        Parallel(i).MatlabOctavePath(regexp(Parallel(i).MatlabOctavePath,'\n'))='';
        Parallel(i).MatlabOctavePath(regexp(Parallel(i).MatlabOctavePath,'\r'))='';
    end
    % No string found!
    if isempty(Parallel(i).MatlabOctavePath)
        Parallel(i).MatlabOctavePath='';
    end
    lKey13=length('MatlabOctavePath = ');
    
    % The field 'MatlabOctavePath' must be contain the string 'octave' or
    % 'matlab'.
    
    strTemp=Parallel(i).MatlabOctavePath;
    
    if isempty(strfind(strTemp,'matlab')) && isempty(strfind(strTemp,'octave'))
        ErrorCode=11;
        Reaction=ParallelGlobalErrorHandling(ErrorCode);
        return
    end
    
    
    
    % Find Key14.
    Key14Position=[];
    for k=1:nOP
        Key14Position=regexp(NodeBlock,Key14(k).OperatingSystem);
        if ~isempty(Key14Position)
            if k==4
                lKey14=lKey14-1;
            end
            break;
        end
    end
    Key14Position(2:end)=[];
    
    if ~isempty(Key14Position)
        StartPoint=max(find(Key14Position>=NodeBlockEndOfLine));
        EndPoint=min(find(Key14Position<=NodeBlockEndOfLine));
        if isempty(EndPoint)
            Parallel(i).OperatingSystem=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey14:end);
        else
            Parallel(i).OperatingSystem=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey14:NodeBlockEndOfLine(EndPoint)-1);
        end
        % Remove from the string ' ', '\r', '\n', etc.
        Parallel(i).OperatingSystem(isspace(Parallel(i).OperatingSystem))='';
        Parallel(i).OperatingSystem(regexp(Parallel(i).OperatingSystem,'\n'))='';
        Parallel(i).OperatingSystem(regexp(Parallel(i).OperatingSystem,'\r'))='';
    end
    % No string found!
    if isempty(Parallel(i).OperatingSystem)
        Parallel(i).OperatingSystem='';
    end
    lKey14=length('OperatingSystem = ');
    
    
    
    % Find Key15.
    Key15Position=[];
    for k=1:nOP
        Key15Position=regexp(NodeBlock,Key15(k).SingleCompThread);
        if ~isempty(Key15Position)
            if k==4
                lKey15=lKey15-1;
            end
            break;
        end
    end
    Key15Position(2:end)=[];
    
    if ~isempty(Key15Position)
        StartPoint=max(find(Key15Position>=NodeBlockEndOfLine));
        EndPoint=min(find(Key15Position<=NodeBlockEndOfLine));
        if isempty(EndPoint)
            Parallel(i).SingleCompThread=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey15:end);
        else
            Parallel(i).SingleCompThread=NodeBlock(NodeBlockEndOfLine(StartPoint)+lKey15: NodeBlockEndOfLine(EndPoint)-1);
        end
        % Remove from the string ' ', '\r', '\n', etc.
        Parallel(i).SingleCompThread(isspace(Parallel(i).SingleCompThread))='';
        Parallel(i).SingleCompThread(regexp(Parallel(i).SingleCompThread,'\n'))='';
        Parallel(i).SingleCompThread(regexp(Parallel(i).SingleCompThread,'\r'))='';
    end
    % No string found!
    if isempty(Parallel(i).SingleCompThread)
        Parallel(i).SingleCompThread='';
    end
    lKey15=length('SingleCompThread = ');
    
    
    
    % Local/Remote
    
    % This variable must have numerical value.
    if  strcmp(Parallel(i).ComputerName,'localhost');
        Parallel(i).Local=1;
    else
        Parallel(i).Local=0;
    end
    
    % The Weight.
    % Node Weight must have char format. This is an error derived from
    % DYNARE!
    Parallel(i).NodeWeight=NodeWeight(i);
    Parallel(i).NodeWeight=num2str(Parallel(i).NodeWeight);
    
    % Clean the string fomn ' ', '\r', '\n', etc.
    Parallel(i).NodeWeight(isspace(Parallel(i).NodeWeight))='';
    Parallel(i).NodeWeight(regexp(Parallel(i).NodeWeight,'\n'))='';
    Parallel(i).NodeWeight(regexp(Parallel(i).NodeWeight,'\r'))='';
    
    
    
    
    % Controls on the Parallel fields mandatory.
    
    % 1. The field Node Name is Mandatory always and it is checked above.
    
    % 2. The field CPUnbr is Mandatory always.
    if isempty(Parallel(i).CPUnbr)
        ErrorCode=5;
        Reaction=ParallelGlobalErrorHandling(ErrorCode);
        return
    end
    
    % 2. The field Computer Name is Mandatory always.
    if (isempty(Parallel(i).ComputerName))
        ErrorCode=6;
        Reaction=ParallelGlobalErrorHandling(ErrorCode);
        return
    end
    
    
    if ~ strcmp(Parallel(i).ComputerName,'localhost')  % Remote computing!
        
        if ispc
            % Windows OS
            if (isempty(Parallel(i).UserName) || isempty(Parallel(i).Password) || ...
                    isempty(Parallel(i).RemoteDrive) || isempty(Parallel(i).RemoteDirectory))
                ErrorCode=7;
                Reaction=ParallelGlobalErrorHandling(ErrorCode);
                return
            end
            
        else
            % Unix OS
            if (isempty(Parallel(i).UserName) || isempty(Parallel(i).RemoteDirectory))
                ErrorCode=9;
                Reaction=ParallelGlobalErrorHandling(ErrorCode);
                return
            end
            
        end
        
    end
    
end

if Visualize==1
    disp(' ');
    disp('Parser Analysis Results:');
    disp(' ');
    for i=1:length(Parallel)
        disp(Parallel(i));
        disp(' ');
    end
end

