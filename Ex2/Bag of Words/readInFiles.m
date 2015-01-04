function [ all_files ] = readInFiles( folder )
%READINFILES 
%   Reads in (image) files from folder and subfolder.
%   Output: cell Array of the (image) files 

    %array where all 800 images are to be saved
    all_files = cell(800, 1);
    
    % counter images in final array: all_files
    counter = 1;

    % IMAGES EINLESEN
    files_in_main_folder = dir(folder);
    % size(files_in_main_folder) = 10 , 2 = 10 -> elements start at 3:10 ->
    % 8 elements
    for i = 1:8 %nr subfolders = 8
        foldername = files_in_main_folder(i+2).name;
        folderpath = fullfile(folder, foldername);    %fullfile bastelt aus ordnernamen und filenamen einen pfad
        files_in_subfolder = dir(folderpath);
        % size(files_in_subfolder) = 102, 2 = 102 -> elements start at
        % 3:102 -> 100 elements
        
        for j = 1:100 %nr elements (imgs) in subfolder = 100
            fullpath = fullfile(folderpath, files_in_subfolder(j+2).name);
            image = imread(fullpath);
            all_files{counter} = image;
            counter = counter + 1;
        end
    end

end

