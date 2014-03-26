% Display_Meters  Plot the decoder loss curves from the meters
%
% Syntax:
%   Display_Meters(meters, params)
% Inputs:
%   meters:    struct with the decoder loss vectors
%   params:    struct with the parameters

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

function Display_Meters(meters, params)

% Get the raw meter values for the decoder loss values
n_iter = meters.n_iter;
loss_optimal = meters.loss_optimal(1:n_iter);
loss_psd = meters.loss_psd(1:n_iter);
idx = 1:n_iter;

% Subsample the curves to get length < 1000 and avoid long plot times
loss_optimal = Display_Meters_Subsample(loss_optimal, n_iter);
loss_psd = Display_Meters_Subsample(loss_psd, n_iter);
idx = Display_Meters_Subsample(idx, n_iter);

% Plot the loss curves
figure(1);
clf;
hold on;
plot(idx, loss_optimal, 'b');
plot(idx, loss_psd, 'r');
title('Loss values');
xlabel('SGD iterations');
legend('Optimal SD decoder', 'Direct PSD decoder');
set(gca, 'YScale', 'log');
grid on;

% Save the figure to a PNG image
filename_fig = strrep(params.filename, '.mat', '_loss.png');
Octave_SaveAs(gcf, filename_fig);


% -------------------------------------------------------------------------
% Recursively subsample a vector by factor of 2 until length is < 1000
function vec = Display_Meters_Subsample(vec, len)

while (len > 1000)
  if (mod(len, 2) ~= 0)
    vec(len+1) = vec(len);
  end
  vec = (vec(1:2:end) + vec(2:2:end)) / 2;
  len = length(vec);
end
