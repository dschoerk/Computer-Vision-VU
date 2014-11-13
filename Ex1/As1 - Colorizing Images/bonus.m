% bonus - this class represents a solution to the colorizing image-
%   probelm, which also works for very big images. The improvement 
%   is based on the use of gaussian pyramids of the processed images.
%   Finally one big concatenated colorized images will be
%   returned.

%variables
path = '../resources'; 
images_nr = 9;

%load images from path by menas of the loadImages function
[images_R, images_G, images_B] = loadImages(path, images_nr);

%tic-toc: command which allows the measurement of the time required
%for this class to execute
tic;

%definition of the kernel_width
%kernel_size = 2 * kernel_width + 1
kernel_breite = 2;

%gaussian pyramid generation of the red channel image of the input image 
[pyramid_R, pyramid_R_channel, levels] = generatePyramids( images_R{8}, kernel_breite );
%gaussian pyramid generation of the green channel image of the input image 
[pyramid_G, pyramid_G_channel, levels] = generatePyramids( images_G{8}, kernel_breite );
%gaussian pyramid generation of the blue channel image of the input image 
[pyramid_B, pyramid_B_channel, levels] = generatePyramids( images_B{8}, kernel_breite );

%output: number of levels of current pyramids (the same for all channel images)
%levels

%initialization of required variables
[m, n] = size(pyramid_R_channel{1});
tempCorrR = 0;
tempCorrG = 0;
tempR = zeros(m, n);
tempG = zeros(m, n);
chosenR = zeros(m, n);
chosenG = zeros(m, n);

%actual Adjustment-Vector-Coordinates[j, k] for the red image:
chosenJ_R = 0;
chosenK_R = 0;
%actual Adjustment-Vector-Coordinates[j, k] for the green image:
chosenJ_G = 0;
chosenK_G = 0;
%Adjustment-Vector-Coordinates[j, k] of the previous(smaller) pyramid 
%level for the red image:
chosenJ_R_Prev = 0;
chosenK_R_Prev = 0;
%Adjustment-Vector-Coordinates[j, k] of the previous(smaller) pyramid 
%level for the green image:
chosenJ_G_Prev = 0;
chosenK_G_Prev = 0;

%The levels of the pyramid are being processed starting from the smallest
%level, the top of the pyramid, to the bottom
for i = levels:-1:1
    [m, n] = size(pyramid_R_channel{i});
    
    bestCorrR = 0;
    bestCorrG = 0;
   
    %just image_R and image_G are being shifted, while image_B
    %is considered the fixed one. It represents the image to which
    %the other 2 images can be compared.
    B = pyramid_B_channel{i};
    chosenB = B;
  
    %displacement investigation - possible displacements: 
    %[-15, 15] pixels, in 4 directions (up, down, left, and right)
    for j = (-kernel_breite):kernel_breite 
        for k = (-kernel_breite):kernel_breite 
            %vertical shift of k pixels and horizontal shift of j 
            %pixels of the image_R; if k>0 shift to the right, if 
            %j>0 shift down
            R = pyramid_R_channel{i};
            tempR = circshift(R, [j,k]);
            %the actual correlation, similarity between the red and
            %the blue image is computed
            tempCorrR = corr2(tempR, chosenB);
            %comparison with best correlation value until now
            if (abs(tempCorrR) > bestCorrR)
                %best correlation value update
                bestCorrR = abs(tempCorrR);
                %update of best Adjustment-Vector-Coordinates
                chosenJ_R = j;
                chosenK_R = k;
                if(i == 1)
                    %memorizing of the most simmilar red channel image
                    chosenR = tempR; 
                end
            end
            
            %vertical shift of k pixels and horizontal shift of j 
            %pixels of the image_G; if k>0 shift to the right, if 
            %j>0 shift down
            G = pyramid_G_channel{i};
            tempG = circshift(G, [j,k]);
            %the actual correlation, similarity between the green 
            %and the blue image is computed
            tempCorrG = corr2(tempG, chosenB);
            %comparison with best correlation value until now
            if (abs(tempCorrG) > bestCorrG)
                %best correlation value update
                bestCorrG = abs(tempCorrG);
                %update of best Adjustment-Vector-Coordinates
                chosenJ_G = j;
                chosenK_G = k;
                if(i == 1)
                    %memorizing of the most simmilar red channel image
                     chosenG = tempG;
                end
            end
        end
    end
    
    if(i ~= 1)
        %preparation for next step, next pyramid level
        %image on the  next level of the pyramid is already being shifted,
        %according to the best result of the actual level.
        %However the best Adjustment-Vector-Coordinates must be multiplied by
        %2.
        pyramid_R_channel{i-1} = circshift(pyramid_R_channel{i-1}, [(chosenJ_R * 2) + (chosenJ_R_Prev * 2), (chosenK_R * 2) + (chosenK_R_Prev * 2)]);
        pyramid_G_channel{i-1} = circshift(pyramid_G_channel{i-1}, [(chosenJ_G * 2) + (chosenJ_G_Prev * 2), (chosenK_G * 2) + (chosenK_G_Prev * 2)]);
        %update of the Adjustment-Vector-Coordinates of the previous(smaller) 
        %pyramid level (the current one will be the previous one for the next 
        %level)
        chosenJ_R_Prev = (chosenJ_R * 2) + (chosenJ_R_Prev * 2);
        chosenK_R_Prev = (chosenK_R * 2) + (chosenK_R_Prev * 2);
        chosenJ_G_Prev = (chosenJ_G * 2) + (chosenJ_G_Prev * 2);
        chosenK_G_Prev = (chosenK_G * 2) + (chosenK_G_Prev * 2);
    end
    
    if(i == 1)
        %finally the most similar red and green channel images are being con-
        %catenated with the blue channel image, reulting in a colorized image
        colored_images_RGB = cat(3, chosenR, chosenG, chosenB);
        
        %colorized image will be displayed on the screen
        figure;
        imshow(colored_images_RGB);
    end
end

%tic-toc: command which allows the measurement of the time required
%for this class to execute
toc;

