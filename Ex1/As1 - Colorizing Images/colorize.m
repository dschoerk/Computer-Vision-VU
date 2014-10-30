

%variables
path = '../resources'; 
images_nr = 6;

%R_names = cell(images_nr, 1);
%G_names = cell(images_nr, 1);
%B_names = cell(images_nr, 1);

%r_size = 1; %size of R array
%g_size = 1; %size of G array
%b_size = 1; %size of B array

%loading the files from path into images array
%files = loadImages(path);

%separate images from returned images array into R, G, B array

%for i = 3:24  %not sure why
    
    %add image file containing _R to R_names array
%    r = strfind(files(i).name, '_R');
%    if (r ~= 0)
%        R_names{r_size} = files(i).name;
%        r_size = r_size + 1;
%    end
    
    %add image file containing _G to G_names array
%    g = strfind(files(i).name, '_G');
%    if (g ~= 0)
%        G_names{g_size} = files(i).name;
%        g_size = g_size + 1;
%    end
    
    %add image file containing _B to B_names array
%    b = strfind(files(i).name, '_B');
%    if (b ~= 0)
%        B_names{b_size} = files(i).name;
%        b_size = b_size + 1;
%    end

%end

%finally read in images (in separate arrays)
%images_R = cell(images_nr, 1);
%images_G = cell(images_nr, 1);
%images_B = cell(images_nr, 1);

%for i = 1:images_nr
%    images_R{i} = imread(strcat(path, '/', R_names{i}));
%    images_G{i} = imread(strcat(path, '/', G_names{i}));
%    images_B{i} = imread(strcat(path, '/', B_names{i}));
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%images_R = cell(images_nr, 1);
%images_G = cell(images_nr, 1);
%images_B = cell(images_nr, 1);

%call loadImages function
[images_R, images_G, images_B] = loadImages(path, images_nr);

%test - success
%imshow(imread(strcat(path, '/', R_names{1})))

tempCorrR = 0;
tempCorrG = 0;
bestCorrR = 0;
bestCorrG = 0;
[m, n] = size(images_R{1});
tempR = zeros(m, n);
tempG = zeros(m, n);
chosenR = zeros(m, n);
chosenG = zeros(m, n);
chosenB = zeros(m, n);
colored_images_RGB = cell(images_nr, 1);

%align jeweils 3 images with the best match
for i = 1:6
    %verschieben jeweils image_R und image_G, vergleichen sie
    %dann mit image_B, welche fix bleibt
    chosenB = images_B{i};
    %verschiebung untersuchen
    for j = -15:15
        for k = -15:15
            %vertikaler shift um k und horizontaler shift
            %um j von image_R; wenn k>0 shift nach rechts,
            %wenn j>0 shift nach unten
            tempR = circshift(images_R{i}, [j,k]);
            tempCorrR = corr2(tempR, images_B{i});
            if (tempCorrR > bestCorrR)
                bestCorrR = tempCorrR;
                chosenR = tempR;
            end
            
            %vertikaler shift um k und horizontaler shift
            %um j von image_G; wenn k>0 shift nach rechts,
            %wenn j>0 shift nach unten
            tempG = circshift(images_G{i}, [j,k]);
            tempCorrG = corr2(tempG, images_B{i});
            if (tempCorrG > bestCorrG)
                bestCorrG = tempCorrG;
                chosenG = tempG;
            end
        end
    end
    colored_images_RGB{i} = cat(3, chosenR, chosenG, chosenB);
    
    %test
    figure;
    imshow(colored_images_RGB{i});
end












