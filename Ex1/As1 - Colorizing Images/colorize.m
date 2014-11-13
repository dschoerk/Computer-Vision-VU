% colorize - this class first loads the images from the specified
%   path by means of the 'loadImages' function, then for each image
%   or just for a specific image (dependig on the for), the best
%   alignment of its 3 channels r,g and b will be found and con-
%   catenated together building a colored image.
%   Finally the colored image(s) are returned and shown on the display.

%variables
path = '../resources'; 
images_nr = 6; %9

%load images from path by menas of the loadImages function
[images_R, images_G, images_B] = loadImages(path, images_nr);

%tic-toc: command which allows the measurement of the time required
%for this class to execute
tic;

%array where resulting colored images are to be saved
colored_images_RGB = cell(images_nr, 1);

%further variable initialization
[m, n] = size(images_R{1});
tempCorrR = 0;
tempCorrG = 0;    
tempR = zeros(m, n);
tempG = zeros(m, n);
chosenR = zeros(m, n);
chosenG = zeros(m, n);
  
%for can be set either to compute the automatic alignment of
%the channels of a single image, or to compute the colored
%version of all loaded images. 
for i = 1:1%images_nr
    [m, n] = size(images_R{i});
    
    bestCorrR = 0;
    bestCorrG = 0;

    %just image_R and image_G are being shifted, while image_B
    %is considered the fixed one. It represents the image to which
    %the other 2 images can be compared.
    chosenB = images_B{i};
    
    %displacement investigation - possible displacements: 
    %[-15, 15] pixels, in 4 directions (up, down, left, and right)
    for j = -15:15
        for k = -15:15
            %vertical shift of k pixels and horizontal shift of j 
            %pixels of the image_R; if k>0 shift to the right, if 
            %j>0 shift down
            tempR = circshift(images_R{i}, [j,k]);
            %the actual correlation, similarity between the red and
            %the blue image is computed
            tempCorrR = corr2(tempR, images_B{i});
            %comparison with best correlation value until now
            if (tempCorrR > bestCorrR)
                %best correlation value update
                bestCorrR = tempCorrR;
                %memorizing of the most simmilar red channel image
                chosenR = tempR;
            end
            
            %vertical shift of k pixels and horizontal shift of j 
            %pixels of the image_G; if k>0 shift to the right, if 
            %j>0 shift down
            tempG = circshift(images_G{i}, [j,k]);
            %the actual correlation, similarity between the green 
            %and the blue image is computed
            tempCorrG = corr2(tempG, images_B{i});
            %comparison with best correlation value until now
            if (tempCorrG > bestCorrG)
                %best correlation value update
                bestCorrG = tempCorrG;
                %memorizing of the most simmilar red channel image
                chosenG = tempG;
            end
        end
    end
    %the most similar red and green channel images are being con-
    %catenated with the blue channel image, reulting in a colorized
    %image
    colored_images_RGB{i} = cat(3, chosenR, chosenG, chosenB);
    
    %colorized image will be displayed on the screen
    figure;
    imshow(colored_images_RGB{i});
end

%tic-toc: command which allows the measurement of the time required
%for this class to execute
toc;


