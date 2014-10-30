%loadImages - is a function which loads all images containing 
%   '_R' from the path, which comes as an input parameter, into 
%   the R array, all images containing '_G' from the path into 
%   the G array and all images containing '_B' into the B array.
%   Finally the three arrays R, G and B are returned.

%loadImages - is a function which loads all files contained by
%   the given path into the retuned images folder listing.
%   Finally the images array is returned.

function [ images_R, images_G, images_B ] = loadImages( path, images_nr )
    R_names = cell(images_nr, 1);
    G_names = cell(images_nr, 1);
    B_names = cell(images_nr, 1);

    r_size = 1; %size of R array
    g_size = 1; %size of G array
    b_size = 1; %size of B array

    images_R = cell(images_nr, 1);
    images_G = cell(images_nr, 1);
    images_B = cell(images_nr, 1);


    %loading the files from path into images array
    files = dir(path);
    
    %separate images from returned images array into R, G, B array

    for i = 3:24  %not sure why
    
        %add image file containing _R to R_names array
        r = strfind(files(i).name, '_R');
        if (r ~= 0)
            R_names{r_size} = files(i).name;
            r_size = r_size + 1;
        end
    
        %add image file containing _G to G_names array
        g = strfind(files(i).name, '_G');
        if (g ~= 0)
            G_names{g_size} = files(i).name;
            g_size = g_size + 1;
        end
    
        %add image file containing _B to B_names array
        b = strfind(files(i).name, '_B');
        if (b ~= 0)
            B_names{b_size} = files(i).name;
            b_size = b_size + 1;
        end
    end
    
    %finally read in images (in separate arrays)
    for i = 1:images_nr
        images_R{i} = imread(strcat(path, '/', R_names{i}));
        images_G{i} = imread(strcat(path, '/', G_names{i}));
        images_B{i} = imread(strcat(path, '/', B_names{i}));
    end
end











