% Syntax:
%   model = ...
%     Module_Encode_BackProp_Weights(model, x, dL_dz, params)
% Inputs:
%   model:     struct with the weight matrix and vector parameters
%   z_star:    vector of size <M> x 1 of optimal latent codes
%   z_hat:     vector of size <M> x 1 of directly encoded latent codes
%   x:         vector of size <N> x 1 of input "observed" variables
%   params:    parameters struct
% Outputs:
%   model:     struct with the weight matrix and vector parameters,
%              with weights W and bias_C updated through SGD

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
  Module_Encode_BackProp_Weights(model, z_star, z_hat, x, params)

% Derivative of the encoding term in loss w.r.t. latent codes
dL_dz = z_hat - z_star;
% Jacobian of the encoding term in loss w.r.t. encoding weight matrix
dL_dC = dL_dz * x';
% Derivative of the encoding term in loss w.r.t. encoding bias
dL_dbias_C = dL_dz;

if (params.mu_W > 0)
  % Add the momentum term (using previous gradients)
  dL_dC = dL_dC + params.mu_W * model.dL_dC;
  dL_dbias_C = dL_dbias_C + params.mu_W * model.dL_dbias_C;
end

% Add the L1-norm regularization term (penalty on existing weights)
dL_dC = dL_dC + params.lambda_W * sign(model.C);
dL_dbias_C = dL_dbias_C + params.lambda_W * sign(model.bias_C);

% Store the updated gradients
model.dL_dC = dL_dC;
model.dL_dbias_C = dL_dbias_C;
