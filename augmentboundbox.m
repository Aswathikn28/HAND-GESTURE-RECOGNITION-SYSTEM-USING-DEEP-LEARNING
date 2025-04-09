% Define the source and destination folders
sourceFolder = 'D:\PROJECT-OUHANDS\CROPPEDBOUNDBOX';
destinationFolder = 'D:\PROJECT-OUHANDS\AUGMENTED CROPPEDBOUNDBOX';

if ~exist(destinationFolder, 'dir')
    mkdir(destinationFolder);
end
% Define the augmentation parameters
numAugmentationsPerClass = 2000; 
rotationAngles = [-10, 0, 10]; 
shearAngles = [-5, 0, 5]; 
zoomFactors = [0.9, 1, 1.1]; 
scaleFactors = [0.9, 1.1]; 
% Create a cell array to store class-specific subfolders
classSubfolders = {'A','B','C','D','E','F','H','I','J','K'}; 
for classIndex = 1:numel(classSubfolders)
    classFolder = fullfile(sourceFolder, classSubfolders{classIndex});
    
    % List all files in the class folder
    fileList = dir(fullfile(classFolder, '*.png')); 
    
    % Determine the subfolder for the class in the destination folder
    subfolder = fullfile(destinationFolder, classSubfolders{classIndex});
    
    % Create the subfolder if it doesn't exist
    if ~exist(subfolder, 'dir')
        mkdir(subfolder);
    end
    %storing oroginal image
    for i = 1:numel(fileList)
   
        img = imread(fullfile(classFolder, fileList(i).name));
        img=imresize( img, [224, 224]);
        imwrite(img, fullfile(subfolder, fileList(i).name));
    end
   %Apply data augmentation
    for j = 1:2000-numel(fileList)
        % Randomly choose augmentation parameters
        img = imread(fullfile(classFolder, fileList(randperm(numel(fileList),1)).name));
        randomRotation = rotationAngles(randi(length(rotationAngles)));
        randomShear = shearAngles(randi(length(shearAngles)));
        randomZoom = zoomFactors(randi(length(zoomFactors)));
        randomScale = scaleFactors(randi(length(scaleFactors)));
        % Initialize an identity transformation matrix
        tform = affine2d([1, 0, 0; 0, 1, 0; 0, 0, 1]);
        % Apply the augmentations
        tform.T = tform.T * [cosd(randomRotation) -sind(randomRotation) 0; sind(randomRotation) cosd(randomRotation) 0; 0 0 1];
        tform.T = tform.T * [1 0 0; tand(randomShear) 1 0; 0 0 1];
        tform.T = tform.T * [randomZoom 0 0; 0 randomZoom 0; 0 0 1];
        tform.T = tform.T * [randomScale 0 0; 0 randomScale 0; 0 0 1];
        % Apply the transformation to the image
        augmentedImg = imwarp(img, tform);
        augmentedImg    =imresize( augmentedImg, [224, 224]);
        % Save the augmented image to the class-specific subfolder
        augmentedFilename = sprintf('aug_%04d.png', j);
        imwrite(augmentedImg, fullfile(subfolder, augmentedFilename));
    end
end
disp('Data augmentation completed.');
