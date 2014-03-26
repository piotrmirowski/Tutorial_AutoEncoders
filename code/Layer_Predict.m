% Layer_Predict  Simple forward propagation through one layer of a stacked
%                auto-encoder, using only predictive coding
%
% Syntax:
%   z_hat = Layer_Predict(model, x, params)
% Inputs:
%   model:     struct with the weight matrix and vector parameters (it can
%              be already initialized or trained, will not be reset)
%   x:         matrix of size <N> x <T> of target "observed" variables
%   params:    parameters struct
% Outputs:
%   a_hat:     matrix of size <M> x <T> of predicted latent code activation

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

function a_hat = Layer_Predict(model, x, params)

% Block size and number of samples
n_samples = size(x, 2);
a_hat = zeros(params.dim_z, n_samples);

% Loop over the samples and perform stochastic gradient descent
tic;
for i = 1:n_samples
  if (mod(i, 1000) == 0)
    Octave_Print(1, '%4d/%4d: (%4.0fs)\n', ...
      i, n_samples, (toc  / i) * (n_samples - i));
  end
  
  % Get the current input sample
  xi = x(:, i);
  % Infer the current latent code using predictive coding
  zi_hat = Module_Encode_FProp(model, xi);
  % Need to apply the sparsifying logistic to get binary activations
  ai_hat = 1 ./ (1 + exp(-model.gain_D * zi_hat));

  % Store the direct PSD latent codes
  a_hat(:, i) = ai_hat;
end
