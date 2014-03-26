% This is the companion code for Piotr Mirowski's tutorial 
% on Auto-Encoders, given for the first time at the London Deep Learning
% meetup on March 26, 2014.
% This tutorial implements Marc'Aurelio Ranzato's Sparse Encoding 
% Symmetric Machine (SESM) and tests it on MNIST handwritten digits.
%
% The main reference is the following paper:
% M.'A. Ranzato, Y.-L. Boureau, and Y. LeCun.
% "Sparse Feature Learning for Deep Belief Networks"
% NIPS 2007

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

% Load the MNIST data
%
% This is a dataset of 60k training samples and 10k test samples,
% consisting in 28x28 gray-scale images of handwritten digits collected
% by NIST from US Census Bureau employees and high school students.
%
% The original dataset used in the Convolutional Network experiments
% and subsequent experiments using neural nets, SVMs, auto-encoders, etc...
% can be retrieved from Yann LeCun's webpage at NYU:
% http://yann.lecun.com/exdb/mnist/
%
% The main reference to this dataset is:
% Y. LeCun, L. Bottou, Y. Bengio, and P. Haffner.
% "Gradient-based learning applied to document recognition."
% Proceedings of the IEEE, 86(11):2278-2324, November 1998
%
% We use the Matlab version of the data, available at Sam Roweis' NYU page:
% http://www.cs.nyu.edu/~roweis/data.html
filename_data = '../data/MNIST_Formatted.mat';
if (exist(filename_data, 'file'))
  % Load the formatted version of the dataset
  load(filename_data);
else
  % Call the script that loads the raw version by Sam Roweis
  % and pre-processes it
  Script_MNIST_Prepare;
end

% Initialize the parameters for the first layer, knowing that:
% * the vectors in xTrain and xTest have 784 elements (28 * 28 = 784)
% * we want 192-dimensional sparse codes in layer 1
params_1 = Params_Default(784, 192);
params_1.x_dims = [28 28];
params_1.display_n_rows = 12;
params_1.display_n_cols = 16;
params_1.filename = ['../results/MNIST_Layer1_' params_1.filename];
params_1.alpha_s = 0.2;
disp(params_1)

% Initialize the first layer of the PSD model
layer_1 = Layer_Init(params_1);
% Train the first layer of the PSD model
[layer_1, meters_1] = Layer_Learn(layer_1, xTrain, params_1);

% Predict the code activations of the first layer (training and test data)
aTrain_1_hat = Layer_Predict(layer_1, xTrain, params_1);
aTest_1_hat = Layer_Predict(layer_1, xTest, params_1);


% Initialize the parameters for the second layer, knowing that:
% * the vectors in zTrain_1_hat and zTest_1_hat have 192 elements
% * we want 10-dimensional sparse codes in layer 2
params_2 = Params_Default(192, 10);
params_2.x_dims = [12 16];
params_2.display_n_rows = 1;
params_2.display_n_cols = 10;
params_2.filename = ['../results/MNIST_Layer2_' params_2.filename];
params_2.alpha_s = 1;
params_2.eta_z = 0.01;
params_2.eta_W = 0.025;
disp(params_2)

% Initialize the second layer of the PSD model
layer_2 = Layer_Init(params_2);
% Train the second layer of the PSD model
[layer_2, meters_2] = Layer_Learn(layer_2, aTrain_1_hat, params_2);

% Predict the code activations of the second layer (training and test data)
aTrain_2_hat = Layer_Predict(layer_2, aTrain_1_hat, params_2);
aTest_2_hat = Layer_Predict(layer_2, aTest_1_hat, params_2);

% Apply back-projection to get, in image space, the filters learned on
% layer 2. We consecutively set one of the activation units in layer 2
% to 1 while keeping the other units equal to 0, and propagate the codes
% back through layer 2 then through layer 1.
digits_2 = eye(10);
digits_1 = Layer_BackProject(layer_2, digits_2, params_2);
digits_x = Layer_BackProject(layer_1, digits_1, params_1);
for k = 1:10
  figure;
  imagesc(reshape(digits_x(:, k), params_1.x_dims)');
  colormap('gray');
  title(sprintf('Back-projection of unit %d', k));
end

% Using the LibSVM toolkit, one can train Gaussian kernel SVM
% and achieve an error rate of 1.5% on the raw pixels
% http://peekaboo-vision.blogspot.co.uk/2010/09/mnist-for-ever.html

% If you want to export the latent code activations in LibSVM format,
% use the following script:
% Data_Export_LibSVM(filename, x, y)