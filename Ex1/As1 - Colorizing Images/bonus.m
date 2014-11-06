% TODO - description
%   concat 3 big color channel images to just ONE hudge 
%   coloredimage

%variables
path = '../resources'; 
images_nr = 9; %6

%call loadImages function
[images_R, images_G, images_B] = loadImages(path, images_nr);

tic;

levels = 4;
[pyramid_R, pyramid_R_channel] = generatePyramids( images_R{1}, levels );
[pyramid_G, pyramid_G_channel] = generatePyramids( images_G{1}, levels );
[pyramid_B, pyramid_B_channel] = generatePyramids( images_B{1}, levels );

%levels = 6;
%[pyramid_R, pyramid_R_channel] = generatePyramids( images_R{9}, levels );
%[pyramid_G, pyramid_G_channel] = generatePyramids( images_G{9}, levels );
%[pyramid_B, pyramid_B_channel] = generatePyramids( images_B{9}, levels );

for i = levels:-1:1
    [m, n] = size(pyramid_R{i});
    tempCorrR = 0;
    tempCorrG = 0;
    bestCorrR = 0;
    bestCorrG = 0;
    tempR = zeros(m, n);
    tempG = zeros(m, n);
    chosenR = zeros(m, n);
    chosenG = zeros(m, n);
    %Verschiebungsvektor-Koordinaten[j, k] fuer das R_ img:
    chosenJ_R = 0;
    chosenK_R = 0;
    %Verschiebungsvektor-Koordinaten[j, k] fuer das G_ img:
    chosenJ_G = 0;
    chosenK_G = 0;
    
    %For-Anpassungs-Parameter, damit es der kernel fuer die Suche nicht
    %bei allen Levels der Pyramide gleich gross ist
    anpassung = 1;
    
    %verschieben jeweils image_R und image_G, vergleichen sie
    %dann mit image_B, welche fix bleibt

    B = pyramid_B{i};
    chosenB = B;
   
    %verschiebung untersuchen - possible displacements: 
    %[-15, 15] pixels, in jeweils 4 Richtungen (up, down,
    %left, right)
    for j = (-4 * anpassung): (4 * anpassung)
        for k = (-4 * anpassung): (4 * anpassung)
            %vertikaler shift um k und horizontaler shift
            %um j von image_R; wenn k>0 shift nach rechts,
            %wenn j>0 shift nach unten
            R = pyramid_R{i};
            tempR = circshift(R, [j,k]);
            tempCorrR = corr2(tempR, chosenB);
            if (tempCorrR > bestCorrR)
                bestCorrR = tempCorrR;
                chosenJ_R = j;
                chosenK_R = k;
                if(i == 1)
                    chosenR = tempR; 
                end
            end
            
            %vertikaler shift um k und horizontaler shift
            %um j von image_G; wenn k>0 shift nach rechts,
            %wenn j>0 shift nach unten
            G = pyramid_G{i};
            tempG = circshift(G, [j,k]);
            tempCorrG = corr2(tempG, chosenB);
            if (tempCorrG > bestCorrG)
                bestCorrG = tempCorrG;
                chosenJ_G = j;
                chosenK_G = k;
                if(i == 1)
                     chosenG = tempG;
                end
            end
        end
    end
    
    %der naechste Schritt wird vorbereitet
    %naechster Pyramiden-Level wird schon geshiftet, laut dem
    %besten Reusltat von aktuellen Level
    if(i ~= 1)
         pyramid_R{i-1} = circshift(pyramid_R{i-1}, [chosenJ_R * 2, chosenK_R * 2]);
         pyramid_G{i-1} = circshift(pyramid_G{i-1}, [chosenJ_G * 2, chosenK_G * 2]);
    end
   
    if(i == 1)
        colored_images_RGB{i} = cat(3, chosenR, chosenG, chosenB);
    
        %test
        figure;
        imshow(colored_images_RGB{i});
    end
    
    anpassung = anpassung * 2;
    
end




%computing a four-level multiresolution pyramid of 
%the initial _R image image.
%I0 = images_R{9};  %works with 1
%I0_3dim = I0(:,:,1);
%I1 = impyramid(I0, 'reduce');
%I1_3dim = I1(:,:,1);
%I2 = impyramid(I1, 'reduce');
%I2_3dim = I2(:,:,1);
%I3 = impyramid(I2, 'reduce');
%I3_3dim = I3(:,:,1);
%I4 = impyramid(I3, 'reduce');
%I4_3dim = I4(:,:,1);
%I5 = impyramid(I4, 'reduce');
%I5_3dim = I5(:,:,1);
%I6 = impyramid(I5, 'reduce');
%I6_3dim = I6(:,:,1);

%size(images_R{1})  -> 3 dim 
%size(I0)           -> 4 dim --> einen channel rausholen  





% imshow(I0_3dim)
% figure, imshow(I1_3dim)
% figure, imshow(I2_3dim)
% figure, imshow(I3_3dim)
% figure, imshow(I4_3dim)
% figure, imshow(I5_3dim)
% 
% %variables for automatical alignment
% %[m, n] = size(images_R{1});
% colored_images_RGB = cell(images_nr, 1);
% 
% %align jeweils 3 images with the best match - do this 6 times,
% %cause there are 6 colored images to be generated
% for i = 1:1 %images_nr
%     [m, n] = size(images_R{9});
%     tempCorrR = 0;
%     tempCorrG = 0;
%     bestCorrR = 0;
%     bestCorrG = 0;
%     tempR = zeros(m, n);
%     tempG = zeros(m, n);
%     chosenR = zeros(m, n);
%     chosenG = zeros(m, n);
%     %verschieben jeweils image_R und image_G, vergleichen sie
%     %dann mit image_B, welche fix bleibt
% 
%     B = images_B{9};
%     B_rgb = B(:,:,1);
%     chosenB = B_rgb;
%     
%     %verschiebung untersuchen - possible displacements: 
%     %[-15, 15] pixels, in jeweils 4 Richtungen (up, down,
%     %left, right)
%     for j = -15:15
%         for k = -15:15
%             %vertikaler shift um k und horizontaler shift
%             %um j von image_R; wenn k>0 shift nach rechts,
%             %wenn j>0 shift nach unten
%             R = images_R{9};
%             R_rgb = R(:,:,1);
%             tempR = circshift(R_rgb, [j,k]);
%             tempCorrR = corr2(tempR, chosenB);
%             if (tempCorrR > bestCorrR)
%                 bestCorrR = tempCorrR;
%                 chosenR = tempR;
%             end
%             
%             %vertikaler shift um k und horizontaler shift
%             %um j von image_G; wenn k>0 shift nach rechts,
%             %wenn j>0 shift nach unten
%             G = images_G{9};
%             G_rgb = G(:,:,1);
%             tempG = circshift(G_rgb, [j,k]);
%             tempCorrG = corr2(tempG, chosenB);
%             if (tempCorrG > bestCorrG)
%                 bestCorrG = tempCorrG;
%                 chosenG = tempG;
%             end
%         end
%     end
%     colored_images_RGB{i} = cat(3, chosenR, chosenG, chosenB);
%     
%     %test
%     figure;
%     imshow(colored_images_RGB{i});
%     
%     %colored image 3 ist nicht perfekt...
% end

toc;

