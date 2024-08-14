% Load a mesh
[V, F] = load_mesh('sphere.off');  

% Compute Mean Curvature and Normal Vector

% 2. Compute Cotangent Laplacian (L) and Mass Matrix (M)
L = cotmatrix(V, F);
M = massmatrix(V, F, 'barycentric');

% 3. Compute Mean Curvature Vector (H)
H = -inv(M) * (L * V);

% 4. Compute the Magnitude of Mean Curvature (mean curvature at each vertex)
mean_curvature = sqrt(sum(H.^2, 2));

% Compute the Normal Vector
normals = per_vertex_normals(V, F); 

% Compute Gaussian Curvature
gaussian_curvature = discrete_gaussian_curvature(V,F);

% Compute Laplacian of Mean Curvature
laplacian_H =  L * mean_curvature;  

% Compute the Gradient of Mean Curvature
% Use gptoolbox's gradient operator for scalar fields
grad_H = grad(V, F) * mean_curvature;

% Compute the new term: newthing
H_squared = mean_curvature .^ 2;
newthing = laplacian_H + ((H_squared - 2 * gaussian_curvature) .* mean_curvature) .* normals + mean_curvature .* grad_H;


% Define small arc equation
h = 0.1;  % Small parameter h
vertex = V;  % V contains the vertices

% Compute the small arc
f_h = vertex + (mean_curvature .* normals) * h + newthing * (h^2 / 2);

% Visualization of small arc
figure;
trisurf(F, V(:,1), V(:,2), V(:,3), 'FaceColor', 'cyan', 'EdgeColor', 'none');
hold on;
plot3(f_h(:,1), f_h(:,2), f_h(:,3), 'r.', 'MarkerSize', 10);
axis equal;
title('Small Arc Visualization');
xlabel('X');
ylabel('Y');
zlabel('Z');




