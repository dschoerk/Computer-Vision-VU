%% Description:
%   main.m is a script that performs the three basic steps of the Bag 
%   of visual Words classification method by calling the functions: 
%   Build Vocabulary, BuildKNN and ClassifyImages.


C = BuildVocabulary('train', 50);

[training, group] = BuildKNN('train', C);

conf_matrix = ClassifyImages('test', C, training, group);

% print out resulting confusion matrix
conf_matrix