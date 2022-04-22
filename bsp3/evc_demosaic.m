%
% Copyright 2022 TU Wien.
% Institute of Computer Graphics and Algorithms.
%

function [result, fnc_demosaic_pattern, fnc_transform_neutral, fnc_interpolate, fnc_concat] = evc_demosaic(input, asShotNeutral)
% This function is our main function. It executes all functions, that were
% implemented by you, in the correct order.

% ATTENTION: You are not allowed to change this function!

fnc_demosaic_pattern = @(input) evc_demosaic_pattern(input);
fnc_transform_neutral = @(R, G, B, asShotNeutral) evc_transform_neutral(R, G, B, asShotNeutral);
fnc_interpolate = @(R, G, B) evc_interpolate(R, G, B);
fnc_concat = @(R, G, B) evc_concat(R, G, B);

[R, G, B] = evc_demosaic_pattern(input);
[R, G, B] = evc_transform_neutral(R, G, B, asShotNeutral);
[R, G, B] = evc_interpolate(R, G, B);
result = evc_concat(R, G, B);

end

function [R, G, B] = evc_demosaic_pattern(input)
%evc_demosaic_pattern extracts the red, green and blue values of the
% 'input' image. Results are stored in the R, G, B variables.

%   INPUT
%   input...            Bayer-Pattern image

%   OUTPUT
%   R...                red channel of the image (without interpolation)
%   G...                green channel of the image (without interpolation)
%   B...                blue channel of the image (without interpolation)

% TODO: Implement this function.
% HINT: For this task the "start:skip:end" selection might be useful.
%       Find the correct Bayer-Pattern depending on your dataset.
%       No interpolation needs to be performed here!

% NOTE: The following three lines can be removed. They prevent the framework
%       from crashing.

% GBRG

R = zeros(size(input));
G = zeros(size(input));
B = zeros(size(input));

% RGGB
% R(1:2:end, 1:2:end) = input(1:2:end, 1:2:end); % 1...red
% B(2:2:end, 2:2:end) = input(2:2:end, 2:2:end); % 1...blue
% G(2:2:end, 1:2:end) = input(2:2:end, 1:2:end); % 1...green
% G(1:2:end, 2:2:end) = input(1:2:end, 2:2:end); % 1...green

% BGGR
% R(2:2:end, 2:2:end) = input(2:2:end, 2:2:end); % 1...red
% B(1:2:end, 1:2:end) = input(1:2:end, 1:2:end); % 1...blue
% G(2:2:end, 1:2:end) = input(2:2:end, 1:2:end); % 1...green
% G(1:2:end, 2:2:end) = input(1:2:end, 2:2:end); % 1...green

% GRBG
B(2:2:end, 1:2:end) = input(2:2:end, 1:2:end); % 1...red
R(1:2:end, 2:2:end) = input(1:2:end, 2:2:end); % 1...blue
G(1:2:end, 1:2:end) = input(1:2:end, 1:2:end); % 1...green
G(2:2:end, 2:2:end) = input(2:2:end, 2:2:end); % 1...green

% GBRG
% R(1:2:end, 1:2:end) = input(1:2:end, 1:2:end); % 1...red
% B(2:2:end, 2:2:end) = input(2:2:end, 2:2:end); % 1...blue
% G(2:2:end, 1:2:end) = input(2:2:end, 1:2:end); % 1...green
% G(1:2:end, 2:2:end) = input(1:2:end, 2:2:end); % 1...green

end

function [R, G, B] = evc_transform_neutral(R, G, B, asShotNeutral)
%evc_transform_neutral changes the red, green and blue channels depending
% on the neutral white value (asShotNeutral). Therefore every channel needs
% to be divided by the respective channel of the white value.

%   INPUT
%   R...                red channel of the image
%   G...                green channel of the image
%   B...                blue channel of the image
%   asShotNeutral... 	neutral white value (RGB vector)

%   OUTPUT
%   R...                red channel of the image (changed by neutral white value)
%   G...                green channel of the image (changed by neutral white value)
%   B...                blue channel of the image (changed by neutral white value)

% TODO: Implement this function.
% NOTE: The following three lines can be removed. They prevent the framework
%       from crashing.

R = R/asShotNeutral(1);
G = G/asShotNeutral(2);
B = B/asShotNeutral(3);

end

function [R, G, B] = evc_interpolate(R, G, B)
%evc_interpolate interpolates the red, green and blue channels. In the
% final image, every pixel now has red, green and blue values.

%   INPUT
%   R...                red channel of the image
%   G...                green channel of the image
%   B...                blue channel of the image

%   OUTPUT
%   R...                red channel of the image (without missing values)
%   G...                green channel of the image (without missing values)
%   B...                blue channel of the image (without missing values)

% TODO: Implement this function.
% HINT: The function 'imfilter' might be useful.
% NOTE: The following three lines can be removed. They prevent the framework
%       from crashing.

R_Filter = [0.25, 0.5,  0.25;
            0.5,  1,    0.5;
            0.25, 0.5,  0.25];

G_Filter = [0,    0.25, 0;
            0.25, 1,    0.25;
            0,    0.25, 0];

B_Filter = [0.25, 0.5,  0.25;
            0.5,  1,    0.5;
            0.25, 0.5,  0.25];

R = imfilter(R, R_Filter);
G = imfilter(G, G_Filter);
B = imfilter(B, B_Filter);

end

function [result] = evc_concat(R, G, B)
%evc_concat combines the three individual red, green and blue channels to a
% single image.

%   INPUT
%   R...                red channel of the image
%   G...                green channel of the image
%   B...                blue channel of the image

%   OUTPUT
%   result...           resulting image

% TODO: Implement this function.
% HINT: The function 'cat' might be useful.
% NOTE: The following line can be removed. It prevents the framework
%       from crashing.

result = cat(3,R,G,B);

end
