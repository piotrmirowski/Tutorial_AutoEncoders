% Octave_IsOctave  Determine if we are running Octave (2009 or later)
%
% Syntax:
%   res = Octave_IsOctave()
% Outputs:
%   res: boolean answer

% Copyright 2014, Piotr Mirowski
%                 piotr.mirowski@computer.org
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function res = Octave_IsOctave()

global IS_OCTAVE

if isempty(IS_OCTAVE)
  try
    temp = ver;
    res = isequal(temp(1).Name, 'Octave');
  catch
    res = 0;
  end
  IS_OCTAVE = res;
else
  res = IS_OCTAVE;
end
