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

% Load the original data provided by Sam Roweis
load ../data/mnist_all.mat

% Concatenate the 10 matrices containing training samples
% and generate vector of training labels. Each column is a data sample.
xTrain = [];
yTrain = [];
for k = 0:9
  x_k = eval(['train' num2str(k)]);
  x_k = x_k';
  xTrain = [xTrain, x_k];
  yTrain = [yTrain, k * ones(1, size(x_k, 2))];
end

% Concatenate the 10 matrices containing test samples
% and generate vector of test labels
xTest = [];
yTest = [];
for k = 0:9
  x_k = eval(['test' num2str(k)]);
  x_k = x_k';
  xTest = [xTest, x_k];
  yTest = [yTest, k * ones(1, size(x_k, 2))];
end

% Convert the values to double-valued and normalize the images pixel values
% to be between 0 and 1
xTrain = double(xTrain) / 255;
xTest = double(xTest) / 255;
yTrain = double(yTrain);
yTest = double(yTest);

% Save the data in the new format
save('../data/MNIST_Formatted.mat', 'xTrain', 'yTrain', 'xTest', 'yTest');

% Clean-up
clear('train*', 'test*', 'k', 'x_k');
