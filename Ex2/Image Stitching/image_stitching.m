

%% tutorial of vlfeat sift http://www.vlfeat.org/overview/sift.html

function image_stitching
    % vlfeat initialization, onetime setup
    run('vlfeat-0.9.19-bin/vlfeat-0.9.19/toolbox/vl_setup');

    % image loading example
    function [single_im, color_im] = loadIm(path)
        color_im = im2double(imread(path));
        single_im = single(rgb2gray(color_im));
    end
    [sImg1, cImg1] = loadIm('officeview1.jpg');
    [sImg2, cImg2] = loadIm('officeview2.jpg');
    [f1,d1] = vl_sift(sImg1);
    [f2,d2] = vl_sift(sImg2);
    
    % show features
    imshow(sImg1);
    hold on;
    vl_plotframe(f1);
    
    % calculate matches between images
    [matches, scores] = vl_ubcmatch(d1, d2) ;
    numMatches = size(matches, 2);
    match_plot(sImg1, sImg2, f1(1:2, matches(1, :))', f2(1:2, matches(2, :))');
    
    best_trafo = [];
    best_inliers_num = 0;
    best_inliers = [];
    for i=1:10000
        % choose 4 random match indices
        chosen = randsample(numMatches, 4);
        chosenPointsIm1 = f1(1:2, matches(1, chosen));
        chosenPointsIm2 = f2(1:2, matches(2, chosen));

        try
            % calculate transformation from image1 to image2
            trafo = cp2tform(chosenPointsIm1', chosenPointsIm2', 'projective');
            [X Y] = tformfwd(trafo, f1(1, matches(1, :))', f1(2, matches(1, :))');
            pa = [X Y];
            pb = f2(1:2, matches(1, :))';
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
    
    best_inliers_num
    % reestimate
    reestimatePoints1 = f1(1:2, matches(1, best_inliers));
    reestimatePoints2 = f2(1:2, matches(2, best_inliers));
    best_trafo = cp2tform(reestimatePoints1', reestimatePoints2', 'projective');
    
    sImg1_transformed = imtransform(sImg1, best_trafo,'xdata',[1,size(sImg2,2)],'ydata',[1,size(sImg2,1)],'xyscale',[1,1]);
    mask = (sImg1_transformed > 0);
    imshow(mask .* sImg1_transformed + ~mask .* sImg2);
end