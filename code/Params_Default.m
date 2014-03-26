% Params_Default  Initialize default hyperparameters
%
% Syntax:
%   params = Params_Default(dim_x, dim_z)
% Inputs:
%   dim_x: optional number of dimensions of x variables, by default 784
%   dim_z: optional number of dimensions of latent codes z, by default 196
% Outputs:
%   params: parameters struct

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

function params = Params_Default(dim_x, dim_z)

% By default, we assume 784-dim inputs (MNIST image vectors) and 192 codes
% (first layer of the auto-encoder)
if (nargin < 1)
  dim_x = 784;
end
if (nargin < 2)
  dim_z = 192;
end

params = struct(...
  ... % General
  'n_epochs', 2, ...
  ... % Architecture
  'dim_x', dim_x, ...       % Number of dimensions in input variables
  'dim_z', dim_z, ...       % Number of dimensions in hidden codes
  'gain_D', 7, ...          % Gain in the decoder nonlinearity
  'is_symmetric', true, ... % Sparse Encoding Symmetric Machine (SESM)?
  ... % E-step (relaxation of latent codes)
  'eta_z', 0.1, ...         % Learning rate for the sparse coding
  'n_steps_relax', 10, ...
  'alpha_c', 1, ...         % Weight of the encoder term in the loss
  'alpha_s', 0.2, ...       % Weight of the code sparsity term in the loss
  ... % M-step (learning of model parameters)
  'eta_W', 0.025, ...       % Learning rate for the SGD on decoder weights
  'mu_W', 0, ...            % Momentum during SGD on decoder weights
  'lambda_W', 0.0004, ...   % Regularization during SGD on decoder weights
  'eta_W_decay', 0.99, ...  % Exponentail learning rate decay
  'n_steps_decay', 1000, ... % How often do we decay the learning rate?
  ... % Display
  'x_feature_ticks', [], 'x_feature_labels', [], ...
  'x_dims', [28 28], ...    % The 784-dim input vectors are 28x28 images 
  'display_n_rows', 12, ... % The 192 codes are display in 12 rows, 16 cols
  'display_n_cols', 16, ... % The 192 codes are display in 12 rows, 16 cols
  'colormap', 'gray', ...
  'trace_estep', true, ...
  'trace_mstep', true, ...
  'n_steps_display', 10000, ...
  'n_steps_save', 10000);
params.time_begin = now;
params.filename = ...
  ['PSD_' datestr(params.time_begin, 'yyyymmdd_HHMMSS') '.mat'];
