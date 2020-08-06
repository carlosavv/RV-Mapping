function vtkFile = writeToVTK(name, descriptor, ptcld)
%% Write Remapped RV Point Cloud to VTK for Paraview

NN = size(ptcld,1);

%remapped_rv = [local_x,local_y,clen];
% Get folder if present:
split_name = split( name, '/' );
if length(split_name) > 1 % if folder present
    if ~isfolder( split_name{1} )
        mkdir( split_name{1} )
    end
end

%vtkFile = fopen ('Normal2_0.vtk', 'w');
vtkFile = fopen (strcat(name,'.vtk'), 'w');
strcat(name,'.vtk')
% Note: \n returns new line
fprintf(vtkFile, '# vtk DataFile Version 3.0\n');
%fprintf(vtkFile, 'Normal2 1445308987.976780\n');

fprintf(vtkFile, strcat(descriptor,'\n'));
fprintf(vtkFile, 'ASCII\n');
fprintf(vtkFile, 'DATASET POLYDATA\n');
fprintf(vtkFile, 'POINTS %i double\n', NN);

fprintf(vtkFile, '%.15f %.15f %.15f\n', ptcld');
fprintf(vtkFile, 'VERTICES 1 %i\n', NN+1);

fprintf(vtkFile, num2str(NN));
fprintf(vtkFile, ' %d', 0:NN-1);


%fprintf(vtkFile, 'POINT_DATA %i VECTORS magnetization float\n', NN);
%fprintf(vtkFile, '%.15e %.15e %.15e\n', Mag);




