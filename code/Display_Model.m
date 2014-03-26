% Display_Model  Plot the decoder weights curves/images for each code unit
%
% Syntax:
%   Display_Model(model, params, meters)
% Inputs:
%   model:       struct with the weight matrix and vector parameters
%   params:      struct with the parameters
%   meters:    struct with the decoder and encoder energy vectors

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

function Display_Model(model, params, meters)

figure(2);
clf;

if (length(params.x_dims) == 1)

  % Simply plot a matrix of codes vs. features
  imagesc(model.D);
  xlabel('Latent codes');
  ylabel('Input features');
else

  % Plot the images in dictionary on multiple rows
  step_u = params.x_dims(1) + 1;
  step_v = params.x_dims(2) + 1;
  dim_u = params.display_n_rows * step_u;
  dim_v = params.display_n_cols * step_v;
  ind_u = 1:(params.x_dims(1));
  ind_v = 1:(params.x_dims(2));
  im = zeros(dim_u, dim_v);
  row = 1;
  col = 1;
  for k = 1:params.dim_z
    if (col > params.display_n_cols)
      col = 1;
      row = row + 1;
    end
    im_tile = reshape(model.D(:, k), params.x_dims);
    % Hacky correction for MNIST images (invert X and Y axes)
    if (isequal(params.x_dims, [28 28]))
      im_tile = im_tile';
    end
    im((row-1) * step_u + ind_u, (col-1) * step_v + ind_v) = im_tile;
    col = col + 1;
  end
  imagesc(im);
  set(gca, 'XTick', 0:step_v:dim_v, 'YTick', 0:step_u:dim_u);
  set(gca, 'XTickLabel', {}, 'YTickLabel', {});
  grid on;
  axis equal;
  colormap(params.colormap);
end
title(sprintf('Sparse coding dictionary, %d SGD iterations', ...
  meters.n_iter));

% Save the figure to a PNG image
filename_fig = strrep(params.filename, '.mat', '_W.png');
Octave_SaveAs(gcf, filename_fig);

