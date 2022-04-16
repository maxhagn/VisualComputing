%
% Copyright 2022 TU Wien.
% Institute of Computer Graphics and Algorithms.
%

function [result] = evc_white_balance(input, white)
%evc_white_balance performs white balancing manually.

%   INPUT
%   input       ... image
%   white       ... a color (as RGB vector) that should become the new white

%   OUTPUT
%   result      ... result after white balance

% TODO: perform white balancing using the 'white' variable
% HINT: Make sure the program does not crash if 'white' is zero!
% NOTE: pixels brighter than 'white' will have values > 1.
%       This requires a normalization which will be performed
%       during the histogram clipping.
% NOTE: The following line can be removed. It prevents the framework
%       from crashing.

redChannel = input(:, :, 1);
greenChannel = input(:, :, 2);
blueChannel = input(:, :, 3);

meanR = mean2(redChannel);
meanG = mean2(greenChannel);
meanB = mean2(blueChannel);
meanGray = mean2(white)

redChannel = uint8(double(redChannel) * meanGray / meanR);
greenChannel = uint8(double(greenChannel) * meanGray / meanG);
blueChannel = uint8(double(blueChannel) * meanGray / meanB);

result = cat(3, redChannel, greenChannel, blueChannel);

end
