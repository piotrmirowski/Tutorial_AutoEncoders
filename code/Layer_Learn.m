% Layer_Learn  Unsupervised training of one layer of a stacked auto-encoder
%
% Syntax:
%   [model, meters] = Layer_Learn(model, x, params)
% Inputs:
%   model:     struct with the weight matrix and vector parameters (it can
%              be already initialized or trained, will not be reset)
%   x:         matrix of size <N> x <T> of target "observed" variables
%   params:    parameters struct
% Outputs:
%   model:     struct with the learnt weight matrix and vector parameters
%   meters:    struct with the meter vectors (errors, sparsity)
%   z_star:    matrix of size <M> x <T> of inferred latent codes
%   x_star:    matrix of size <N> x <T> of reconstructed input variables

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

function [model, meters] = Layer_Learn(model, x, params)

% Block size and number of samples
n_samples = size(x, 2);
n_epochs = params.n_epochs;

% Initialize the meters
meters = Loss_Store();
e_epoch_prev = inf;

% Loop over multiple epochs
for epoch = 1:n_epochs
  tic;

  % Create an order of samples
  order = randperm(n_samples);

  % Loop over the samples and perform stochastic gradient descent
  for i = 1:n_samples
    Octave_Print(1, 'Epoch %2d, %4d/%4d: (%4.0fs)', ...
      epoch, i, n_samples, (toc  / i) * (n_samples - i));

    % Get the current input sample
    indi = order(i);
    xi = x(:, indi);

    % Infer the current latent code and loss values (optimal and PSD)
    [zi_star, zi_hat, loss_star_i, loss_hat_i] = ...
      Layer_Infer(model, xi, params);

    % Decode the latent code to get observed variable and code activations
    [xi_star, ai_star] = Module_Decode_FProp(model, zi_star);
    % Compute the gradient of the optimal loss w.r.t. decoder
    % and back-propagate it to the weights
    model = ...
      Module_Decode_BackProp_Weights(model, xi, xi_star, ai_star, params);

    % Compute the gradient of the optimal loss w.r.t. encoder
    % and back-propagate it to the weights
    model = ...
      Module_Encode_BackProp_Weights(model, zi_star, zi_hat, xi, params);

    % Perform one step of SGD on the decoder and on the encoder
    model = Layer_Learn_ApplyGradients(model, params);

    if (mod(i, params.n_steps_display) == 0)
      % Learning rate decay
      params.eta_W = params.eta_W * params.eta_W_decay;
    end
    
    % Note down the current loss values
    meters = Loss_Store(meters, loss_star_i, loss_hat_i);
    Octave_Print(1, '\n');

    if (mod(i, params.n_steps_display) == 0)
      % Display the meters
      Display_Meters(meters, params);
      % Display the codes
      Display_Model(model, params, meters);
      % Display the current reconstruction
      % First, decode the PSD latent code to get observed variable
      xi_hat = Module_Decode_FProp(model, zi_hat);
      Display_Reconstruction(xi, xi_star, xi_hat, meters, params);
    end

    % Save the model
    if (mod(i, params.n_steps_save) == 0)
      save(params.filename, 'model', 'meters', 'params');
    end
  end
  
  % Average energy of the PSD encoder, over the last epoch
  e_epoch = mean(meters.loss_psd(meters.n_iter - (0:(n_samples-1))));
  % Early stopping
  if (e_epoch > 0.95 * e_epoch_prev)
    return;
  end
  e_epoch_prev = e_epoch;
end
