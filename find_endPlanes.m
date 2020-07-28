function [ vpv, ctd_pv]= find_endPlanes( pv, rv)
%% To find planes and normals at the designated ends of RV
% INPUT
%       rw: Set of 3 guess points on free wall
%       pv: Set of 3 guess points on Pulmonary Valve
%       rv: RV point cloud
% OUTPUT
%       vrw, vpv: Normal vectors for free wall and PV respectively
%       ctd_rw, ctd_rw: Centres of free wall and PV respectively

%% Data points for RV free wall plane and Pulmonary Valve
% 
% rw1 = rw(1,:);
% rw2 = rw(2,:); rw3 = rw(3,:);
pv1 = pv(1,:); pv2 = pv(2,:); pv3 = pv(3,:);

%% RV free wall plane

% % find normal vector to the right wall plane
% vrw1 = rw1-rw2;
% vrw2 = rw3-rw2;
% vrw = cross(vrw1,vrw2);
% 
% % normalize normal vector
% vrw = vrw/sqrt(dot(vrw,vrw))
% result = dot(vrw,rv(1,:)-rw1)
% 
% % assume point 2 is the centroid of the points on that plane
% ctd_rw = rw2;
% 
% % define a tolerance
% tol = 3;
% 
% for loop = 1:2
%     % initialize a counter j
%     j=1;
% %     clear rwx rwy rwz;
%     for i=1:length(rv)
%         result = dot(vrw,rv(i,:)-rw1);
%         if abs(result) <= tol 
%             rwx(j) = rv(i,1);
%             rwy(j) = rv(i,2);
%             rwz(j) = rv(i,3); 
%         j=j+1;
%         end
%     end
%     
%     [vrw,~,ctd_rw] = affine_fit([rwx',rwy',rwz']);
%     
%  end


%% Data points for the pulmonary valve plane

vpv1 = pv1-pv2;
vpv2 = pv3-pv2;
vpv = cross(vpv1,vpv2);
vpv = vpv/sqrt(dot(vpv,vpv));
ctd_pv = pv2;

tol = 2;

for loop = 1:2
    % initialize a counter j
    j=1;
    clear pvx pvy pvz;
    for i=1:length(rv)
        result = dot(vpv,rv(i,:)-pv1);
        if abs(result) <= tol 
            pvx(j) = rv(i,1);
            pvy(j) = rv(i,2);
            pvz(j) = rv(i,3); 
        j=j+1;
        end
    end
    [vpv, ~, ctd_pv] = affine_fit([pvx',pvy',pvz']);
    

end
              