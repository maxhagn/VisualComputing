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

distanceX = x2 - x1;
distanceY = y2 - y1;




incrementX = sign(distanceX);
incrementY = sign(distanceY);

if distanceX < 0 % x1 > x2
    distanceX = abs(distanceX);
end
if distanceY < 0 % y1 > y2
    distanceY = abs(distanceY);
end

if distanceX > distanceY
    shiftX = incrementX;
    shiftY = 0;
    ddx = incrementX;
    ddy = incrementY;
    slowDirection = distanceY;
    fastDirection = distanceX;
else
    shiftX = 0;
    shiftY = incrementY;
    ddx = incrementX;
    ddy = incrementY;
    slowDirection = distanceX;
    fastDirection = distanceY;
end

xValue = x1;
yValue = y1;
error = fastDirection/2; % Anfangswert
framebuffer.setPixel(xValue,yValue,MeshVertex.mix(depth1,depth2,0.5),MeshVertex.mix(v1.getColor(),v2.getColor(),0.5))


for i = 1:fastDirection
    error = error - slowDirection;

    if error < 0
        error = error + fastDirection;
        xValue = xValue + ddx;
        yValue = yValue + ddy;
        
    else
        xValue = xValue + shiftX;
        yValue = yValue + shiftY;
    end

    %ACHTUNG: Dieser Koeffizient t kann ausschließlich Werte aus dem abgeschlossenen Intervall [0, 1] annehmen.
    % Um diesen Koeffizienten zu berechnen, kann die Strecke zwischen dem ersten Endpunkt und dem aktuell zu rasterisierenden Pixel 
    % durch die Gesamtstrecke der Linie dividiert werden. Das Ergebnis beschreibt dann die normalisierte Distanz des aktuellen Pixels vom ersten Endpunkt.
    farbe = (sqrt((x1-xValue)^2 + (y1-yValue)^2) / sqrt((x1-x2)^2+(y1-y2)^2) );
    framebuffer.setPixel(xValue,yValue,MeshVertex.mix(depth1,depth2,farbe),MeshVertex.mix(v1.getColor(),v2.getColor(),farbe))


end

end
