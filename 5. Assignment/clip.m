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

new_pos_clipped = zeros(0, 4);
new_col_clipped = zeros(0, 3);
new_vertex_count_clipped = 0;

if vertex_count > 0
    currentVertex = positions(vertex_count, :);
    currentColor = colors(vertex_count, :);

    for i = 1:vertex_count
        nextVertex = positions(i, :);
        nextColor = colors(i, :);
        if clipping_plane.inside(currentVertex) && clipping_plane.inside(nextVertex)
            % Both vertices are inside

            new_pos_clipped = [new_pos_clipped; nextVertex];
            new_col_clipped = [new_col_clipped; nextColor];

            new_vertex_count_clipped = new_vertex_count_clipped + 1;
        elseif clipping_plane.inside(nextVertex)
            % End vertex is inside

            intersection = clipping_plane.intersect(currentVertex, nextVertex);
            newIntersectionVertex = MeshVertex.mix(currentVertex, nextVertex, intersection); % Get new vertex with intersectionValue

            new_pos_clipped = [new_pos_clipped; newIntersectionVertex];
            new_col_clipped = [new_col_clipped; MeshVertex.mix(currentColor, nextColor, intersection)];

            new_pos_clipped = [new_pos_clipped; nextVertex];
            new_col_clipped = [new_col_clipped; nextColor];

            new_vertex_count_clipped = new_vertex_count_clipped + 2;
        elseif clipping_plane.inside(currentVertex)
            % Start vertex is inside

            intersection = clipping_plane.intersect(currentVertex, nextVertex);
            newIntersectionVertex = MeshVertex.mix(currentVertex, nextVertex, intersection); % Get new vertex with intersectionValue

            new_pos_clipped = [new_pos_clipped; newIntersectionVertex];
            new_col_clipped = [new_col_clipped; MeshVertex.mix(currentColor, nextColor, intersection)];

            new_vertex_count_clipped = new_vertex_count_clipped + 1;
        else
            % Both vertices are outside
            % Nothing to do here
        end
        
        currentVertex = nextVertex;
        currentColor = nextColor;
    end
end

pos_clipped = new_pos_clipped;
col_clipped = new_col_clipped;
vertex_count_clipped = new_vertex_count_clipped;

end
