function image_stitching_C
    % vlfeat initialization, onetime setup
    run('vlfeat-0.9.19-bin/vlfeat-0.9.19/toolbox/vl_setup');

        % image loading example
    function [single_im, color_im] = loadIm(path)
        color_im = im2double(imread(path));
        single_im = single(rgb2gray(color_im));
    end
    function [ best_trafo ] = image_stitch( Img1,Img2 )
        
        [f1,d1] = vl_sift(sImg1);
        [f2,d2] = vl_sift(sImg2);
    
        % show features
        %imshow(sImg1);
        %hold on;
        %vl_plotframe(f1);
    
        % calculate matches between images
        [matches, scores] = vl_ubcmatch(d1, d2) ;
        numMatches = size(matches, 2);
        %match_plot(sImg1, sImg2, f1(1:2, matches(1, :))', f2(1:2, matches(2, :))');
    
        best_trafo = [];
        best_inliers_num = 0;
        best_inliers = [];
        for i=1:1000
            % choose 4 random match indices
            chosen = randsample(numMatches, 4);
            chosenPointsIm1 = f1(1:2, matches(1, chosen));
            chosenPointsIm2 = f2(1:2, matches(2, chosen));

            try
                % calculate transformation from image1 to image2
                trafo = cp2tform(chosenPointsIm1', chosenPointsIm2', 'projective');
                [X Y] = tformfwd(trafo, f1(1, matches(1, :))', f1(2, matches(1, :))');
                pa = [X Y];
                pb = f2(1:2, matches(2, :))';
                inliers = sum((pa-pb).^2, 2) < 5^2;
                inlier_num = sum(inliers);
                if(inlier_num > best_inliers_num)
                    best_inliers_num = inlier_num;
                    best_trafo = trafo;
                    best_inliers = inliers;
                end
            catch ME
                if (~strcmp(ME.identifier, 'images:cp2tform:rankError'))
                    rethrow(ME); 
                end
            end
    end
    
    %best_inliers_num
    % reestimate
    reestimatePoints1 = f1(1:2, matches(1, best_inliers));
    reestimatePoints2 = f2(1:2, matches(2, best_inliers));
    best_trafo = cp2tform(reestimatePoints1', reestimatePoints2', 'projective');
    end
    
    [sImg1, cImg1] = loadIm('Campus1.jpg');
    [sImg2, cImg2] = loadIm('Campus2.jpg');
    [sImg3, cImg3] = loadIm('Campus3.jpg');
    [sImg4, cImg4] = loadIm('Campus4.jpg');
    [sImg5, cImg5] = loadIm('Campus5.jpg');
    
    H12 = image_stitch(sImg1,sImg2);
    H23 = image_stitch(sImg2,sImg3);
    H34 = image_stitch(sImg3,sImg4);
    H45 = image_stitch(sImg4,sImg5);
    
    %Image 3 is the center image => the reference Image
    H13 = maketform('projective', H23.tdata.T * H12.tdata.T);
    H53 = maketform('projective', H34.tdata.Tinv * H45.tdata.Tinv);
    H43 = maketform('projective', H34.tdata.Tinv);
    Identity = [1 0 0; 0 1 0; 0 0 1];
    H3 = maketform('projective', Identity);%projection of image3 is the identity

   %________only if your matlabversion supports projective2d_______________
   %convert the Matrices in projective2d, to use the function outputLimits.  
   %H3tmp = projective2d(H3.tdata.T);  
   %H13tmp = projective2d(H23.tdata.T * H12.tdata.T);
   %H23tmp = projective2d(H23.tdata.T);
   %H43tmp = projective2d(H34.tdata.Tinv);
   %H53tmp = projective2d(H34.tdata.Tinv * H45.tdata.Tinv);
   %_______________________________________________________________________
    
    %get the sizes of the images
    size1 = size(sImg1);
    size2 = size(sImg2);
    size3 = size(sImg3);  
    size4 = size(sImg4);
    size5 = size(sImg5);
    
    %________only if your matlabversion supports projective2d_______________
    %get the x and y limit from each image     
    %[xlimits(1,:), ylimits(1,:)] = outputLimits(H13tmp, [1 size1(2)], [1 size1(1)]);    
    %[xlimits(2,:), ylimits(2,:)] = outputLimits(H23tmp, [1 size2(2)], [1 size2(1)]);
    %[xlimits(3,:), ylimits(3,:)] = outputLimits(H3tmp, [1 size3(2)], [1 size3(1)]);
    %[xlimits(4,:), ylimits(4,:)] = outputLimits(H43tmp, [1 size4(2)], [1 size4(1)]);
    %[xlimits(5,:), ylimits(5,:)] = outputLimits(H53tmp, [1 size5(2)], [1 size5(1)]);
    
    %calculate the minimum and maximum values
    %x_min = min([1; xlimits(:)])
    %x_max = max([size3(2); xlimits(:)])

    %y_min = min([1; ylimits(:)])
    %y_max = max([size3(1); ylimits(:)])
    %_______________________________________________________________________
    
    
    %_____________if your matlabversion dont support projective2d___________
    %set up the cornerpoints from each image
    data1 = [1 1 1; 1 size1(1) 1; size1(2) 1 1; size1(2) size1(1) 1];
    data2 = [1 1 1; 1 size2(1) 1; size2(2) 1 1; size2(2) size2(1) 1];
    data3 = [1 1 1; 1 size3(1) 1; size3(2) 1 1; size3(2) size3(1) 1];
    data4 = [1 1 1; 1 size4(1) 1; size4(2) 1 1; size4(2) size4(1) 1];
    data5 = [1 1 1; 1 size5(1) 1; size5(2) 1 1; size5(2) size5(1) 1];
    
    %transform the cornerpoints to the outputimage to get the coordinates
    for i = 1:4
       val = data1(i,:) * H13.tdata.T;%transform
       xlim(i) = val(1)/val(3);       %x = x/z  because of projective transformation
       ylim(i) = val(2)/val(3);       %y = y/z 
       
       val = data2(i,:) * H23.tdata.T;
       xlim(i+4) = val(1)/val(3);
       ylim(i+4) = val(2)/val(3);
       
       val = data3(i,:) * H3.tdata.T;
       xlim(i+8) = val(1)/val(3);
       ylim(i+8) = val(2)/val(3); 
       
       val = data4(i,:) * H43.tdata.T;
       xlim(i+12) = val(1)/val(3);
       ylim(i+12) = val(2)/val(3);
       
       val = data5(i,:) * H53.tdata.T;
       xlim(i+16) = val(1)/val(3);
       ylim(i+16) = val(2)/val(3);
        
    end
    %calculate the min and maximal coordinates
    x_max = max (xlim);
    x_min = min (xlim);
    y_max = max (ylim);
    y_min = min (ylim);
    %_______________________________________________________________________
    
    %calculate the size of the output image
    output_width  = round(x_max - x_min);
    output_height = round(y_max - y_min);
    
    %initialize the outputimage
    stichedimage = zeros(output_height,output_width,3);
    
    %transform all the images to the outputimage
   cImg1_transformed =  imtransform(cImg1, H13,'xdata',[x_min,x_max],'ydata',[y_min,y_max],'xyscale',[1,1]);
   cImg2_transformed =  imtransform(cImg2, H23,'xdata',[x_min,x_max],'ydata',[y_min,y_max],'xyscale',[1,1]);
   cImg4_transformed =  imtransform(cImg4, H43,'xdata',[x_min,x_max],'ydata',[y_min,y_max],'xyscale',[1,1]);
   cImg5_transformed =  imtransform(cImg5, H53,'xdata',[x_min,x_max],'ydata',[y_min,y_max],'xyscale',[1,1]);
   cImg3_transformed =  imtransform(cImg3, H3,'xdata',[x_min,x_max],'ydata',[y_min,y_max],'xyscale',[1,1]);
    
    %set all pixels, who are not image pixels, black
    mask1 = (cImg1_transformed > 0);
    mask2 = (cImg2_transformed > 0);
    mask4 = (cImg4_transformed > 0);
    mask5 = (cImg5_transformed > 0);
    mask3 = (cImg3_transformed > 0);
    
    tmp1 = mask1 .* cImg1_transformed;
    tmp2 = mask2 .* cImg2_transformed;
    tmp4 = mask4 .* cImg4_transformed;
    tmp5 = mask5 .* cImg5_transformed;
    tmp3 = mask3 .* cImg3_transformed;
    
    %show the image for each image
    imshow(tmp1+tmp2+tmp3+tmp4+tmp5);
    
    %calculate the image where only one image set the imagecolor of the
    %overlay areas
    withoutfeather = tmp1;
    [hoehe,breite,tiefe] = size(withoutfeather);

    for i = 1:breite
        for j = 1:hoehe
           if withoutfeather(j,i) == 0
               withoutfeather(j,i,:) = tmp2(j,i,:);
           end
           if withoutfeather(j,i) == 0
               withoutfeather(j,i,:) = tmp3(j,i,:);
           end
           if withoutfeather(j,i) == 0
               withoutfeather(j,i,:) = tmp4(j,i,:);
           end
           if withoutfeather(j,i) == 0
               withoutfeather(j,i,:) = tmp5(j,i,:);
           end
        end
    end
    figure
    imshow(withoutfeather);
    
    %feathering
    %create alphamask
    alphamask1 = zeros(size1(1),size1(2)); % all zeros
    alphamask1(1,:) = 1;                   %the "borderpixels" to 1
    alphamask1(size1(1),:) = 1;
    alphamask1(:,1) = 1;
    alphamask1(:,size1(2)) = 1;
    alphamask1 = bwdist(alphamask1);       %calculate the distances
    alphamask1 = alphamask1 ./ max(max(alphamask1)); %get the distances between [0,1]
    alphamask1(:,:,2) = alphamask1(:,:,1);
    alphamask1(:,:,3) = alphamask1(:,:,1);
    
    alphamask2 = zeros(size2(1),size2(2));
    alphamask2(1,:) = 1;                   %the "borderpixels" to 1
    alphamask2(size2(1),:) = 1;
    alphamask2(:,1) = 1;
    alphamask2(:,size2(2)) = 1;
    alphamask2 = bwdist(alphamask2);       %calculate the distances
    alphamask2 = alphamask2 ./ max(max(alphamask2)); %get the distances between [0,1]
    alphamask2(:,:,2) = alphamask2(:,:,1);
    alphamask2(:,:,3) = alphamask2(:,:,1);
    
    alphamask3 = zeros(size3(1),size3(2));
    alphamask3(1,:) = 1;                   %the "borderpixels" to 1
    alphamask3(size3(1),:) = 1;
    alphamask3(:,1) = 1;
    alphamask3(:,size3(2)) = 1;
    alphamask3 = bwdist(alphamask3);       %calculate the distances
    alphamask3 = alphamask3 ./ max(max(alphamask3)); %get the distances between [0,1]
    alphamask3(:,:,2) = alphamask3(:,:,1);
    alphamask3(:,:,3) = alphamask3(:,:,1);
    
    alphamask4 = zeros(size4(1),size4(2));
    alphamask4(1,:) = 1;                   %the "borderpixels" to 1
    alphamask4(size4(1),:) = 1;
    alphamask4(:,1) = 1;
    alphamask4(:,size4(2)) = 1;
    alphamask4 = bwdist(alphamask4);       %calculate the distances
    alphamask4 = alphamask4 ./ max(max(alphamask4)); %get the distances between [0,1]
    alphamask4(:,:,2) = alphamask4(:,:,1);
    alphamask4(:,:,3) = alphamask4(:,:,1);
    
    alphamask5 = zeros(size5(1),size5(2));
    alphamask5(1,:) = 1;                   %the "borderpixels" to 1
    alphamask5(size5(1),:) = 1;
    alphamask5(:,1) = 1;
    alphamask5(:,size1(2)) = 1;
    alphamask5 = bwdist(alphamask5);       %calculate the distances
    alphamask5 = alphamask5 ./ max(max(alphamask5)); %get the distances between [0,1]
    alphamask5(:,:,2) = alphamask5(:,:,1);
    alphamask5(:,:,3) = alphamask5(:,:,1);
    
    %transform masks
    alphamask1_transformed =  imtransform(alphamask1, H13,'xdata',[x_min,x_max],'ydata',[y_min,y_max],'xyscale',[1,1]);
    alphamask2_transformed =  imtransform(alphamask2, H23,'xdata',[x_min,x_max],'ydata',[y_min,y_max],'xyscale',[1,1]);
    alphamask4_transformed =  imtransform(alphamask4, H43,'xdata',[x_min,x_max],'ydata',[y_min,y_max],'xyscale',[1,1]);
    alphamask5_transformed =  imtransform(alphamask5, H53,'xdata',[x_min,x_max],'ydata',[y_min,y_max],'xyscale',[1,1]);
    alphamask3_transformed =  imtransform(alphamask3, H3,'xdata',[x_min,x_max],'ydata',[y_min,y_max],'xyscale',[1,1]);

    %multiply the images with the masks  
    tmp1 = alphamask1_transformed .* tmp1;
    tmp2 = alphamask2_transformed .* tmp2;
    tmp4 = alphamask4_transformed .* tmp4;
    tmp5 = alphamask5_transformed .* tmp5;
    tmp3 = alphamask3_transformed .* tmp3;
       
    %add all masks for normalization
    normalize = alphamask1_transformed + alphamask2_transformed + alphamask3_transformed + alphamask4_transformed + alphamask5_transformed;
    %add all images
    output = tmp1 + tmp2 + tmp3 + tmp4 + tmp5;
    
    
    %normalize the sum of all images
    output = output ./normalize;
    figure
    imshow(output);
end

