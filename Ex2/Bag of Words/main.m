%% TODO description




C = BuildVocabulary('train', 50);

[training, group] = BuildKNN('train', C);

% conf_matrix = ClassifyImages('test', C, training, group);