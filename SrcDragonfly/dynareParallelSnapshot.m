function [PRCDirSnapshot]=dynareParallelSnapshot(PRCDir,Parallel)
% PARALLEL CONTEXT
% In a parallel context, this simply record the directory's files at time
% 't0'.
%
%
% INPUTS
%  o PRCDir       []   ...
%  o Parallel     []   ...
%
%
%  OUTPUTS
%  o PRCDirSnapshot       []   ...
%
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

PRCDirSnapshot={};

for indPC=1:length(Parallel),
    if Parallel(indPC).Local==0;
                                                       % The first call ...
        PRCDirSnapshot{indPC}=dynareParallelListAllFiles('Root',PRCDir,Parallel(indPC));
        
    end
end
