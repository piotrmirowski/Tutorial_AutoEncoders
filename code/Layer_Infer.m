% Layer_Infer  Infer latent code and reconstruct the inputs given the model
%
% Syntax:
%   [z_star, z_hat, loss_star, loss_hat] = Layer_Infer(model, x, z, params)
% Inputs:
%   model:  struct with the weight matrix and vector parameters
%   x:      vector of size <N> x 1 of target "observed" variables
%   params: parameters struct
% Outputs:
%   z_star: vector of size <M> x 1 of inferred latent codes
%   z_hat:  vector of size <M> x 1 of directly encoded latent codes
%   loss_star: total loss of the optimal latent code
%   loss_hat:  total loss of the predicted sparse latent code

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

function [z_star, z_hat, loss_star, loss_hat] = Layer_Infer(model, x, params)

% Encode the current input variable to initialize the latent code
% thanks to predictive sparse coding
z_hat = Module_Encode_FProp(model, x);
% Decode the current latent code to get the observed variable prediction
[x_hat, a_hat] = Module_Decode_FProp(model, z_hat);

% Compute the current loss term due to decoding
% The loss term due to encoding is 0
% Add the term due to code sparsity
loss_hat = Loss_Gaussian(x, x_hat) + ...
  params.alpha_s * Loss_Sparsity(z_hat, a_hat);

% Relaxation on the latent code: loop until convergence
x_star = x_hat; a_star = a_hat; z_star = z_hat; loss_star = loss_hat;
n_steps = 0;
while (true)
  % Store the previous latent codes, activations and reconstructions
  z_prev = z_star; loss_prev = loss_star;

  % Gradient of the loss function w.r.t. decoder predictions
  dL_dx_star = x_star - x;
  % Back-propagate the gradient of the loss onto the codes
  dL_dz = Module_Decode_BackProp_Codes(model, dL_dx_star, a_star);
  % Add the gradient w.r.t. the encoder's outputs
  dL_dz = dL_dz + params.alpha_c * (z_star - z_hat);
  % Add the L1-norm regularization to enforce code sparsity
  dL_dz_s = ...
    2 * model.gain_D * a_star.^2 ./ (1 + a_star.^2) .* (1 - a_star.^2);
  dL_dz = dL_dz + params.alpha_s * dL_dz_s;
  % Perform one step of gradient descent on the codes
  z_star = z_star - params.eta_z * dL_dz;

  % Decode the current latent code to get the observed variable prediction
  [x_star, a_star] = Module_Decode_FProp(model, z_star);

  % Compute the current loss terms due to decoding and to encoding,
  % with a term due to code sparsity
  loss_star = Loss_Gaussian(x, x_star) + ...
    params.alpha_c * Loss_Gaussian(z_star, z_hat) + ...
    params.alpha_s * Loss_Sparsity(z_star, a_star);

  % Compute the convergence criteria
  % 1) error increase...
  if (loss_star > loss_prev)
    % Recover previous values and exit the loop
    z_star = z_prev;
    break;
  end
  % 2) ... or early stopping
  n_steps = n_steps + 1;
  if (n_steps > params.n_steps_relax)
    break;
  end
end

if (params.trace_estep)
  Octave_Print(1, ' [E] dec %6.4f->%6.4f (%2d)', loss_hat, loss_star, n_steps);
end
