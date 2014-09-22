function [] = ParallelMapRemoteDrive(fname)

% PARALLEL CONTEXT
% In a parallel context, this function is used to
% send data remotely!
%
% INPUTS
% [ ... ]
%
% OUTPUTS
% [ ... ]
%
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


global  Parallel Parallel_info

if isempty(Parallel) || isempty(Parallel_info)
    disp(' ');
    disp('First rum Parallel Configuration ...');
    disp(' ');
    return;
end

if nargin ==0 || isempty(fname)
    fname='*.m';
end

for i=1:length(Parallel)
    if (Parallel(i).Local==0)
        if (Parallel_info.RemoteTmpFolder)
            dynareParallelSendFiles(fname,Parallel_info.RemoteTmpFolder,Parallel);
            disp(' ');
            disp(['Mapping of Remote Drive files ',fname,' on ', Parallel(i).ComputerName, ' Macchine ok!']);
            disp(' ');
        end
    end
end

