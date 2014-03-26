% Module_Decode_FProp  Generate an encoding of observed variables
%
% Syntax:
%   [x_hat, a_hat] = Module_Decode_FProp(model, z)
% Inputs:
%   model:  struct with the weight matrix and vector parameters
%   z:      vector of size <M> x 1 of latent codes
% Outputs:
%   x_hat:  vector of size <N> x 1 of reconstructed "observable" variables
%   a_hat:  vector of size <N> x 1 of activations (before nonlinearity)

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

function [x_hat, a_hat] = Module_Decode_FProp(model, z)

% Apply the logistic to the code
a_hat = 1 ./ (1 + exp(-model.gain_D * z));
% Linear decoding
x_hat = model.D * a_hat + model.bias_D;
