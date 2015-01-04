function [ training, group, all_jpg_images ] = BuildKNN( folder, C )
%BUILDKNN Summary of this function goes here
%   build a feature representation for every image in the training set,
%   that can be used for the classification of new images later on.
%   An image is represented by the normalized histogram of visual words,
%   which means that all SIFT features of an image are assigned to visual
%   words and the number of occurrences of every word is counted.
%   The vector (histogram) is normalized to unit length to account for
%   changing image resolutions.
%
%   Output:
%   - training: a matrix of feature points, where the rows represent the
%   800 images of the training set.
%   - group: a vector that indicates the class labels of the 800 images


    % all "words" are stored in matrix C.
    % one column per center
    % For any new SIFT feature we observe, we can figure out which cluster
    % it belongs to as long as we save the centroids of our original clusters.

    training = [];        %zeros(800,50); 
    group = zeros(800,1); %column vec with 800 items
    
    % die 800 imgs EINLESEN
    all_jpg_images = readInFiles(folder);

    % SIFT  FEATURE EXTRACTION
    % extract all SIFT features of images (step  = 1 or 2)
    for k = 1:800
        % features of current image
        [frames, descriptors] = vl_dsift(single(all_jpg_images{k}), 'step', 2, 'fast');
       
        % SIFT features are assigned to visual words in vocabulary C
        % - with knnsearch
        %   IDX = knnsearch(X,Y) -> finds the nearest neighbor in X for each point in Y.
        %   IDX is a column vector with my rows. Each row in IDX contains the index of
        %   nearest neighbor in X for the corresponding row in Y.
        transposed_descriptors = transpose(descriptors);
        transposed_C = transpose(C);
        Idx = knnsearch(transposed_C, transposed_descriptors);
    
        % number of occurrences of every word is counted
        %   - with histc
        binranges = 1:50;
        vec_hist_count = histc(Idx, binranges);
        sum_hist = sum(vec_hist_count);
    
        % Normalization to unit length of the vector (histogram) to account for
        % changing image resolutions...
        % - h = h/sum(h); 
        norm = vec_hist_count / sum_hist;
    
        % vertically [a; b] concat these norm vectors to the training matrix
        training = [training norm];
        
        %fill group vector with the correct class labels of the 800 images
        if (k >= 1) && (k <= 100)
            group(k) = 1;
        elseif (k >= 101) && (k <= 200)
            group(k) = 2;
        elseif (k >= 201) && (k <= 300)
            group(k) = 3;
        elseif (k >= 301) && (k <= 400)
            group(k) = 4;
        elseif (k >= 401) && (k <= 500)
            group(k) = 5;
        elseif (k >= 501) && (k <= 600)
            group(k) = 6;
        elseif (k >= 601) && (k <= 700)
            group(k) = 7;
        elseif (k >= 701) && (k <= 800)
            group(k) = 8;
        end
    
    end

    training = transpose(training);

end

