% Loss_Store  Store the loss values from the last iteration
%
% Syntax:
%   meters = Loss_Store(meters, loss_optimal, loss_psd)
% Inputs:
%   meters:       struct with the decoder and encoder energy vectors
%   loss_optimal: current total loss using optimal sparse coding
%   loss_psd:     current total loss using PSD-encoded latent codes
% Outputs:
%   meters:       struct with the decoder and encoder energy vectors

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

function meters = Loss_Store(meters, loss_optimal, loss_psd)

if (nargin < 1)
  % Initialize the meters
  n_max = 100000;
  meters = ...
    struct('loss_optimal', [], 'loss_psd', [], 'n_iter', 0, 'n_max', n_max);
  meters.loss_optimal = zeros(1, n_max);
  meters.loss_psd = zeros(1, n_max);
else
  % Increase the size if needed
  if (meters.n_max <= meters.n_iter)
    meters.loss_optimal = [meters.loss_optimal zeros(1, 100000)];
    meters.loss_psd = [meters.loss_psd zeros(1, 100000)];
    meters.n_max = length(meters.loss_optimal);
  end
  % Store the energies
  n_iter = meters.n_iter + 1;
  meters.loss_optimal(n_iter) = loss_optimal;
  meters.loss_psd(n_iter) = loss_psd;
  meters.n_iter = n_iter;
end
