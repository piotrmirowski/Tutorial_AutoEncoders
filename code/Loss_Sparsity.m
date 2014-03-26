% Loss_Sparsity  Loss term due to latent code sparsity
%
% Syntax:
%   e = Loss_Sparsity(z, a)
% Inputs:
%   z:      vector of latent codes of size <M> x 1
%   a:      vector of latent code activations of size <M> x 1
% Output:
%   e:      sparsity loss term

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

function e = Loss_Sparsity(z, a)

e = sum(log(1 + a.^2));
% e = sum(log(1 + z.^2));
% e = sum(abs(z));
