% Loss_Gaussian  Energy of the Gaussian regressor
%
% Syntax:
%   e = Loss_Gaussian(x, x_star)
% Inputs:
%   x:      vector of target observations of size <M> x 1
%   x_star: vector of generated observations of size <M> x 1
% Output:
%   eR:     energy of the Gaussian regressor

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

function e = Loss_Gaussian(x, x_star)

xDiff = x - x_star;
e = 0.5 * sum(xDiff.^2);
