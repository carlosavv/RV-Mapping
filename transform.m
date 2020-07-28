function [apex, lv, rv] = transform(apex, mvcentre, long_axis, lv, rv)
% INPUT 
%       lv : LV data
%       rv : RV data
%       mvcentre : mitral valve centre
%       apex : LV apex


% OUTPUT: 
%% Shifting Origin to Centre of Mitral Valve

rv = rv - ones(length(rv),1) * mvcentre;

lv = lv - ones(length(lv),1) * mvcentre;

apex = apex - mvcentre;

%% Evaluating the angle of rotation
% Projecting the Long Axis vector onto x-y plane

xy_proj = [1 0 0;0 1 0;0 0 0];
long_axis_proj = xy_proj * long_axis';
long_axis_proj = long_axis_proj';

angle_x = pi+acos(dot([1,0,0],long_axis_proj)/sqrt(dot(long_axis_proj,long_axis_proj)));
angle_z = acos(dot([0,0,1],long_axis)/sqrt(dot(long_axis,long_axis)));

%% Transforming data

lv1 = zeros(length(lv),3);
lv2 = zeros(length(lv),3);

rv1 = zeros(length(rv),3);
rv2 = zeros(length(rv),3);

transform1 = @(t) [cos(t) sin(t) 0; -sin(t) cos(t) 0; 0 0 1];
transform2 = @(t) [cos(t) 0 sin(t); 0 1 0; -sin(t) 0 cos(t)];

for i = 1:length(lv)
    lv1(i,:) = (transform1(angle_x)*lv(i,:)')';
    lv2(i,:) = (transform2(angle_z)*lv1(i,:)')';
end
lv = lv2;

for i = 1:length(rv)
    rv1(i,:) = (transform1(angle_x)*rv(i,:)')';
    rv2(i,:) = (transform2(angle_z)*rv1(i,:)')';
end

rv = rv2;
apex = (transform2(angle_z)*transform1(angle_x)*apex')';

figure; axis equal;
scatter3(lv2(:,1),lv2(:,2),lv2(:,3),9,'filled'); hold on
scatter3(rv2(:,1),rv2(:,2),rv2(:,3),9,'filled'); hold off
end