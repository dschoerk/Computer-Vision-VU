%TODO: 
%   Summary of this function goes here
%   Detailed explanation goes here


function [ pyramid, pyramid_channel, levels_ ] = generatePyramids( image, kernel_width )

%Output-arrays
pyramid = cell(20, 1);   % 20 = ausreichend grosse array size, die auf jeden fall alle pyramiden umfassen soll
pyramid_channel = cell(20, 1);

    pyramid{1} = image;
    tempPy = pyramid{1};
    pyramid_channel{1} = tempPy(:,:,1);
    
    [m, n] = size(pyramid_channel{1});
    j = 1;
    kernel_size = kernel_width * 2 + 1;
    while (m > (4 * kernel_size))
        j = j + 1;
        pyramid{j} = impyramid(pyramid{j-1}, 'reduce');
        tempPy = pyramid{j};
        pyramid_channel{j} = tempPy(:,:,1);
        
        [m, n] = size(pyramid_channel{j});
    end
    
    levels_ = j;
end

