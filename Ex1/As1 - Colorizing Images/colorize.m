

%variables
path = '../resources'; 
images_nr = 6;

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
    %figure;
    %imshow(colored_images_RGB{i});
end












