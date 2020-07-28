function segment_ctd = resection_CA(num_sec, control_pts, rv )
%% Resections the RV using Central axis and evaluates new sectional centroids
% INPUT
%       num_sec: Number of individual sections in each segement
%       control_pts: Control points of the CA
%       rv: RV point cloud
% 
% OUTPUT
%       segment_ctd: Centroid of each section
ctd_ctr = 2;

% Control Points
p0 = control_pts(1,:); p1 = control_pts(2,:);
p2 = control_pts(3,:); p3 = control_pts(4,:);
p4 = control_pts(5,:); p5 = control_pts(6,:);
p6 = control_pts(7,:); p7 = control_pts(8,:);

% Point cloud
x = rv(:,1); y = rv(:,2); z = rv(:,3);
for t = 0.01:0.99/(num_sec-1):1
    node_pt = (1-t)^3*p0 + 3*(1-t)^2*t*p1 + 3*(1-t)*t^2*p2 + t^3*p3;
    tangent = 3*(1-t)^2*(p1-p0) + 6*(1-t)*t*(p2-p1) + 2*t^2*(p3-p2);
    
    if tangent(1,3) ~= 0
        pt1 = [1,1,(-tangent(1,1) - tangent(1,2) + dot(tangent,node_pt))/tangent(1,3)];
    elseif tangent(1,2) ~= 0
        pt1 = [1,(-tangent(1,1) - tangent(1,3) + dot(tangent,node_pt))/tangent(1,2),1];
    else
        pt1 = [(-tangent(1,2) - tangent(1,3) + dot(tangent,node_pt))/tangent(1,1),1,1];
    end
    tangent = tangent/sqrt(dot(tangent,tangent));    
    vec1 = pt1-node_pt;
    vec2 = cross(tangent,vec1);
    vec1 = vec1/sqrt(dot(vec1,vec1));
    vec2 = vec2/sqrt(dot(vec2,vec2));
    tol_plane = 2;
    ctr = 1;
    clear projections
    for j = 1:length(x)
        sample_pt = [x(j,1),y(j,1),z(j,1)];
        if abs(dot(tangent,sample_pt-node_pt))<tol_plane 
            [projections(ctr,1),projections(ctr,2)] = proj_on_plane(tangent,vec1,vec2,node_pt,sample_pt);
            ctr = ctr+1;
        end
    end
    hull_index = convhull(projections(:,1),projections(:,2));
    xtrans = min(projections(hull_index,1));
    ytrans = min(projections(hull_index,2));
    for k = 1:length(hull_index)
        projections1(hull_index(k,1),1) = projections(hull_index(k,1),1)-xtrans+5;
        projections1(hull_index(k,1),2) = projections(hull_index(k,1),2)-ytrans+5;
    end
    BW = poly2mask(projections1(hull_index,1),projections1(hull_index,2),150,150);
    s = regionprops(BW,'centroid');
    projected_centroid(1,:) = cat(1,s.Centroid) + [xtrans-5,ytrans-5];
    segment_ctd(ctd_ctr,:) = projected_centroid(1,1)*vec1 + projected_centroid(1,2)*vec2 + node_pt;
    ctd_ctr = ctd_ctr+1;
end
for t = 0:0.99/(num_sec-1):0.99
 
    node_pt = (1-t)^3*p4 + 3*(1-t)^2*t*p5 + 3*(1-t)*t^2*p6 + t^3*p7;
    tangent = 3*(1-t)^2*(p5-p4) + 6*(1-t)*t*(p6-p5) + 2*t^2*(p7-p6);
    
    if tangent(1,3) ~= 0
        pt1 = [1,1,(-tangent(1,1) - tangent(1,2) + dot(tangent,node_pt))/tangent(1,3)];
    elseif tangent(1,2) ~= 0
        pt1 = [1,(-tangent(1,1) - tangent(1,3) + dot(tangent,node_pt))/tangent(1,2),1];
    else
        pt1 = [(-tangent(1,2) - tangent(1,3) + dot(tangent,node_pt))/tangent(1,1),1,1];
    end
    tangent = tangent/sqrt(dot(tangent,tangent));    
    vec1 = pt1-node_pt;
    vec2 = cross(tangent,vec1);
    vec1 = vec1/sqrt(dot(vec1,vec1));
    vec2 = vec2/sqrt(dot(vec2,vec2));
    tol_plane = 2;
    clear projections
    ctr = 1;
    for j = 1:length(x)
        sample_pt = [x(j,1),y(j,1),z(j,1)];
        if t >0.8 
            if abs(dot(tangent,sample_pt-node_pt))<tol_plane % && y(j,1) > 0
                [projections(ctr,1),projections(ctr,2)] = proj_on_plane(tangent,vec1,vec2,node_pt,sample_pt);
                ctr = ctr+1;
            end
        else
            if abs(dot(tangent,sample_pt-node_pt))<tol_plane 
                [projections(ctr,1),projections(ctr,2)] = proj_on_plane(tangent,vec1,vec2,node_pt,sample_pt);
                ctr = ctr+1;
            end
        end
    end
    if ctr~=1
        hull_index = convhull(projections(:,1),projections(:,2));
        xtrans = min(projections(hull_index,1));
        ytrans = min(projections(hull_index,2));
        for k = 1:length(hull_index)
            projections1(hull_index(k,1),1) = projections(hull_index(k,1),1)-xtrans+5;
            projections1(hull_index(k,1),2) = projections(hull_index(k,1),2)-ytrans+5;
        end
        BW = poly2mask(projections1(hull_index,1),projections1(hull_index,2),150,150);
        s = regionprops(BW,'centroid');
        projected_centroid(1,:) = cat(1,s.Centroid) + [xtrans-5,ytrans-5];
        segment_ctd(ctd_ctr,:) = projected_centroid(1,1)*vec1 + projected_centroid(1,2)*vec2 + node_pt;
        ctd_ctr = ctd_ctr+1;
    end
 end
segment_ctd(1,:) = p0;
segment_ctd(end,:) = p7;
end