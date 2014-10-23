
%%%% parameters %%%%
sigma_start = 2; % sigma starting value, increased by times k
levels = 10; % const
k = 1.2; % const
threshold = 0.3; % const, minimum blob threshold
scale_factor = 1.0 % const % scale factor for input resolution
path = '../resources/butterfly.jpg';

% reading the input file
img = imread(path);
img = im2double(img);
dim = size(img);
img = imresize(img, dim * scale_factor);
dim = size(img);

pyr_images = zeros(dim(1), dim(2), levels); % pyramid levels
sigma = sigma_start;
for i=1:levels
    % generate kernel for level i
    kernelSize = 2*floor(3*sigma)+1; % see docu and imfilter
    kernel = fspecial('log', kernelSize, sigma);
    sigma = sigma * k;
    
    % generate pyramid image level i
    pyr_images(:,:,i) = imfilter(1-img, kernel, 'same', 'replicate');
    pyr_images(:,:,i) = pyr_images(:,:,i) .* (sigma * sigma);
    pyr_images(:,:,i) = pyr_images(:,:,i) .* (pyr_images(:,:,i) > threshold);
    %figure; imshow(pyr_images(:,:,i));
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

figure;
show_all_circles(img, bloby, blobx, radii);
