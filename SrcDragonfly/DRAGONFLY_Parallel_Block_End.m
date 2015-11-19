function DRAGONFLY_Parallel_Block_End(foutEnlarged,varargin);

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


% Serial Computation ...
if isempty(foutEnlarged)
    return;
end

% Output data concatenation (reshape) ...
% varargin
if nargin>1
        for i=1:length(varargin)
            if isfield(foutEnlarged.fout, varargin{i})
                if (strcmp(varargin{i+1},'0')) % Concatenating the Data in row format
                    vTempGlo=[];
                    for j=1:foutEnlarged.AddOutInf.totCPU
                         vTempGlo=[vTempGlo;foutEnlarged.fout(j).([varargin{i}])];
                    end
                else  % Concatenating the Data in Colum format
                    vTempGlo=[];
                   for j=1:foutEnlarged.AddOutInf.totCPU
                        vTempGlo=[vTempGlo foutEnlarged.fout(j).([varargin{i}])];
                   end
                end
                    assignin('caller', varargin{i}, vTempGlo);
            end
        end
end
