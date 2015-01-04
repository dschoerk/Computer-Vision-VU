function [ conf_matrix, class ] = ClassifyImages( folder, C, training, group )
%CLASSIFYIMAGES 
%   classify all the images of the test set (in order to investigate the 
%   classification power of the bag of visual words model for our classification 
%   task).
%   The function is similar to BuildKNN, but this time the visual word histogram 
%   of an image is used for actually classifying it by means of the Matlab function 
%   knnclassify (e.g. k = 3) and the previously learned training features and class 
%   labels group.
%   Output: confusion matrix conf_matrix, whose elements at position (i; j) indicate 
%   how often an image with class label i is classified to the class with label j.

    % DECLARATIONS
    % Sample -  Matrix whose rows will be classified into groups. Must have the same number of columns as Training.
    sample = [];
    conf_matrix = zeros(8,8);

    % die 800 images of the test Set EINLESEN
    all_jpg_images = readInFiles(folder);
    
    % SIFT  FEATURE EXTRACTION
    % extract all SIFT features of images (step  = 1 or 2)
    for k = 1:800
        % features of current image
        [frames, descriptors] = vl_dsift(single(all_jpg_images{k}), 'step', 2, 'fast');
      
        % SIFT features are assigned to visual words in vocabulary C
        % - with knnsearch
        transposed_descriptors = transpose(descriptors);
        transposed_C = transpose(C);
        Idx = knnsearch(transposed_C, transposed_descriptors);
        
        % number of occurrences of every word is counted
        % - with histc
        binranges = 1:50;
        vec_hist_count = histc(Idx, binranges);
        sum_hist = sum(vec_hist_count);
        
        % Normalization to unit length of the vector (histogram) to account for
        % changing image resolutions...
        % - h = h/sum(h); 
        norm = vec_hist_count / sum_hist;
        
        % vertically [a; b] concat these norm vectors to the sample matrix
        sample = [sample norm];
    end
    
    sample = transpose(sample);
    
    %% CLASSIFY all images of the test set
    class = knnclassify(sample, training, group, 3);  % k = 3
     
    %% build CONF_MATRIX
    % elements at position (i; j) indicate how often an image with class label i 
    % is classified to the class with label j
    for k = 1:800
        %fill conf_matrix with values: how often was img with class label
        %i, classified as an image belonging to class j
        conf_matrix(group(k), class(k)) = conf_matrix(group(k), class(k)) + 1;
    end

end

