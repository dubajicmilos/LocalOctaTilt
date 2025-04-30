% Load the .npy file using the 'readNPY' function, which requires the npy-matlab package.
% You can install it from: https://github.com/kwikteam/npy-matlab

close all
clc
clearvars

path_MA="MA_moldata.npy";
path_FA="FA_moldata.npy";


% Load data (either MA or FA moldata)
cnsn = readNPY(path_FA);  % Alternatively, 'FA_moldata.npy'

% Create a sphere mesh (equivalent to sphere_mesh in Python)
res = 80;
[u, v] = meshgrid(linspace(0, 2*pi, 2*res), linspace(0, pi, res));
xmesh = cos(u) .* sin(v);
ymesh = sin(u) .* sin(v);
zmesh = cos(v);

% Prepare the points matrix (equivalent to the points in Python)
points = cat(3, xmesh, ymesh, zmesh);
s = size(points);
S=s(1:2);
counting = zeros(S);

% Reshape the molecular data to match dimensions
cnsn = reshape(cnsn, [], 3);

% Calculate the dot product and update the counting matrix
for i = 1:size(cnsn, 1)
    dots = sum(points .* reshape(cnsn(i, :), [1 1 3]), 3);  % Dot product
    maxx = find(dots > 0.995);  % Equivalent to np.where in Python
    counting(maxx) = counting(maxx) + 1;
end

% Normalize the heatmap data
myheatmap = counting / max(counting(:));
movar = var(counting(:) / mean(counting(:)));


%% Plot the sphere with the heatmap data
figure;
h = surf(xmesh, ymesh, zmesh, myheatmap, 'EdgeColor', 'none');
colormap(magma)
caxis([0, 1]);
hold on;
axis equal;
view(37, 21)

% Define corner positions for the octahedra (these are the terminal axis positions)
corner_positions = [
    1, 1, 1;     % Top positions
    1, -1, 1;
    -1, 1, 1;
    -1, -1, 1;
    1, 1, -1;    % Bottom positions
    1, -1, -1;
    -1, 1, -1;
    -1, -1, -1;
];

% Define octahedron vertices centered at origin with unit length
octahedron_vertices = [
    1, 0, 0;
    -1, 0, 0;
    0, 1, 0;
    0, -1, 0;
    0, 0, 1;
    0, 0, -1;
];

% Define faces of the octahedron (each row is a triangle)
octahedron_faces = [
    1, 3, 5;
    1, 4, 5;
    2, 3, 5;
    2, 4, 5;
    1, 3, 6;
    1, 4, 6;
    2, 3, 6;
    2, 4, 6;
];

% Scale the octahedron to the desired radius
octahedron_radius = 0.3;  % Set desired size for octahedra
octahedron_vertices = octahedron_vertices * octahedron_radius;

% Plot the octahedra at each corner position with white faces and black edges
for i = 1:size(corner_positions, 1)
    % Shift the vertices to the corner position
    shifted_vertices = octahedron_vertices + corner_positions(i, :);

    % Plot the octahedron at the current corner position
    patch('Vertices', shifted_vertices, 'Faces', octahedron_faces, ...
          'FaceColor', 'w', 'EdgeColor', 'k', 'LineWidth', 0.5);  % White faces with black edges
end

%%



% Adjust limits to make sure the spheres are visible
xlim([-1.4, 1.4]);
ylim([-1.4, 1.4]);
zlim([-1.4, 1.4]);


% Set the background color to white
set(gcf, 'color', 'w');  % Set the figure background to white

% Hide the grid, box, and other axis elements, show only the X, Y, and Z axes
axis on;
box off;
grid off;

% Display only the X, Y, Z axes (without ticks)
set(gca, 'XColor', 'k', 'YColor', 'k', 'ZColor', 'k', ...  % Set axes color to black
    'XTick', [], 'YTick', [], 'ZTick', []);  % Hide tick marks

% Set the aspect ratio for the axes
daspect([1, 1, 1]);
