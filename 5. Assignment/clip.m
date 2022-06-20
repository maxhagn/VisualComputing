%
% Copyright 2022 TU Wien.
% Institute of Computer Graphics and Algorithms.
%

function [clipped_mesh] = clip(mesh, clipping_planes)
%CLIP clips all faces in the mesh M against every clipping plane defined in
%   clipplanes.
%     mesh              ... mesh object to clip
%     clipping_planes   ... array of clipping planes to clip against
%     clipped_mesh      ... clipped mesh

clipped_mesh = Mesh;

for f = 1:numel(mesh.faces)
    positions = mesh.getFace(f).getVertex(1:mesh.faces(f)).getPosition();
    colors = mesh.getFace(f).getVertex(1:mesh.faces(f)).getColor();
    vertex_count = 3;
    for i = 1:numel(clipping_planes)
        [vertex_count, positions, colors] = clipPlane(vertex_count, positions, colors, clipping_planes(i));
    end
    if vertex_count ~= 0
        clipped_mesh.addFace(vertex_count, positions, colors);
    end
end

end

function [vertex_count_clipped, pos_clipped, col_clipped] = clipPlane(vertex_count, positions, colors, clipping_plane)
%CLIPPLANE clips all vertices defined in positions against the clipping
%          plane clipping_plane. Clipping is done by using the Sutherland
%          Hodgman algorithm.
%     vertex_count          ... number of vertices of the face that is clipped
%     positions             ... n x 4 matrix with positions of n vertices
%                               one row corresponds to one vertex position
%     colors                ... n x 3 matrix with colors of n vertices
%                               one row corresponds to one vertex color
%     clipping_plane        ... plane to clip against
%     vertex_count_clipped  ... number of resulting vertices after clipping;
%                               this number depends on how the plane intersects
%                               with the face and therefore is not constant
%     pos_clipped           ... n x 4 matrix with positions of n clipped vertices
%                               one row corresponds to one vertex position
%     col_clipped           ... n x 3 matrix with colors of n clipped vertices
%                               one row corresponds to one vertex color

% TODO 2:   Implement this function.
% HINT 1: 	Read the article about Sutherland Hodgman algorithm on Wikipedia.
%           https://en.wikipedia.org/wiki/Sutherland%E2%80%93Hodgman_algorithm
%           Read the tutorial.m for further explanations!
% HINT 2: 	There is an edge between every consecutive vertex in the positions
%       	matrix. Note: also between the last and first entry!

% NOTE:     The following lines can be removed. They prevent the framework
%           from crashing.

pos_clipped = zeros(0, 4);
col_clipped = zeros(0, 3);
vertex_count_clipped = 0;

if (vertex_count > 0)

    current_vertex = positions(vertex_count, :);
    current_color = colors(vertex_count, :);

    for i = 1:vertex_count

        next_vertex = positions(i, :);
        next_color = colors(i, :);

        if (clipping_plane.inside(current_vertex) && clipping_plane.inside(next_vertex))

            pos_clipped = [pos_clipped; next_vertex];
            col_clipped = [col_clipped; next_color];

            vertex_count_clipped = vertex_count_clipped + 1;

        elseif (clipping_plane.inside(current_vertex))

            intersection = clipping_plane.intersect(current_vertex, next_vertex);

            pos_clipped = [pos_clipped; MeshVertex.mix(current_vertex, next_vertex, intersection)];
            col_clipped = [col_clipped; MeshVertex.mix(current_color, next_color, intersection)];

            vertex_count_clipped = vertex_count_clipped + 1;

        elseif (clipping_plane.inside(next_vertex))

            intersection = clipping_plane.intersect(current_vertex, next_vertex);

            pos_clipped = [pos_clipped; MeshVertex.mix(current_vertex, next_vertex, intersection)];
            col_clipped = [col_clipped; MeshVertex.mix(current_color, next_color, intersection)];

            pos_clipped = [pos_clipped; next_vertex];
            col_clipped = [col_clipped; next_color];

            vertex_count_clipped = vertex_count_clipped + 2;

        end
        
        current_vertex = next_vertex;
        current_color = next_color;

    end
end

end
