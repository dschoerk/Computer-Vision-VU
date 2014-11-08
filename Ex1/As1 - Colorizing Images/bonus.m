% TODO - description
%   concat 3 big color channel images to just ONE hudge 
%   coloredimage

%variables
path = '../resources'; 
images_nr = 9; %6

%call loadImages function
[images_R, images_G, images_B] = loadImages(path, images_nr);

tic;

levels = 6; %4
[pyramid_R, pyramid_R_channel] = generatePyramids( images_R{1}, levels );
[pyramid_G, pyramid_G_channel] = generatePyramids( images_G{1}, levels );
[pyramid_B, pyramid_B_channel] = generatePyramids( images_B{1}, levels );

%levels = 8;
%[pyramid_R, pyramid_R_channel] = generatePyramids( images_R{9}, levels );
%[pyramid_G, pyramid_G_channel] = generatePyramids( images_G{9}, levels );
%[pyramid_B, pyramid_B_channel] = generatePyramids( images_B{9}, levels );

%For-Anpassungs-Parameter, damit es der kernel fuer die Suche nicht
%bei allen Levels der Pyramide gleich gross ist
tempCorrR = 0;
tempCorrG = 0;
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

power = 0;
anpassung = 2^power;%5;%4; %1;

for i = levels:-1:1
    [m, n] = size(pyramid_R_channel{i});
    
    bestCorrR = 0;
    bestCorrG = 0;
    
    power = power + 1;
    
    %verschieben jeweils image_R und image_G, vergleichen sie
    %dann mit image_B, welche fix bleibt

    B = pyramid_B_channel{i};
    chosenB = B;
  
    %verschiebung untersuchen - possible displacements: 
    %[-15, 15] pixels, in jeweils 4 Richtungen (up, down,
    %left, right)
    for j = (-anpassung) : anpassung %-15 : 15
        for k = (-anpassung) : anpassung %-15 : 15
            %vertikaler shift um k und horizontaler shift
            %um j von image_R; wenn k>0 shift nach rechts,
            %wenn j>0 shift nach unten
            R = pyramid_R_channel{i};
            tempR = circshift(R, [j,k]);
            tempCorrR = corr2(tempR, chosenB);
            if (abs(tempCorrR) > bestCorrR)
                bestCorrR = abs(tempCorrR);
                chosenJ_R = j;
                chosenK_R = k;
                if(i == 1)
                    chosenR = tempR; 
                end
            end
            
            %vertikaler shift um k und horizontaler shift
            %um j von image_G; wenn k>0 shift nach rechts,
            %wenn j>0 shift nach unten
            G = pyramid_G_channel{i};
            tempG = circshift(G, [j,k]);
            tempCorrG = corr2(tempG, chosenB);
            if (abs(tempCorrG) > bestCorrG)
                bestCorrG = abs(tempCorrG);
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
         pyramid_R_channel{i-1} = circshift(pyramid_R_channel{i-1}, [chosenJ_R * 2, chosenK_R * 2]);
         pyramid_G_channel{i-1} = circshift(pyramid_G_channel{i-1}, [chosenJ_G * 2, chosenK_G * 2]);
    end
   
    if(i == 1)
        colored_images_RGB = cat(3, chosenR, chosenG, chosenB);
    
        %test
        figure;
        imshow(colored_images_RGB);
    end
    
    if(anpassung < 16) 
        %anpassung = anpassung * 2;
        %anpassung = 2^anpassung;
        anpassung = 2^power;
    end
    
end


toc;

