% Module_Decode_BackProp_Codes  Differentiate the decoder w.r.t. codes
%
% Syntax:
%   dL_dz = Module_Decode_BackProp_Codes(model, dL_dx, a_hat, params)
% Inputs:
%   model:  struct with the weight matrix and vector parameters
%   dL_dx:  vector of size <N> x 1 of gradients w.r.t. observed inputs
%   a_hat:  vector of size <M> x 1 of activations of latent codes
%   params: struct with the parameters of the model and optimization
% Outputs:
%   x:           matrix of size <N> x <T> of generated "observed" variables

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

function dL_dz = Module_Decode_BackProp_Codes(model, dL_dx, a_hat)

% Gradient of the loss w.r.t. activations
dL_da = model.D' * dL_dx;
% Gradient of the loss w.r.t. latent codes
dL_dz = dL_da .* a_hat .* (1 - a_hat) * model.gain_D;
