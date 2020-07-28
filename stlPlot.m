function h = stlPlot(v, f, name)
%STLPLOT is an easy way to plot an STL object
%V is the Nx3 array of vertices
%F is the Mx3 array of faces
%NAME is the name of the object, that will be displayed as a title

% figure;
object.vertices = v;
object.faces = f;

h = patch(object,'FaceColor',       [1 0 .1], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15);

% Add a camera light, an/d tone down the specular highlighting
camlight('right');
material('dull');

% Fix the axes scaling, and set a nice view angle
axis('image');
view([-135 35]);
axis off;
% grid on;
end
