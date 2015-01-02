function [ C_matrix ] = BuildVocabulary( folder, num_clusters )
%BUILDVOCABULARY Summary of this function goes here
%   The first step is to build a vocabulary of visual words.
%   This vocabulary is formed by sampling many local features 
%   from our training set (i.e. 100’s of thousands of features) 
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
%   100 features per image are enough to “capture” the approximately
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

    % try to read files out of all subfolders of "folder"
    path = 'train'; 
    path1 = 'train/bedroom'; 
    path2 = 'train/forest'; 
    path3 = 'train/kitchen'; 
    path4 = 'train/livingroom'; 
    path5 = 'train/mountain'; 
    path6 = 'train/office'; 
    path7 = 'train/store'; 
    path8 = 'train/street'; 

    
    %array where all 800 images are to be saved
    all_jpg_images = cell(800, 1); %(800, 1);
    
    % iterate all images: function dir
    files = dir(folder)
 %   files(3).name   %3 = bedroom, 10 = street

    for i = 1:8 %nr subfolders = 8
        i
        string = strcat('train/', files(i+2).name)
        
        % read all 100 images from subfolder nr i+2
        temp_imgs = dir(string);
       % size_temp_imgs = size(temp_imgs)
        
        %test
   %     m = 0;
   %     for k = (((i-1)*100) + 1) : (100 * i)
   %         m = m + 1;
   %     end
   %     m
        
   %     n = 0;
   %     for l = 3:102
   %         n = n + 1;
   %     end
   %     n

%     temp_imgs(3:102).name   %all_jpg_images{i,:} = 
%     {all_jpg_images{1 : 100}}
       
      all_jpg_images{(((i-1)*100) + 1) : (100 * i)} = temp_imgs(3:102).name;    
      %     all_jpg_images{1 : 100} = temp_imgs(3:102).name;    
                                                  %1:100} = temp_imgs(1:100).name;

    % Wie ich auf die Formel gekommen bin... :     
    %    1 : 100 ->         101 : 200 ->       201 : 300 -> 301 : 400 -> 401 : 500 -> ... -> 701 : 800
    %    (i-1)*100 + 1 =    (i-1)*100+1 =
    %      0  *100 + 1 = 1    1  *100+1 = 101
    %     100 * i = 100     100 * i = 200 
    %
    %   ... -> 701 : 800
    %          (i-1)*100 + 1 = 
    %            7  *100 + 1 = 701
    %          100 * i = 800
    
    end
    
    % all_jpg_images
    
end

