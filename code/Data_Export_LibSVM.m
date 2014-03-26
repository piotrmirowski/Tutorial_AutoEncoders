% Data_Export_LibSVM  Export a labeled dataset into LibSVM format
%
% Syntax:
%   Data_Export_LibSVM(filename, x, y)
% Inputs:
%   filename: filename of the text file that will be generated
%   x:        matrix of size <N> x <T> of data
%   y:        vector of length <T> of labels

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

function Data_Export_LibSVM(filename, x, y)

fid = fopen(filename, 'w');
n_samples = length(y);
for k = 1:n_samples
  fprintf(fid, '%d', y(k));
  ind = find(x(:, k));
  for j = ind'
    fprintf(fid, ' %d:%f', j, x(j, k));
  end
  fprintf(fid, '\n');
  if (mod(k, 1000) == 0)
    fprintf(1, 'Exported %d/%d lines\n', k, n_samples);
  end
end
fclose(fid);
