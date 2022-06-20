%
% Copyright 2022 TU Wien.
% Institute of Computer Graphics and Algorithms.
%

function fillrasterization(mesh, framebuffer)
%FILLRASTERIZATION iterates over all faces of mesh and rasterizes them
%       by coloring every pixel in the framebuffer covered by the triangle.
%       Faces with more than 3 vertices are triangulated after the clipping stage.
%     mesh                  ... mesh object to rasterize
%     framebuffer           ... framebuffer

for i = 1:numel(mesh.faces)
    v1 = mesh.getFace(i).getVertex(1);
    for j = 2:mesh.faces(i) - 1
        v2 = mesh.getFace(i).getVertex(j);
        v3 = mesh.getFace(i).getVertex(j+1);
        drawTriangle(framebuffer, v1, v2, v3);
    end
end
end

function drawTriangle(framebuffer, v1, v2, v3)
%drawTriangle draws a filled triangle between v1, v2 and v3 into the
%   framebuffer using barycentric coordinates. Therefore the bounding box
%   of the triangle is computed as the minimum and maximum screen
%   coordinates of the given vertices. Then every pixel of this bounding
%   box is traversed and line equations are used to determine whether a
%   pixel is inside or outside the triangle. Furthermore, those line
%   equations are helpful to compute the barycentric coordinates of this
%   pixel. Then the color can be easily interpolated with the
%   MeshVertex.barycentricMix() function.
%     framebuffer           ... framebuffer
%     v1                    ... vertex 1
%     v2                    ... vertex 2
%     v3                    ... vertex 3

[x1, y1, depth1] = v1.getScreenCoordinates();
[x2, y2, depth2] = v2.getScreenCoordinates();
[x3, y3, depth3] = v3.getScreenCoordinates();
col1 = v1.getColor();
col2 = v2.getColor();
col3 = v3.getColor();

% Calculate triangle area * 2
a = ((x3 - x1) * (y2 - y1) - (x2 - x1) * (y3 - y1));

if a ~= 0
    % Swap order of clockwise triangle to make them counter-clockwise
    if a < 0
        t = x2;
        x2 = x3;
        x3 = t;
        t = y2;
        y2 = y3;
        y3 = t;
        t = depth2;
        depth2 = depth3;
        depth3 = t;
        t = col2;
        col2 = col3;
        col3 = t;
    end

    % TODO 3: Implement this function.
    % HINT:   Don't forget to implement the function lineEq!
    %         Read the instructions and tutorial.m for further explanations!
    % BONUS:  Solve this task without using loops and without using loop
    %         emulating functions (e.g. arrayfun).

    e_1 = [x3; y3] - [x2; y2];
    e_2 = [x1; y1] - [x3; y3];
    e_3 = [x2; y2] - [x1; y1];

    e_1_normal = [-e_1(2), e_1(1)];  
    e_2_normal = [-e_2(2), e_2(1)];
    e_3_normal = [-e_3(2), e_3(1)];
    
    a_1 = e_1_normal(1);
    a_2 = e_2_normal(1);
    a_3 = e_3_normal(1);

    b_1 = e_1_normal(2);
    b_2 = e_2_normal(2);
    b_3 = e_3_normal(2);
    
    c_1 = -(a_1 * x2 + b_1 * y2);
    c_2 = -(a_2 * x3 + b_2 * y3);
    c_3 = -(a_3 * x1 + b_3 * y1);
    
    x_min = min([x1, x2, x3]);
    x_max = max([x1, x2, x3]);

    y_min = min([y1, y2, y3]);
    y_max = max([y1, y2, y3]);
    
    f_1 = 1 / lineEq(a_1, b_1, c_1, x1, y1);
    f_2 = 1 / lineEq(a_2, b_2, c_2, x2, y2);
    f_3 = 1 / lineEq(a_3, b_3, c_3, x3, y3);
        
    for x = x_min:x_max
        for y = y_min:y_max
            
            distance_1 = lineEq(a_1, b_1, c_1, x, y);
            distance_2 = lineEq(a_2, b_2, c_2, x, y);
            distance_3 = lineEq(a_3, b_3, c_3, x, y);
            
            if (distance_1 <= 0 && distance_2 <= 0 && distance_3 <= 0)
                
                alpha = lineEq(a_1, b_1, c_1, x, y) * f_1;
                beta  = lineEq(a_2, b_2, c_2, x, y) * f_2;
                gamma = lineEq(a_3, b_3, c_3, x, y) * f_3;
                
                color = MeshVertex.barycentricMix(col1, col2, col3, alpha, beta, gamma);
                depth = MeshVertex.barycentricMix(depth1, depth2, depth3, alpha, beta, gamma);
                
                framebuffer.setPixel(x, y, depth, color);
                
            end
        end
    end

end
end

function res = lineEq(A, B, C, x, y)
%lineEq defines the line equation described by the provided parameters and
%   returns the distance of a point (x, y) to this line.
%     A    ... line equation parameter 1
%     B    ... line equation parameter 2
%     C    ... line equation parameter 3
%     x    ... x coordinate of point to test against the line
%     y    ... y coordinate of point to test against the line
%     res  ... distance of the point (x, y) to the line (A, B, C).

% TODO 3:   Implement this function.
% NOTE:     The following lines can be removed. They prevent the framework
%           from crashing.

res = A * x + B * y + C;

end
