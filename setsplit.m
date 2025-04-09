base_folder = 'D:\PROJECT-OUHANDS\augcropkeypoint1\AUGMENTED CROPPEDWITHKEYPOINTS';
gesture_folders = {'A', 'B', 'C','D','E','F','H','I','J','K'};
destinationFolder = 'D:\PROJECT-OUHANDS\augcropkeypoint1\4setdatakey';
sets={'set1','set2','set3','set4'};

for i = 1:length(gesture_folders)
    gesture_set_folder = fullfile(destinationFolder, gesture_folders{i});
     gesture_folder = fullfile(base_folder, gesture_folders{i});
    % Create subfolders for training and testing for each gestures
    if ~exist( gesture_set_folder, 'dir')
        mkdir( gesture_set_folder);
    end
    count=500;
    start=1;
   for i = 1:length(sets)
     set_folder = fullfile(gesture_set_folder, sets{i});
      if ~exist(set_folder, 'dir')
        mkdir(set_folder);
      end
       image_files = dir(fullfile(gesture_folder, '*.png'));
        file_names = {image_files.name};
        
        for j = start:count
            source = fullfile(gesture_folder, file_names{j});
            destination = fullfile( set_folder, file_names{j});
            copyfile(source, destination);
        end
         count=count+500;
         start=start+500;
   end
  
end
fprintf("stored into 4 sets")

