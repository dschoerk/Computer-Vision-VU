%generatePyramids: this function comutes the image pyramid
%   of an image given as parameters. This means that different   
%   levels in different sized of the image will be generated.
%   How many levels the pyramid will have, is determined by the
%   input parmameter kernel_width.
%   Finnaly the functions returns the Gaussian pyramid of the 
%   input image, as well as the number of generated levels the 
%   returned pyramid.

function [ pyramid, pyramid_channel, levels_ ] = generatePyramids( image, kernel_width )

    %Output-arrays
    pyramid = cell(20, 1);   % 20 = just a sufficient array size, which should contain all possibily generated pyramids
    pyramid_channel = cell(20, 1);

    %the first level of the resulting gaussian pyramid should
    %contain the image itsself
    pyramid{1} = image;
    tempPy = pyramid{1};
    %the channel pyramid contains merely a single channel of the actual 
    %returned gaussian pyramid.
    %This facilitates the displaying of the finally colrized image in the
    %bonus-class.
    pyramid_channel{1} = tempPy(:,:,1);
    
    %definition of necessary variables
    [m, n] = size(pyramid_channel{1});
    j = 1;
    %the kernel_size is computed using the input parameter kernel_width
    kernel_size = kernel_width * 2 + 1;
    %new levels of the pyramid will be generated, as long as the width of
    %the image in the respective pyramid level is still greater than 4
    %the kernel_size.
    %This meand that the smallest pyramid should be approximately 4 times
    %greater than the kernel.
    while (m > (4 * kernel_size))
        j = j + 1;
        %generation of next level of the pyramid
        pyramid{j} = impyramid(pyramid{j-1}, 'reduce');
        tempPy = pyramid{j};
        pyramid_channel{j} = tempPy(:,:,1);
        %the actual size of the pyramid is being updated
        [m, n] = size(pyramid_channel{j});
    end
    
    %the method also returned the number of generated levels the returned
    %pyramid has
    levels_ = j;
end

