% Syntax:
%   model = ...
%     Module_Decode_BackProp_Weights(model, x, x_star, a_star, params)
% Inputs:
%   model:     struct with the weight matrix and vector parameters
%   x:         vector of size <M> x 1 of target "observed" variables
%   x_star:    vector of size <M> x 1 of reconstructed input variables
%   a_star:    vector of size <N> x 1 of latent code activations
%   params:    parameters struct
% Outputs:
%   model:     struct with the weight matrix and vector parameters,
%              with weights B and bias_B updated through SGD

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

function model = ...
  Module_Decode_BackProp_Weights(model, x, x_star, a_star, params)

% Gradient of the reconstruction term in loss w.r.t. predictions
dL_dx_star = x_star - x;
% Jacobian of the reconstruction term in loss w.r.t. decoding weight matrix
dL_dD = dL_dx_star * a_star';
% Derivative of the reconstruction term in loss w.r.t. decoding bias
dL_dbias_D = dL_dx_star;

if (params.mu_W > 0)
  % Add the momentum term (using previous gradients)
  dL_dD = dL_dD + params.mu_W * model.dL_dD;
  dL_dbias_D = dL_dbias_D + params.mu_W * model.dL_dbias_D;
end

% Add the L1-norm regularization term (penalty on existing weights)
dL_dD = dL_dD + params.lambda_W * sign(model.D);
dL_dbias_D = dL_dbias_D + params.lambda_W * sign(model.bias_D);

% Store the new gradients
model.dL_dD = dL_dD;
model.dL_dbias_D = dL_dbias_D;
