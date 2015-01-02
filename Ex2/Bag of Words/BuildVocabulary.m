function [ C_matrix ] = BuildVocabulary( folder, num_clusters )
%BUILDVOCABULARY Summary of this function goes here
%   The first step is to build a vocabulary of visual words.
%   This vocabulary is formed by sampling many local features 
%   from our training set (i.e. 100�s of thousands of features) 
%   and then clustering them with K-means.
%   The number of K-means clusters num_clusters is the size of 
%   our vocabulary.
%   For example, if num_clusters = 50 then the 128 dimensional 
%   SIFT feature space is partitioned into 50 regions.
%   For any new SIFT feature we observe, we can figure out which 
%   cluster it belongs to as long as we save the centroids of our 
%   original clusters.
%   Those clusters are our visual word vocabulary.
%   We extract SIFT features by densely sampling them on a regular 
%   grid in the image.
%   So this function should extract dense SIFT features from all 
%   the images contained in the eight category subfolders of the 
%   general training folder (argument folder) and collect them for
%   K-means clustering.
%
%   TODO: 
%   For feature extraction we use the function vl_dsift. 
%   Please note that we do not necessarily need to extract a SIFT 
%   feature for every pixel for vocabulary creation, e.g. around 
%   100 features per image are enough to �capture� the approximately
%   correct distribution of SIFT features for the given image data. 
%   Hence, use the parameters 'Step' and 'Fast' for vl_dsift and 
%   optionally select only a random subset of features per image for 
%   the overall set (the function randsample might be helpful). 
%   To iterate all images, the function dir can be used.
%   
%   After all SIFT features have been collected, you should apply 
%   K-means clustering to find the visual words.Instead of the Matlab 
%   function or your own K-means function from Assignment 2, vl_kmeans 
%   can be used here for performance reasons. The words are finally 
%   stored in the matrix C of size 128 num_clusters.

    
    %array where all 800 images are to be saved
    all_jpg_images = cell(800, 1); %(800, 1);

    % counter images in final array: all_jpg_images
    counter = 1;
    
    files_in_main_folder = dir(folder)
    % size(files_in_main_folder) = 10 , 2 = 10 -> elements start at 3:10 ->
    % 8 elements
    
    for i = 1:8 %nr subfolders = 8
        foldername = files_in_main_folder(i+2).name;
        folderpath = fullfile(folder, foldername);    %fullfile bastelt aus ordnernamen und filenamen einen pfad
        files_in_subfolder = dir(folderpath)
        % size(files_in_subfolder) = 102, 2 = 102 -> elements start at
        % 3:102 -> 100 elements
        
        for j = 1:100 %nr elements (imgs) in subfolder = 100
            fullpath = fullfile(folderpath, files_in_subfolder(j+2).name);
            image = imread(fullpath);
            all_jpg_images{counter} = image;
            counter = counter + 1;
        end
    end
    
    %all_jpg_images
    %size(all_jpg_images)
    
    % Images sind nun eingelesen und alle in einem array gespeichert
    
    % TODO weiter
    
    
   
end

