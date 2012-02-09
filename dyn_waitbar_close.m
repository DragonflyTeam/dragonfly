function dyn_waitbar_close(h)
% h = dyn_waitbar_close(h)
% adaptive close waitbar, compatible with 
% octave and when console_mode=1

%
% Copyright (C) 2011 Dynare Team
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
global options_

if exist('OCTAVE_VERSION') || options_.console_mode,
    clear dyn_waitbar;
    diary on,
    fprintf('\n');
else
    close(h),
end

clear dyn_waitbar;


