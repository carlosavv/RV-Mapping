function [long_axis, mvcentre,apex] = LV_longAxis( p1, p2, p3, lv)
%% Evaluating the LV long axis 
% Find the centre of the mitral valve (MV)
% Determine the location of apex
% Join the two to obtain LV long axis.

% INPUT: (implicit) filename, guess_points

% OUTPUT: apex, long_axis

%% Mitral Valve center 
nor = cross(p1-p2,p3-p2);
nor = nor/sqrt(dot(nor,nor));
mvcentre = p2;

num_iter = 1;

for i = 1:num_iter
    thickness = 2;
    ctr = 1;
    for j = 1:length(lv)
        if abs(dot(nor,mvcentre-lv(j,:))) < thickness
            top_plane(ctr,:) = lv(j,:);
            ctr = ctr+1;
        end
%         dotres(j) = abs(dot(nor,mvcentre-lv(j,:)));    
    end
    
     [nor,~,mvcentre] = affine_fit(top_plane);
    nor = nor'; 
    
    tangent = nor;
    node_pt = mvcentre;
    
    if tangent(1,3) ~= 0
        pt1 = [1,1,(-tangent(1,1) - tangent(1,2) + dot(tangent,node_pt))/tangent(1,3)];
    elseif tangent(1,2) ~= 0
        pt1 = [1,(-tangent(1,1) - tangent(1,3) + dot(tangent,node_pt))/tangent(1,2),1];
    else
        pt1 = [(-tangent(1,2) - tangent(1,3) + dot(tangent,node_pt))/tangent(1,1),1,1];
    end
    
    tangent = tangent/sqrt(dot(tangent,tangent));
    
    % Find two inplane vectors to take projections
    vec1 = pt1-node_pt;
    vec2 = cross(tangent,vec1);
    vec1 = vec1/sqrt(dot(vec1,vec1));
    vec2 = vec2/sqrt(dot(vec2,vec2));
    
    % Parse through the point cloud
    ctr = 1;
    for j = 1:length(lv)
        sample_pt = lv(j,:);
        % Store the projection
        [projections(ctr,1),projections(ctr,2)] = proj_on_plane(tangent,vec1,vec2,node_pt,sample_pt);
        ctr = ctr + 1;
    end
    
    % Find the convex hull of the points
    hull_index = convhull(projections(:,1),projections(:,2));
    
    % Translate the projections to yield all positive coordinates
    xtrans = min(projections(hull_index,1));
    ytrans = min(projections(hull_index,2));
    for k = 1:length(hull_index)
        projections1(hull_index(k,1),1) = projections(hull_index(k,1),1) - xtrans+5;
        projections1(hull_index(k,1),2) = projections(hull_index(k,1),2) - ytrans+5;
    end
    % Mask the convex hull with a grid and mark all inside points
    BW = poly2mask(projections1(hull_index,1),projections1(hull_index,2),250,250);
    % Determine the centroid using regional properties
    s = regionprops(BW,'centroid');
    % Translate back and store the centroid
    projected_centroid(1,:) = cat(1,s.Centroid) + [xtrans-5,ytrans-5];
    % Obtain the centroid in 3D frame
    mvcentre = projected_centroid(1,1)*vec1 + projected_centroid(1,2)*vec2 + node_pt
end

% apex = [67.49,-47.81,2022];

%% Evaluating APEX
% max = 0;
% for i = 1:length(lv)
%     if abs(dot(nor,lv(i,:)-mvcentre)) > max
%         apex = lv(i,:);
%         max = abs(dot(nor,lv(i,:)-mvcentre));
%     end
% end
[apex]= generateLVApexPoints(lv);

%% Evaluating the long Axis Vector 
long_axis = mvcentre - apex;
long_axis = long_axis/sqrt(dot(long_axis,long_axis))

% scatter3(lv(:,1),lv(:,2),lv(:,3),9,'filled');
% hold on
% plot3([mvcentre(1);apex(1)],[mvcentre(2);apex(2)],[mvcentre(3);apex(3)],'linewidth',5);
% axis equal;
% scatter3(mvcentre(1),mvcentre(2),mvcentre(3),36,'filled');
end