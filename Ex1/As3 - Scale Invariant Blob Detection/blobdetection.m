function [blobx, bloby, radii, pyr_images, localMax] = blobdetection(img, sigma_start, levels, k, threshold)
    dim = size(img);

    pyr_images = zeros(dim(1), dim(2), levels); % pyramid levels
    sigma = sigma_start;
    for i=1:levels
        % generate kernel for level i
        kernelSize = 2*floor(3*sigma)+1; % see docu and imfilter
        kernel = fspecial('log', kernelSize, sigma);
        
        % generate pyramid image level i
        pyr_images(:,:,i) = imfilter(1-img, kernel, 'same', 'replicate');
        pyr_images(:,:,i) = pyr_images(:,:,i) .* (sigma * sigma);
        %figure; imshow(pyr_images(:,:,i));
        
        pyr_images(:,:,i) = pyr_images(:,:,i) .* (pyr_images(:,:,i) > threshold);
        sigma = sigma * k;
        
        figure;
        imshow(pyr_images(:,:,i));
    end

    

    localMax = zeros(dim(1), dim(2), levels);

    % 26 nhood mask
    msk = true(3,3,3);
    msk(2,2,2) = 0;

    % dilation as a maximum neighborhood function
    localMax = pyr_images > imdilate(pyr_images, msk); 

    % compute indices from blob matrices
    [blobx, bloby, blobz] = ind2sub(size(localMax), find(localMax));

    % calculate radius from blob level
    radii = k .^ (blobz-1) * sqrt(2) * sigma_start;

%    figure;
%    show_all_circles(img, bloby, blobx, radii);
end
