clear all;
clc;
dataPath = 'D:\PROJECT-OUHANDS\augcroppedbound1\augcroppedbound';
imdsdataset = imageDatastore(dataPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

net=load('Googlenetboundmodel.mat')
inputSize = net.netTransfer.Layers(1).InputSize;
%disp(inputSize);
%%
layer1= 'pool5-7x7_s1';
layer2='loss3-classifier';
fl1 = activations(net.netTransfer,imdsdataset ,layer1,'OutputAs','rows');
fl2 = activations(net.netTransfer,imdsdataset ,layer2,'OutputAs','rows');
whos fl1
whos fl2
%%
f2 = fl1;
f3 = fl2;

% Calculate the initial length of features
P2 = size(f2, 2) + size(f3, 2) ;

% Initialize an array to store the fused features
feature_fused = zeros(size(f2, 1), P2);

% Place features in the array
feature_fused(:, 1:size(f2, 2)) = f2;
feature_fused(:, size(f2, 2)+1:size(f2, 2)+size(f3, 2)) = f3;

%%
% Load the fused data
fused = load('fusedf.mat'); 
fused_data = fused.feature_fused;
num_images = size(fused_data, 1);

label=imdsdataset.Labels;
rng(42); 
cv = cvpartition( num_images , 'HoldOut', 0.2);


trainIdx = training(cv);
testIdx = test(cv);

trainFeatures = fused_data(trainIdx, :);
testFeatures = fused_data(testIdx, :);

trainLabels = label(trainIdx);
testLabels = label(testIdx);
% Create an SVM template with an RBF kernel
%svmTemplate = templateSVM('KernelFunction', 'polynomial');

% Train the classifier using fitcecoc
%SVMModel = fitcecoc(trainFeatures, trainLabels, 'Learners', svmTemplate);

SVMModel = fitcecoc(trainFeatures, trainLabels);

% Predict using the trained model
predictedLabels = predict(SVMModel, testFeatures);

% Evaluate the accuracy
accuracy = mean(predictedLabels == testLabels);
disp(['Test accuracy: ', num2str(accuracy * 100),'%']);

%%
conf_mat = confusionmat(testLabels, predictedLabels);

% Calculate accuracy
accuracy = sum(diag(conf_mat)) / sum(sum(conf_mat));

% Calculate precision for each class
precision = zeros(1, 10);
for i = 1:10
    precision(i) = conf_mat(i, i) / sum(conf_mat(:, i));
end

% Calculate recall for each class
recall = zeros(1, 10);
for i = 1:10
    recall(i) = conf_mat(i, i) / sum(conf_mat(i, :));
end

% Calculate F1 score for each class
f1_score = 2 * (precision .* recall) ./ (precision + recall);

% Display the results
disp(['Accuracy: ', num2str(accuracy)]);
disp(['Precision: ', num2str(mean(precision))]);
disp(['Recall: ', num2str(mean(recall))]);
disp(['F1 Score: ', num2str(mean(f1_score))]);


figure;
imagesc(conf_mat);

colormap('sky');

clim([0 100]);
xlabel('Predicted Labels');
ylabel('Actual Labels');
title('Confusion Matrix');

% Loop to display percentages in each cell
[numRows, numCols] = size(conf_mat);
for i = 1:numRows
    for j = 1:numCols
        text(j, i, sprintf("%d", conf_mat(i, j)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end
end

%% %TESTING A SINGLE IMAGE
img=imread("D:\PROJECT-OUHANDS\augcroppedbound1\augcroppedbound\A\A-1993.png");
layer1= 'pool5-7x7_s1';
layer2='loss3-classifier';
fl1= activations(net.netTransfer,img,layer1,'OutputAs','rows');
fl2= activations(net.netTransfer,img,layer2,'OutputAs','rows');


f2 = fl1;
f3 = fl2;

% Calculate the initial length of features
P2 = size(f2, 2) + size(f3, 2) ;

% Initialize an array to store the fused features
feature_fused = zeros(size(f2, 1), P2);

% Place features in the array
feature_fused(:, 1:size(f2, 2)) = f2;
feature_fused(:, size(f2, 2)+1:size(f2, 2)+size(f3, 2)) = f3;

