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

    % die 800 IMAGES EINLESEN
    all_jpg_images = readInFiles(folder);

    % SIFT  FEATURE EXTRACTION
    % vl_dsift: [FRAMES,DESCRS] = VL_DSIFT(I) extracts a dense set of SIFT 
    %   keypoints from image I. 
    %   - I must be of class SINGLE and grayscale. 
    %   - FRAMES is a 2 x NUMKEYPOINTS, each colum storing the center (X,Y) 
    %   of a keypoint frame (all frames have the same scale and orientation). 
    %   - DESCRS is a 128 x NUMKEYPOINTS matrix with one descriptor per column
    % 
    %calculate necessary step size, so that ~100 features (NUMKEYPOINTS)
    %will be extracted:
    size_x = size(all_jpg_images{1}, 2);
    size_y = size(all_jpg_images{1}, 1);
    step = floor(sqrt((size_x * size_y)/100));
    % collect all SIFT features
    [all_frames, all_descriptors] = vl_dsift(single(all_jpg_images{1}), 'step', step, 'fast');
%    features{1} = all_descriptors;
    for k = 2:800
        %calculate necessary step size, so that ~100 features (NUMKEYPOINTS)
        %will be extracted:
        % formula: step = floor(sqrt((size_x * size_y)/100));
        size_x = size(all_jpg_images{k}, 2);
        size_y = size(all_jpg_images{k}, 1);
        step = floor(sqrt((size_x * size_y)/100));
        
        % features of current image
        [frames, descriptors] = vl_dsift(single(all_jpg_images{k}), 'step', step, 'fast');
        % joining values of frames and descriptors by horizontally concatenating the
        % matrices
        % concatenate extracted features from current image to all until now
        % accumulated features: horizontal concatenation [a b]
        all_frames = [all_frames frames];                    % vertical concatenation: [a; b]
        all_descriptors = [all_descriptors descriptors];
        % or
%        features{k} = descriptors;
    end

    % K-MEANS CLUSTERING
    % [C, A] = VL_KMEANS(X, NUMCENTERS) clusters the columns of the matrix X 
    % in NUMCENTERS centers C using k-means. 
    % - X may be either SINGLE or DOUBLE. 
    % - C has the same number of rows of X and NUMCENTER columns, with one column 
    % per center. 
    % - A is a UINT32 row vector specifying the assignments of the data X to the 
    % NUMCENTER centers. 
    [C_matrix, A] = vl_kmeans(single(all_descriptors), num_clusters);

end

