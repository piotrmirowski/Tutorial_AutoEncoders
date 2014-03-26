% Octave_Print  Print a string to a file identifier (screen) and flush
%
% Syntax:
%   Octave_Print(fid, str, varargin)
% Inputs:
%   fid:      file identifider (1 for standard output on screen)
%   str:      string with format (see fprintf)
%   varargin: additional arguments, separated by commas (see fprintf)

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

function Octave_Print(fid, str, varargin)

% Call fprintf
switch (length(varargin))
  case 0
    fprintf(fid, str);
  case 1
    fprintf(fid, str, varargin{1});
  case 2
    fprintf(fid, str, varargin{1}, varargin{2});
  case 3
    fprintf(fid, str, varargin{1}, varargin{2}, varargin{3});
  case 4
    fprintf(fid, str, varargin{1}, varargin{2}, varargin{3}, varargin{4});
  case 5
    fprintf(fid, str, varargin{1}, varargin{2}, varargin{3}, ...
      varargin{4}, varargin{5});
  case 6
    fprintf(fid, str, varargin{1}, varargin{2}, varargin{3}, ...
      varargin{4}, varargin{5}, varargin{6});
  case 7
    fprintf(fid, str, varargin{1}, varargin{2}, varargin{3}, ...
      varargin{4}, varargin{5}, varargin{6}, varargin{7});
  case 8
    fprintf(fid, str, varargin{1}, varargin{2}, varargin{3}, ...
      varargin{4}, varargin{5}, varargin{6}, varargin{7}, varargin{8});
  case 9
    fprintf(fid, str, varargin{1}, varargin{2}, varargin{3}, ...
      varargin{4}, varargin{5}, varargin{6}, varargin{7}, varargin{8}, ...
      varargin{9});
  case 10
    fprintf(fid, str, varargin{1}, varargin{2}, varargin{3}, ...
      varargin{4}, varargin{5}, varargin{6}, varargin{7}, varargin{8}, ...
      varargin{9}, varargin{10});
  otherwise
    error('Not implemented...');
end

if (Octave_IsOctave)
  % Octave flush
  more off;
  fflush(fid);
end
