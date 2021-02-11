%% The main file with all files called as per the algorithm

%% Perform clean up

function main_rw(rv,lv)


%% Load the LV data and find the long axis
% REQUIRES: file LV.dat

% Load data for LV 
lv_file = lv;
lv = 1000*load(lv_file);
lv = [lv(:,1),lv(:,2),-lv(:,3)];
lvsplit = split(lv_file,'\');
lvcell = split(lvsplit{end},'.dat');
lvname = lvcell{1};
% Manually selected data points
% p1 = [71.09,76.56,103.5];
% p2 = [51.95,108,103.5];
% p3 = [34.18,77.93,103.5];

[P1,P2,P3] = generateLVPoints(lv);

[apex]= generateLVApexPoints(lv);
% Find apex and long axis
[ long_axis, mvcentre,apex] = LV_longAxis(P1, P2, P3, lv);


save (strcat('CentricAxis_',lvname,'.mat'), 'mvcentre', 'apex')

%% Load RV data and transform to LV centric system 
% z-axis = LV long axis
% origin = Mitral valve centre
% REQUIRES: file RV.data

% Load RV.dat
rv_file = rv;
rv = load(rv_file);
rvsplit = split(rv_file,'\');
rvcell = split(rvsplit{end},'.dat');
rvname = rvcell{1};

rv_og = rv;
% Transforming the point cloud
[apex, lv, rv] = transform(apex, mvcentre, long_axis, lv, rv);
mvcentre = [0,0,0];

% Plot the RV LV system with apex and LV long axis
plot_LVRV; 
figure(2);
% scatter3(rv_og(:,1),rv_og(:,2),rv_og(:,3),15,'filled');
%% Output for Paraview
vtkLVCentricRV = writeToVTK(rvname,strcat(rvname,'_Centric RV'),rv);
vtkLVCentricLV = writeToVTK(lvname,strcat(lvname,'Centric LV'),lv);


% make sure these names are right

%% Iteratively evaluate the end planes

[vpv,ctd_pv] = genPVpts(rv)
[vrw,ctd_rw]= generateApexPoints(rv,ctd_pv)
% [ vpv, ctd_pv] = find_endPlanes([pv1'; pv2'; pv3']', rv);

% Plot the end planes and normals 
plot_endPlanes(vrw, vpv, ctd_rw, ctd_pv,rv);

x = rv(:,1); y = rv(:,2); z = rv(:,3);
%% Find the Bezier Curve having fixed end points and normals
% This will act as the first approximation
% Since it is a guess, it requires guess parameters g1 and g2

g1 = ctd_rw(1)*0.9;
g2 = ctd_pv(1)*0.7;

[p0, p1, p2, p3] = guess_CA(vrw, vpv, ctd_rw, ctd_pv, g1,g2)

% Plotting the Guess Central Axis(CA)
plot_bezier(p0, p1, p2, p3,'r');
 
%% Section the RV using guess central axis
% Choose the number of sections
num_sec = 50;
segment_ctd = section_guess_CA(num_sec, p0, p1, p2, p3, rv, ctd_rw, ctd_pv);

% Plot the centroids
scatter3(segment_ctd(:,1),segment_ctd(:,2),segment_ctd(:,3),'filled');
 
%% Fit Two Bezier curve segments c-2 continuous (CENTRAL AXIS) having fixed end points and normals
% Section each segment and re-evaluate Central Axis
num_sec = 50;
num_iter = 5;
for loop = 1:num_iter 
    control_pts = eval_central_axis(segment_ctd, vrw, vpv);

    
% Resection to check the change in position of Centroid
    segment_ctd = resection_CA(num_sec, control_pts, rv);
end

% Plot the two segments
plot_bezier(control_pts(1,:), control_pts(2,:),control_pts(3,:), control_pts(4,:),'b');
plot_bezier(control_pts(5,:), control_pts(6,:),control_pts(7,:), control_pts(8,:),'b');

%% Remapping the RV point cloud using Central Axis (CA)
[clen, local_x, local_y] = remapping_CA(control_pts, rv);
% save(strcat('clen_',rvname,'.csv'),"local_x","local_y","clen")
% Plot remapped RV
figure(3);
scatter3(local_x,local_y,clen,20,'filled'); hold on
plot3(zeros(1,length(clen)),zeros(1,length(clen)),clen,'r','LineWidth', 1);
%title(rvname,'FontSize',10)

%% Output for Paraview

vtkRemappedRV = writeToVTK(strcat('remapped_',rvname),rvname,[local_x,local_y,clen]);

%% Store to 3D Point Cloud 
ptCloud = pointCloud([local_x,local_y,clen]);
pcwrite(ptCloud,strcat('RemappedRV_new',rvname,'.ply'));

%% 

save(strcat('wkspc_',rvname,'.mat'))
end


% %% The main file with all files called as per the algorithm
% 
% %% Perform clean up
% 
% function main_rw(rv,lv)
% 
% 
% %% Load the LV data and find the long axis
% % REQUIRES: file LV.dat
% 
% % Load data for LV 
% lv_file = lv;
% lv = 1000*load(lv_file);
% lv = [lv(:,1),lv(:,2),-lv(:,3)];
% lvsplit = split(lv_file,'\');
% lvcell = split(lvsplit{end},'.dat');
% lvname = lvcell{1};
% % Manually selected data points
% % p1 = [71.09,76.56,103.5];
% % p2 = [51.95,108,103.5];
% % p3 = [34.18,77.93,103.5];
% 
% [P1,P2,P3] = generateLVPoints(lv);
% 
% [apex]= generateLVApexPoints(lv);
% % Find apex and long axis
% [ long_axis, mvcentre,apex] = LV_longAxis(P1, P2, P3, lv);
% 
% 
% %save (strcat('CentricAxis_',lvname,'.mat'), 'mvcentre', 'apex')

% %% Load RV data and transform to LV centric system 
% % z-axis = LV long axis
% % origin = Mitral valve centre
% % REQUIRES: file RV.data
% 
% % Load RV.dat
% rv_file = rv;
% rv = 1000*load(rv_file);
% rvsplit = split(rv_file,'\');
% rvcell = split(rvsplit{end},'.dat');
% rvname = rvcell{1};
% rv = [rv(:,1),rv(:,2),-rv(:,3)];
% rv_og = rv;
% % plot_LVRV; 
% % Transforming the point cloud
% [apex, lv, rv] = transform(apex, mvcentre, long_axis, lv, rv);
% mvcentre = [0,0,0];
% 
% % Plot the RV LV system with apex and LV long axis
% plot_LVRV; 
% 
% % scatter3(rv_og(:,1),rv_og(:,2),rv_og(:,3),15,'filled');
% %% Output for Paraview
% vtkLVCentricRV = writeToVTK(rvname,strcat(rvname,'_Centric RV'),rv);
% vtkLVCentricLV = writeToVTK(lvname,strcat(lvname,'Centric LV'),lv);
% 
% 
% % make sure these names are right
% 
% %% Iteratively evaluate the end planes
% 
% [vpv,ctd_pv] = genPVpts(rv);
% [vrw,ctd_rw]= generateApexPoints(rv,ctd_pv);
% % [ vpv, ctd_pv] = find_endPlanes([pv1'; pv2'; pv3']', rv);
% 
% % Plot the end planes and normals 
% plot_endPlanes(vrw, vpv, ctd_rw, ctd_pv,rv);
% 
% x = rv(:,1); y = rv(:,2); z = rv(:,3);
% %% Find the Bezier Curve having fixed end points and normals
% % This will act as the first approximation
% % Since it is a guess, it requires guess parameters g1 and g2
% 
% g1 = 0.95*ctd_rw(1); g2 = .9*ctd_pv(1);
% 
% [p0, p1, p2, p3] = guess_CA(vrw, vpv, ctd_rw, ctd_pv, g1,g2);
% 
% % Plotting the Guess Central Axis(CA)
% plot_bezier(p0, p1, p2, p3,'r');
%  
% %% Section the RV using guess central axis
% % Choose the number of sections
% num_sec = 50;
% segment_ctd = section_guess_CA(num_sec, p0, p1, p2, p3, rv, ctd_rw, ctd_pv);
% 
% % Plot the centroids
% scatter3(segment_ctd(:,1),segment_ctd(:,2),segment_ctd(:,3),'filled');
%  
% %% Fit Two Bezier curve segments c-2 continuous (CENTRAL AXIS) having fixed end points and normals
% % Section each segment and re-evaluate Central Axis
% num_sec = 50;
% num_iter = 5;
% for loop = 1:num_iter 
%     control_pts = eval_central_axis(segment_ctd, vrw, vpv);
% 
%     
% % Resection to check the change in position of Centroid
%     segment_ctd = resection_CA(num_sec, control_pts, rv);
% end
% 
% % Plot the two segments
% plot_bezier(control_pts(1,:), control_pts(2,:),control_pts(3,:), control_pts(4,:),'b');
% plot_bezier(control_pts(5,:), control_pts(6,:),control_pts(7,:), control_pts(8,:),'b');
% 
% %% Remapping the RV point cloud using Central Axis (CA)
% [clen, local_x, local_y] = remapping_CA(control_pts, rv);
% % save(strcat(rvname,'_remmapped_points','.csv'),"local_x","local_y","clen")
% % Plot remapped RV
% figure(3);
% scatter3(local_x,local_y,clen,10,'filled'); hold on
% plot3(zeros(1,length(clen)),zeros(1,length(clen)),clen,'r','LineWidth', 3);
% %title(rvname,'FontSize',10)
% 
% %% Output for Paraview
% 
% vtkRemappedRV = writeToVTK(strcat('remapped_',rvname),rvname,[local_x,local_y,clen]);
% 
% %% Store to 3D Point Cloud 
% ptCloud = pointCloud([local_x,local_y,clen]);
% remappedRVFileName = strcat('RemappedRV_new',rvname,'.ply');
% split_fileName = split(remappedRVFileName, '/');
% if length(split_fileName) > 1 % if folder present
%     if ~isfolder( split_fileName{1} )
%         mkdir( split_fileName{1} )
%     end
% end
% pcwrite(ptCloud,remappedRVFileName);
% 
% %% 
% dataFileName = strcat('wkspc_',rvname,'.mat');
% split_fileName = split(dataFileName, '/');
% if length(split_fileName) > 1 % if folder present
%     if ~isfolder( split_fileName{1} )
%         mkdir( split_fileName{1} )
%     end
% end
% save( dataFileName )
% end