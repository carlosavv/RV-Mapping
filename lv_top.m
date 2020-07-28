%% LV top plane evaluator
% Load the LV data
lv = load('LV.dat');
clf
% Plot the LV
scatter3(lv(:,1),lv(:,2),lv(:,3),9);

% Select three points on the top most part of LV
rw1 = [28.87,10.12,2081]; rw2 = [38.57,21,2077]; rw3 = [35.09,24.70,2065];

% Evaluating the first approximation
v1 = p1-p2;
v2 = p3-p2;
vrw = cross(v1,v2);
vrw = vrw/sqrt(dot(vrw,vrw));
ctd_rw = rw2;
vrw =vrw';
% Iteratively evaluating the new vectors
for k = 1:4
    j=1;
    clear rwx rwy rwz new;
    thickness_rw = 2;
    drw = dot(vrw',ctd_rw)+thickness_rw;
    for i=1:length(lv)
        if abs(dot(vrw',lv(i,:)-ctd_rw)) <= 2
                rwx(j) = lv(i,1);
                rwy(j) = lv(i,2);
                rwz(j) = lv(i,3); 
                j=j+1;
        end
    end
 
% normal to least square plane [a,b,c]
    [vrw,V,ctd_rw] = affine_fit([rwx',rwy',rwz']);
    tangent = vrw';
    node_pt = ctd_rw;
    rwx = rwx'; rwy = rwy'; rwz = rwz';
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
    for j = 1:length(rwx)
        sample_pt = [rwx(j,1),rwy(j,1),rwz(j,1)];
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
    new_ctd_rw = projected_centroid(1,1)*vec1 + projected_centroid(1,2)*vec2 + node_pt;
end

hold on;
scatter3(rwx',rwy',rwz','filled');
% drw = dot(vrw,new_ctd_rw);
ctd_rw = new_ctd_rw;

syms ts
line1 = ctd_rw + ts*vrw';
ezplot3(line1(:,1),line1(:,2),line1(:,3),[-20,90]);
axis equal;
title('');
% hold off;