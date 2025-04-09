base_folder = 'D:\PROJECT-OUHANDS\augcropkeypoint1\4setdatakey';
gesture_folders = {'A','B','C','D','E','F','H','I','J','K'};
destinationFolder = 'D:\PROJECT-OUHANDS\augcropkeypoint1\4setkeycombined\train';
destinationFolder1 = 'D:\PROJECT-OUHANDS\augcropkeypoint1\4setkeycombined\test';
sets={'set1','set2','set3','set4'};

for i = 1:length(gesture_folders)
    gesture_set_folder = fullfile(destinationFolder, gesture_folders{i});
    gesture_set_folder1 = fullfile(destinationFolder1, gesture_folders{i});
    gesture_folder = fullfile(base_folder, gesture_folders{i});
    % Create subfolders for training and testing for each disease
    if ~exist( gesture_set_folder, 'dir')
        mkdir( gesture_set_folder);
    end
     if ~exist( gesture_set_folder1, 'dir')
        mkdir( gesture_set_folder1);
    end
     for i = 1:length(sets)-1
         set_folder = fullfile(gesture_folder, sets{i});
         image_files = dir(fullfile(set_folder, '*.png'));
         file_names = {image_files.name};
         for j = 1:500
            source = fullfile( set_folder, file_names{j});
            destination = fullfile( gesture_set_folder, file_names{j});
            copyfile(source, destination);
        end
         
     end
         k= 4;
         set_folder = fullfile(gesture_folder, sets{k});
         image_files = dir(fullfile(set_folder, '*.png'));
         file_names = {image_files.name};
         for j = 1:500
            source = fullfile( set_folder, file_names{j});
            destination = fullfile( gesture_set_folder1, file_names{j});
            copyfile(source, destination);
        end
         
     
end
fprintf("data combined")
