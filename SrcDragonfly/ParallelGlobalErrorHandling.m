function [Reaction] = ParallelGlobalErrorHandling(ErrorCode)

% FUNCTION DESCRIPTION
% ...

% INPUTS
% o   ErrorCode [Integer]        Identify a specific error. This is an
%                                absolute value, i.e. during the parallel
%                                code execution any error is identify
%                                by a unique integer value
%
%
% OUTPUT
% o   Reaction []                A program error reaction, when necessary.

Reaction=0;

switch ErrorCode
    
    case 0
        disp(' ');
        disp('Unknow Parser Error in Cluster configuration file!');
        disp('Please inform us of this kind of errror!');
        disp(' ');
        
    case 1
        disp(' ');
        disp('Error in Cluster configuration file!');
        disp('Please type, for example, the following text:');
        disp(' ');
        disp('[cluster]');
        disp('Name = Jaguar');
        disp('Members = ni(xi) nj(xj) ... ');
        disp(' ');
        disp('[node]');
        disp('Name = ni(xi)');
        disp(' ... ');
        disp('Name = nj(xj)');
        disp(' ... ');
        disp(' ');
        
    case 2
        disp(' ');
        disp('Error in Cluster configuration file!');
        disp('Cluster Name Not Found!');
        disp(' ');
        disp('The Variable Cluster Name in ParallelParser function,');
        disp('must be defined in a Configuration File!');
        disp(' ');
        
    case 3
        disp(' ');
        disp('Error in Cluster configuration file!');
        disp('Node Name Not Found!');
        disp(' ');
        disp('The Node Name, must be placed ');
        disp('in Cluster but and also Nodes definition!');
        disp(' ');
        
    case 4
        disp(' ');
        disp('Error in Cluster configuration file!');
        disp('Error in Members Weight');
        disp(' ');
        disp('Please type, for example: ');
        disp('n n2 n3 n4');
        disp('or');
        disp('n(3) n2(2) n3(1) n4(2)');
        disp(' ');
        
    case 5
        disp(' ');
        disp('Error in Cluster configuration file!');
        disp(' ');
        disp('The field CPUnbr is Mandatory!');
        disp(' ');
        
    case 6
        disp(' ');
        disp('Error in Cluster configuration file!');
        disp(' ');
        disp('The field ComputerName is Mandatory!');
        disp(' ');
        
    case 7
        disp(' ');
        disp('Error in Cluster configuration file!');
        disp(' ');
        disp('Some fields Mandatory for Windows OS are missing!');
        disp('Please check the fields: UserName, Password, RemoteDrive and RemoteDirectory!');
        disp(' ');
        
    case 8
        disp(' ');
        disp('Error in Cluster configuration file!');
        disp('Error in CPU Numbers');
        disp(' ');
        disp('Please type, for example: ');
        disp('n (n>0)');
        disp('or');
        disp('[m:n] (m<n)');
        disp(' ');
        
    case 9
        disp(' ');
        disp('Error in Cluster configuration file!');
        disp(' ');
        disp('Some fields Mandatory for Like Unix OS are missing!');
        disp('Please check the fields: UserName, and RemoteDirectory!');
        disp(' ');
        
    case 10
        disp(' ');
        disp('Generic Error!');
        disp(' ');
        disp('Error opening Cluster Configuration File!');
        disp('Probably the file Name/Path do not exist!');
        disp(' ');
        
    case 11
        disp(' ');
        disp('Error in MatlabOctavePath field!');
        disp(' ');
        disp('This fiel must be containt the string "matlab" or "octave"?!');
        disp('Please check it!');
        disp(' ');
end
