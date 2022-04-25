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

r_inverse = realmax;
g_inverse = realmax;
b_inverse = realmax;

if (not(white(1) == 0))
    r_inverse = 1 / white(1);
end

if (not(white(2) == 0))
    g_inverse = 1 / white(2);
end

if (not(white(3) == 0))
    b_inverse = 1 / white(3);
end

R = input(:, :, 1) * r_inverse;
G = input(:, :, 2) * g_inverse;
B = input(:, :, 3) * b_inverse;

result = cat(3, R, G, B);

end
