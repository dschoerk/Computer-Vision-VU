%TODO: 
%   Summary of this function goes here
%   Detailed explanation goes here


function [ pyramid, pyramid_channel ] = generatePyramids( image, levels )

%Output-arrays
pyramid = cell(levels, 1);
pyramid_channel = cell(levels, 1);

    img = image;
    pyramid{1} = img;
    tempPy = pyramid{1};
    pyramid_channel{1} = tempPy(:,:,1);
    %computing a level-times multiresolution pyramid of 
    %the initial image image.
    for i = 2:levels  
        pyramid{i} = impyramid(pyramid{i-1}, 'reduce');
        tempPy = pyramid{i};
        pyramid_channel{i} = tempPy(:,:,1);
    end

end

