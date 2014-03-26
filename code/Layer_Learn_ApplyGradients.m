% Layer_Learn_ApplyGradients  Apply one step of stochastic gradient descent
%
% Syntax:
%   model = Layer_Learn_ApplyGradients(model, params)
% Inputs:
%   model:     struct with the weight matrix and vector parameters
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

function model = Layer_Learn_ApplyGradients(model, params)

% Is the model a SESM?
if (params.is_symmetric)
  model.dL_dD = model.dL_dD + model.dL_dC';
  model.dL_dC = model.dL_dD';
end

% One step of stochastic gradient descent on the parameters of the decoder
model.D = model.D - params.eta_W * model.dL_dD;
model.bias_D = model.bias_D - params.eta_W * model.dL_dbias_D;

% One step of stochastic gradient descent on the parameters of the encoder
model.C = model.C - params.eta_W * model.dL_dC;
model.bias_C = model.bias_C - params.eta_W * model.dL_dbias_C;
