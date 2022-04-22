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

rScale = 1 / 0.0000000001;
if white(1) ~= 0
    rScale = 1 / white(1);
end

gScale = 1 / 0.0000000001;
if white(2) ~= 0
    gScale = 1 / white(2);
end

bScale = 1 / 0.0000000001;
if white(3) ~= 0
    bScale = 1 / white(3);
end

R = input(:, :, 1);
G = input(:, :, 2);
B = input(:, :, 3);

R = R * rScale;
G = G * gScale;
B = B * bScale;

result = cat(3, R, G, B);

end
