% Path to your dataset
dataPath = 'D:\PROJECT-OUHANDS\augcroppedbound1\4setdatacombined\train';


% Load and prepare your dataset
imds = imageDatastore(dataPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.8,'randomized');
imdsTest = imageDatastore('D:\PROJECT-OUHANDS\augcroppedbound1\4setdatacombined\test', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
%% 

run('gnetboundtrain.mlx')

%load the pretrained network
inputSize = lgraph.Layers(1).InputSize;

% Training options
options = trainingOptions('sgdm', ...
    'MiniBatchSize', 32, ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 1e-5, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', imdsValidation, ...
    'ValidationFrequency', 3, ...
    'Verbose', false, ...
    'Plots', 'training-progress');
% Train the network using imdsTrain and imdsValidation (without augmentation)
netTransfer = trainNetwork(imdsTrain, lgraph, options);
% Validation
YPred = classify(netTransfer, imdsValidation);
YValidation = imdsValidation.Labels;
accuracyValidation = mean(YPred == YValidation);
disp(['Validation Accuracy: ', num2str(accuracyValidation * 100), '%']);
% Resizing test data
augmentedTestDS = augmentedImageDatastore(inputSize(1:2), imdsTest);
% Testing
YPredTest = classify(netTransfer, augmentedTestDS);
YTest = imdsTest.Labels; 
accuracyTest = mean(YPredTest == YTest);
disp(['Test Accuracy: ', num2str(accuracyTest * 100), '%']);




%%

% Load and preprocess the single image
 singleImagePath = 'D:\PROJECT-OUHANDS\augcroppedbound1\4setdatacombined\test\A\A-1993.png';  
 singleImage = imread(singleImagePath);
 singleImageResized = imresize(singleImage, inputSize(1:2));  
% Perform classification
predictedLabel = classify(netTransfer, singleImageResized);

% Display the result
%disp(['Predicted Label: ', char(predictedLabel)]);

%% DISPLAYING CONFUSION MATRIX

conf_mat = confusionmat(YTest,YPredTest);

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