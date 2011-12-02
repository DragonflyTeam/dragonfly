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
        display(' ');
        display('Unknow Parser Error in Cluster configuration file!');
        display('Please inform us of this kind of errror!');
        display(' ');
        
    case 1
        display(' ');
        display('Error in Cluster configuration file!');
        display('Please type, for example, the following text:');
        display(' ');
        display('[cluster]');
        display('Name = Jaguar');
        display('Members = ni(xi) nj(xj) ... ');
        display(' ');
        display('[node]');
        display('Name = ni(xi)');
        display(' ... ');
        display('Name = nj(xj)');
        display(' ... ');
        display(' ');
        
    case 2
        display(' ');
        display('Error in Cluster configuration file!');
        display('Cluster Name Not Found!');
        display(' ');
        display('The Variable Cluster Name in ParallelParser function,');
        display('must be defined in a Configuration File!');
        display(' ');
        
    case 3
        display(' ');
        display('Error in Cluster configuration file!');
        display('Node Name Not Found!');
        display(' ');
        display('The Node Name, must be placed ');
        display('in Cluster but and also Nodes definition!');
        display(' ');
        
    case 4
        display(' ');
        display('Error in Cluster configuration file!');
        display('Error in Members Weight');
        display(' ');
        display('Please type, for example: ');
        display('n n2 n3 n4');
        display('or');
        display('n(3) n2(2) n3(1) n4(2)');
        display(' ');
        
    case 5
        display(' ');
        display('Error in Cluster configuration file!');
        display(' ');
        display('The field CPUnbr is Mandatory!');
        display(' ');
        
    case 6
        display(' ');
        display('Error in Cluster configuration file!');
        display(' ');
        display('The field ComputerName is Mandatory!');
        display(' ');
        
    case 7
        display(' ');
        display('Error in Cluster configuration file!');
        display(' ');
        display('Some fields Mandatory for Windows OS are missing!');
        display('Please check the fields: UserName, Password, RemoteDrive and RemoteDirectory!');
        display(' ');
        
    case 8
        display(' ');
        display('Error in Cluster configuration file!');
        display('Error in CPU Numbers');
        display(' ');
        display('Please type, for example: ');
        display('n (n>0)');
        display('or');
        display('[1:n]');
        display(' ');
        
    case 9
        display(' ');
        display('Error in Cluster configuration file!');
        display(' ');
        display('Some fields Mandatory for Like Unix OS are missing!');
        display('Please check the fields: UserName, and RemoteDirectory!');
        display(' ');
end
