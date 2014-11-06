% TODO - description

%variables
path = '../resources'; 
images_nr = 9; %6

%call loadImages function
[images_R, images_G, images_B] = loadImages(path, images_nr);

%variables for automatical alignment
%[m, n] = size(images_R{1});
colored_images_RGB = cell(images_nr, 1);

%align jeweils 3 images with the best match - do this 6 times,
%cause there are 6 colored images to be generated
for i = 1:images_nr
    [m, n] = size(images_R{i});
    tempCorrR = 0;
    tempCorrG = 0;
    bestCorrR = 0;
    bestCorrG = 0;
    tempR = zeros(m, n);
    tempG = zeros(m, n);
    chosenR = zeros(m, n);
    chosenG = zeros(m, n);
    %verschieben jeweils image_R und image_G, vergleichen sie
    %dann mit image_B, welche fix bleibt

    chosenB = images_B{i};
    
    %verschiebung untersuchen - possible displacements: 
    %[-15, 15] pixels, in jeweils 4 Richtungen (up, down,
    %left, right)
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
    
    %colored image 3 ist nicht perfekt...
end












