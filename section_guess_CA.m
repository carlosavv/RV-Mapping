function segment_ctd =  section_guess_CA(num_sec, p0, p1, p2, p3, rv, ctd_rw, ctd_pv)
%% Section the RV geometry using guess Central Axis
% Takes the Bezier curve control points corresponding to Guess Central Axis
% as the input and creates sections thus evaluating the sectional centroids
%
% INPUT
%       num_sec: Number of sections
%       p0, p1, p2, p3, p4: Control points to Guess CA
%       rv: Array of RV point cloud
%       ctd_rw, ctd_pv: Centroid of Free wall and Pulmonary Valve
% OUTPUT
%       segment_ctd: Centroid of the segmented sections

%% Discretize parameter t in (0.05,0.05) into num_sec-2 sections
ctd_ctr=2;
x = rv(:,1); y = rv(:,2); z = rv(:,3);
segment_ctd = zeros(num_sec, 3);
for t = 0.01:0.9/(num_sec-2):0.99
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
    clear projections projections1
    for j = 1:length(x)
        sample_pt = [x(j,1),y(j,1),z(j,1)];
%         if t >0.650 
%             if abs(dot(tangent,sample_pt-node_pt))<tol_plane && x(j,1) > 10
%                 [projections(ctr,1),projections(ctr,2)] = proj_on_plane(tangent,vec1,vec2,node_pt,sample_pt);
%                 ctr = ctr+1;
%             end
%         else
            if abs(dot(tangent,sample_pt-node_pt))<tol_plane 
                [projections(ctr,1),projections(ctr,2)] = proj_on_plane(tangent,vec1,vec2,node_pt,sample_pt);
                ctr = ctr+1;
            end
%        end
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
    
    
%     if ctd_ctr==40
%         break
%     end
    
    
    projected_centroid(1,:) = cat(1,s.Centroid) + [xtrans-5,ytrans-5];
    segment_ctd(ctd_ctr,:) = projected_centroid(1,1)*vec1 + projected_centroid(1,2)*vec2 + node_pt;
    ctd_ctr = ctd_ctr+1;
end

% Enforce the first and last sectional centroids to coincide with that of 
% free wall and Pulmonary valve respectively

 segment_ctd(1,:) = ctd_rw;
segment_ctd(end,:) = ctd_pv;




%segment_ctd( all(~segment_ctd,2), : ) = [];
% temp



end