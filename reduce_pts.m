function [boundary_pts] = reduce_pts(LV_RV,z,b)
%% To find planes and normals at the designated ends of RV
% INPUT
%       LV_RV: Either LV or RV point cloud (clinical data)
%
%       z: Vector containing z-values for each plane parallel to xy plane
%       in which points are to be reduced
% 
%       b: Parameter for closeness of boundary fitting
%
% OUTPUT
%       boundary_pts: Reduced point cloud
%
% The input to this function needs to be similar to Duchenne data (points
% are in layers after segmentation and not randomly distributed along z)

rv = LV_RV;

new_pts = 0;
tol = 0.5;

for i = 1:length(z)
% reduce in each layer and add boundary indexes to variable k    

    layer = 1;
    ctr = 1;
    
    for j = 1:length(LV_RV)
    % find all points with given z-value, store index in variable 'layer'
        if LV_RV(j,3) <= z(i)+tol && LV_RV(j,3) >= z(i)-tol
            layer(ctr,:) = j;
            ctr = ctr+1;
        end
    end
    
    k = boundary(LV_RV(layer,1),LV_RV(layer,2),b);
    
    new_pts = cat(1,new_pts,layer(k));
    
end


boundary_indices = unique(new_pts(2:end));
boundary_pts = LV_RV(boundary_indices,:);

ctr = 1;
for i = 1:length(rv)
    
    if ismembertol(rv(i,3),z,0.1,'DataScale',1) == 1
        indices(ctr) = i;
        ctr = ctr+1;
    end
    
end

LV_RV(indices,:) = [];

boundary_pts = cat(1,LV_RV,boundary_pts);

% hold on; scatter3(rv(:,1),rv(:,2),rv(:,3),'c','filled');
% scatter3(boundary_pts(:,1),boundary_pts(:,2),boundary_pts(:,3),'b','filled')
