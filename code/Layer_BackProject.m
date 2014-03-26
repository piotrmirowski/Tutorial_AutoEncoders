% Layer_BackProject  Simple backward propagation through one layer of a
%                    stacked auto-encoder, using decoding
%
% Syntax:
%   x_hat = Layer_BackProject(model, a, params)
% Inputs:
%   model:     struct with the weight matrix and vector parameters (it can
%              be already initialized or trained, will not be reset)
%   a:         matrix of size <N> x <T> of output code activations
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

function x_hat = Layer_BackProject(model, a, params)

% Block size and number of samples
n_samples = size(a, 2);
x_hat = zeros(params.dim_x, n_samples);

% Loop over the samples and perform stochastic gradient descent
tic;
for i = 1:n_samples
  if (mod(i, 1000) == 0)
    Octave_Print(1, '%4d/%4d: (%4.0fs)\n', ...
      i, n_samples, (toc  / i) * (n_samples - i));
  end
  
  % Get the current output code activation sample
  ai = a(:, i);
  % Apply nonlinearity to the activation by removing the sigmoid
  ai = max(min(ai, 1 - (1e-8)), 1e-8);
  zi = -1 / model.gain_D * log(1 ./ ai - 1);
  % Infer the current latent code using predictive coding
  xi_hat = Module_Decode_FProp(model, zi);

  % Store the direct PSD latent codes
  x_hat(:, i) = xi_hat;
end
