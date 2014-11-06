
function [] = ex2
    sigma_start = 2; % sigma starting value, increased by times k
    levels = 10; % const, pyramid levels
    k = 1.2; % const, sigma scale factor
    threshold = 0.3; % const, minimum blob threshold
    path = '../resources/butterfly.jpg';

    % reading the input file
    img = imread(path);
    img = im2double(img);
    dim = size(img);
    img_half = imresize(img, dim * 0.5);
    dim_half = size(img_half);

    [blobx1, bloby1, radii1, pyr1, localMax1] = blobdetection(img, sigma_start, levels, k, threshold);
    [blobx2, bloby2, radii2, pyr2, localMax2] = blobdetection(img_half, sigma_start, levels, k, threshold);
    
    figure;
    show_all_circles(img_half, bloby2, blobx2, radii2);
    figure;
    show_all_circles(img, bloby1, blobx1, radii1);
   
    [xi,yi,~] = impixel();
    xi_half = round( xi ./ dim(2) * dim_half(2));
    yi_half = round( yi ./ dim(1) * dim_half(1));
    
    v1 = squeeze(pyr1(yi,xi,1:levels));
    v2 = squeeze(pyr2(yi_half,xi_half,1:levels));
    figure;
    plot(1:levels, v1, 1:levels, v2, 1:levels, repmat(threshold,1,levels));
    hold on;
    m1 = squeeze(localMax1(yi,xi,1:levels));
    m2 = squeeze(localMax2(yi_half,xi_half,1:levels));
    stem(1:levels, m2);
    hold on;
    stem(1:levels, m1);
end