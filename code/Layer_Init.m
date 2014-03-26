% Layer_Init  Initialize model for the current layer
%
% Syntax:
%   model = Layer_Init(params)
% Inputs:
%   params:    parameters struct
% Outputs:
%   model:     model struct

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

function model = Layer_Init(params)

model = struct('D', [], 'bias_D', [], 'gain_D', [], ... % Decoder weights
  'C', [], 'bias_C', [], ...                            % Encoder weights
  'dL_dD', [], 'dL_dbias_D', [], ...      % Decoder weights gradient
  'dL_dC', [], 'dL_dbias_C', []);         % Encoder weights gradient

% Initialize the decoder weights using small random values
model.D = randn(params.dim_x, params.dim_z) / params.dim_z;
model.D = Util_NormalizeColumns(model.D);
model.bias_D = zeros(params.dim_x, 1);
model.gain_D = params.gain_D;

% Initialize the gradients to the decoder
model.dL_dD = zeros(size(model.D));
model.dL_dbias_D = zeros(size(model.bias_D));

% Initialize the encoder weights as transpose of the decoder
model.C = randn(params.dim_z, params.dim_x) / params.dim_x;
model.bias_C = zeros(params.dim_z, 1);

% Is the model a Sparse Encoding Symmetric Machine? (SESM)
if (params.is_symmetric)
  model.C = model.D';
end

% Initialize the gradients to the encoder
model.dL_dC = zeros(size(model.C));
model.dL_dbias_C = zeros(size(model.bias_C));
