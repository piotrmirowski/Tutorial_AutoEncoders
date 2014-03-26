% Util_NormalizeColumns  Normalize a matrix to unit L2 norm columnwise
%
% Syntax:
%   W = Util_NormalizeColumns(W)
% Inputs:
%   W: matrix of size <M> x <N> of some parameter weights
% Outputs:
%   W: matrix of size <M> x <N> where each column's L2 norm is 1

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

function W = Util_NormalizeColumns(W)

% Normalize the weights of the matrix
normW = sqrt(sum(W .^ 2));
n_rows = size(W, 1);
W = W ./ repmat(normW, n_rows, 1);
