% HN 11/20/18

function STLtoData(file)
% rv_file = ('dmd07_3');

% [v, f, n, sphere] = stlRead(strcat(rv_file,'.stl'));
% stlPlot(v, f, sphere)
% vertices = stlGetVerts(v, f, 'closed');
% figure; scatter3(vertices(:,1), vertices(:,2), vertices(:,3))
% 
% save(strcat(rv_file,'.dat'),'v', '-ascii') 

[v, f, m, sphere] = stlRead(strcat(file,'.stl'));
stlPlot(v, f, sphere)
vertices = stlGetVerts(v, f, 'closed');
figure; scatter3(vertices(:,1), vertices(:,2), vertices(:,3))

save(strcat(file,'.dat'),'vertices', '-ascii') 
end