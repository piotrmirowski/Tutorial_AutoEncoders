% Octave_SaveAs  Save a figure to an image given filename (Octave-proof)
%
% Syntax:
%   Octave_SaveAs(f, filename)
% Inputs:
%   f:        figure ID
%   filename: string with filename

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

function Octave_SaveAs(f, filename)

if (Octave_IsOctave)
  print(f, filename);
else
  saveas(f, filename);
end

