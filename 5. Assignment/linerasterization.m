%
% Copyright 2022 TU Wien.
% Institute of Computer Graphics and Algorithms.
%

function linerasterization(mesh, framebuffer)
%LINERASTERIZATION iterates over all faces of mesh and draws lines between
%                  their vertices.
%     mesh                  ... mesh object to rasterize
%     framebuffer           ... framebuffer

for i = 1:numel(mesh.faces)
    for j = 1:mesh.faces(i)
        v1 = mesh.getFace(i).getVertex(j);
        v2 = mesh.getFace(i).getVertex(mod(j, mesh.faces(i))+1);
        drawLine(framebuffer, v1, v2);
    end
end
end

function drawLine(framebuffer, v1, v2)
%DRAWLINE draws a line between v1 and v2 into the framebuffer using the
%               Bresenham algorithm.
%     framebuffer           ... framebuffer
%     v1                    ... vertex 1
%     v2                    ... vertex 2

[x1, y1, depth1] = v1.getScreenCoordinates();
[x2, y2, depth2] = v2.getScreenCoordinates();

% TODO 1: Implement this function.

color_1 = v1.getColor();
color_2 = v2.getColor();

dx = x2 - x1;
dy = y2 - y1;

sdx = sign(dx);
sdy = sign(dy);

adx = abs(dx);
ady = abs(dy);

if (adx > ady)
    pdx = sdx;
    pdy = 0;
    ddx = sdx;
    ddy = sdy;
    delta_slow_direction = ady;
    delta_fast_direction = adx;
else
    pdx = 0;
    pdy = sdy;
    ddx = sdx;
    ddy = sdy;
    delta_slow_direction = adx;
    delta_fast_direction = ady;
end

x = x1;
y = y1;

error = delta_fast_direction / 2;

interpolation_factor = 0;

framebuffer.setPixel(x, y, MeshVertex.mix(depth1, depth2, interpolation_factor),MeshVertex.mix(color_1, color_2, interpolation_factor))

for i = 1:delta_fast_direction

    error = error - delta_slow_direction;

    if (error < 0)
        error = error + delta_fast_direction;
        x = x + ddx;
        y = y + ddy;
        
    else
        x = x + pdx;
        y = y + pdy;
    end

    interpolation_factor = interpolation_factor + 1 / delta_fast_direction;

    framebuffer.setPixel(x, y, MeshVertex.mix(depth1, depth2, interpolation_factor), MeshVertex.mix(color_1, color_2, interpolation_factor))

end

end
