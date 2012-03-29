function [] = ParallelClear()

% PARALLEL CONTEXT
% In a parallel context, this function is used to reset all!
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


rmpath([Parallel_info.parallelroot,filesep,'exit_from_parallel']);

Parallel=[];
Parallel_info=[];

disp(' ');
disp('All data are DELETED!');
disp(' ');
disp('To use parallel routines, it is necessary to (re)run ParallelConfiguration!');
disp(' ');
