% Module_Encode_FProp  Generate an encoding of observed variables
%
% Syntax:
%   z_hat = Module_Encode_FProp(layer, x)
% Inputs:
%   model:       struct with the weight matrix and vector parameters
%   x:           matrix of size <N> x <T> of "observed" input variables
% Outputs:
%   z_hat:      matrix of size <M> x <T> of latent codes

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

function z_hat = Module_Encode_FProp(model, x)

% Compute the linear encoding activation
z_hat = model.C * x + model.bias_C;
