% Display_Reconstruction  Plot one example of input curve/image decoding
%
% Syntax:
%   Display_Reconstruction(xi, xi_star, xi_hat, meters, params)
% Inputs:
%   xi:      matrix of size <N> x <T> of "observed" variables
%   xi_star: matrix of size <N> x <T> of optimal reconstructed inputs
%   xi_hat:  matrix of size <N> x <T> of directly reconstructed inputs
%   meters:  struct with the decoder and encoder energy vectors
%   params:  parameters struct

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

function Display_Reconstruction(xi, xi_star, xi_hat, meters, params)

figure(3);
clf;
hold on;
n_samples = size(xi, 2);

if (length(params.x_dims) == 1)

  % Plot the 1D curves of input and reconstructed input
  if (n_samples == 1)
    plot(xi, 'b-');
    plot(xi_star, 'r-');
    plot(xi_hat, 'g-');
  else
    plot(xi, '-');
    plot(xi_star, '.');
    plot(xi_hat, ':');
  end
  legend('Input', 'Optimal SD decoding', 'Direct PSD decoding');
  set(gca, 'XTick', params.x_feature_ticks, ...
    'XTickLabel', params.x_feature_labels);
  title(sprintf('Example of input variable reconstruction, %d SGD iter', ...
    meters.n_iter));
else

  % Display the 2D images of input and reconstructed input
  sep_hor = zeros(1, 3 * params.x_dims(2) + 2);
  sep_ver = zeros(params.x_dims(1), 1);
  im = sep_hor;
  for k = 1:n_samples
    im_k = reshape(xi(:, k), params.x_dims);
    im_star_k = reshape(xi_star(:, k), params.x_dims);
    im_hat_k = reshape(xi_hat(:, k), params.x_dims);
    % Hacky correction for MNIST images (invert X and Y axes)
    if (isequal(params.x_dims, [28 28]))
      im_k = im_k';
      im_star_k = im_star_k';
      im_hat_k = im_hat_k';
    end
    ims_k = [im_k sep_ver im_star_k sep_ver im_hat_k];
    im = [im; ims_k; sep_hor];
  end
  imagesc(im(end:(-1):1, :));
  axis equal;
  set(gca, 'XTick', (params.x_dims(2) + 1) * (0:3));
  set(gca, 'YTick', [], 'XTickLabel', {});
  str = sprintf('Example of input variable reconstruction, %d SGD iter', ...
    meters.n_iter);
  str = sprintf('%s\nInput, optimal decoding, direct PSD decoding', str);
  title(str);
  colormap(params.colormap);
end

% Save the figure to a PNG image
grid on;
filename_fig = strrep(params.filename, '.mat', '');
filename_fig = sprintf('%s_SGD_%d_x.png', filename_fig, meters.n_iter);
Octave_SaveAs(gcf, filename_fig);
