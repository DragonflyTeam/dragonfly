function [ErrorCode]= DRAGONFLY_Parallel_Block_End(foutEnlarged,varargin)

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


% Copyright (C) 2011-2014 ...
%
% This file is part of DragonFly Team...

% To manage errors.
ErrorCode=0;

% Serial Computation.
if isempty(foutEnlarged)
    return;
end

% Like Serial Computation.

% When the command 'break' is invoked inside the 'for' loop by one slave,
% or there is only one processor (core) involved in parallel computing, we
% have only "one data".

if (length(foutEnlarged.fout)==1)
    for i=1:length(varargin)
        if isfield(foutEnlarged.fout, varargin{i})
            assignin('caller', varargin{i}, foutEnlarged.fout.([varargin{i}]));
        end
    end
    return
end


% (REAL) "Parallel" computation.

% The data returned by slave considered here can be:
% INTEGER,
% VECTORS,
% MATRIX (Partial).

% Furthermore the data returned by slaves can be less than
% CPUforIndex.

% After we have identified the type of data returned by slaves,
% we try to reshape them in accord with user requirements.

if nargin>1
    
    totCPU=foutEnlarged.AddOutInf.totCPU;
%    CPUforIndex=foutEnlarged.AddOutInf.CPUforIndex;
    
    jSlaveData=[];
    
    for i=1:length(varargin)
        if isfield(foutEnlarged.fout, varargin{i})
            
            % We try to determine the nature of data returned by slave.
            % To do this, we use a very simple method: we only analyse the
            % last data in the chain. More sophisticated method can be
            % implemented.
            
            % CUSTOM=0;
            CUSTOM=1;
            
            if CUSTOM ~=0
                DataType=4; % CUSTOM.
                % ReshapedUserData=0;
                ReshapedUserData=[];
                % ReshapedUserData={};
                % ...
                % ReshapedUserData=struct;
            else    
                DataType=-1;
                
                [u v]=size(foutEnlarged.fout(end).([varargin{i}]));
                
                if (u==1) && (v==1)
                    DataType=1;          % Integer or Matrix/Vector of dimension 1.
                    %            If necessary test this condition.
                    ReshapedUserData=0;
                end
                
                if ((u==1) && (v>u)) || ((u>v) && (v==1))
                    DataType=2;          % Array.
                    ReshapedUserData=[];
                end
                
                if (u>1) && (v >1)
                    DataType=3;         % Matrix.
                    % ReshapedUserData=DataTemplate;
                end
                
            end
           
            
            % Collect and reshape data from slaves!
            switch DataType
                       
                case 1 % INTEGERS
                    
                    for j=1:totCPU                        
                        jSlaveData=foutEnlarged.fout(j).([varargin{i}]);
                        ReshapedUserData=ReshapedUserData+jSlaveData;
                    end
                    
                case 2 % VECTORS
                    for j=1:totCPU
                        jSlaveData=foutEnlarged.fout(j).([varargin{i}]);
                        
                        if (strcmp(varargin{i+1},'0')) % Concatenating the Data in Row format
                            ReshapedUserData=[ReshapedUserData;jSlaveData(CPUforIndex(j,1):CPUforIndex(j,2))'];
                            
                        else                           % Concatenating the Data in Colum format.
                            ReshapedUserData=[ReshapedUserData jSlaveData(CPUforIndex(j,1):CPUforIndex(j,2))];
                            
                        end
                    end
                    
                case 3 % MATRIX
                     % TO Do 
                                   
                case 4 % USER CUSTOM
                    
                    % Slaves return less data than requested, or required
                    % data are distribuited in different manner respect
                    % CPUforIndex suddivision. For example in
                    % FindAllPrimeNumbersLessThan.m
                    
                     if (strcmp(varargin{i+1},'0')) % Concatenating the Data in row format
                          ReshapedUserData=[];
                         for j=1:size(foutEnlarged.AddOutInf.totCPU,1)
                            partial=foutEnlarged.fout(j).([varargin{i}]);
                            if (size(partial, 2) > 1)
                                ReshapedUserData=[ReshapedUserData;partial(foutEnlarged.fout(j).startFor:foutEnlarged.fout(j).endFor,:)];
                            else
                                ReshapedUserData=[ReshapedUserData;partial(foutEnlarged.fout(j).startFor:foutEnlarged.fout(j).endFor, 1)];
                            end
                        end
                    else  % Concatenating the Data in Colum format
                         ReshapedUserData=[];
                         for j=1:size(foutEnlarged.AddOutInf.totCPU,1)
                            partial=foutEnlarged.fout(j).([varargin{i}]);
                            if (size(partial, 1) > 1) 
                                ReshapedUserData=[ReshapedUserData partial(foutEnlarged.fout(j).startFor:foutEnlarged.fout(j).endFor,:)];
                            else
                                ReshapedUserData=[ReshapedUserData partial(1,:)];
                            end
                         end
                    end
                    
                otherwise
                    % Some Errors Dccurred!
                    ErrorCode=1;
                    return;
                    
            end
            assignin('caller', varargin{i},ReshapedUserData);
        end
    end
end

