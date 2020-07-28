% test
% 12/06/18

%%

% clear; close all;
% 
% rv = load('ZH_22_014Y_MaskLV_19_ED_RVendo.dat');
% 
% figure(1);
% scatter3(rv(:,1),rv(:,2),rv(:,3),5,'filled','k'); 
% axis equal;
% xlabel('x');
% ylabel('y');
% zlabel('z');
% hold on;
% 
% % rw is apex here
% pv1 = [2.734, 56.74, 108]; pv2 = [19.82, 61.52, 108]; pv3 = [17.09, 39.65, 108];
% rw3 = [98.44, 45.12, 13.5]; rw2 = [90.24, 66.99, 13.5]; rw1 = [69.73, 54.69, 13.5];
% 
% [vrw, vpv, ctd_rw, ctd_pv] = find_endPlanes([rw1; rw2; rw3], [pv1; pv2; pv3], rv);
% % error: reference to a cleared variable rwx
% 
% plot_endPlanes(vrw, vpv, ctd_rw, ctd_pv);
% 
% x = rv(:,1); y = rv(:,2); z = rv(:,3);
% 


%%

clear; close all;

lv = load('ZH_22_014Y_MaskLV_19_ED_LVendo.dat');
p1 = [71.09,76.56,103.5];
p2 = [51.95,108,103.5];
p3 = [34.18,77.93,103.5];


[apex, long_axis, mvcentre] = LV_longAxis(p1, p2, p3, lv);
rv = load('ZH22_ED_RV4.dat');
[apex, lv, rv] = transform(apex, mvcentre, long_axis, lv, rv);
mvcentre = [0,0,0];

plot_LVRV

rw1 = [71.65, -33.72, -44.25]; rw2 = [44.15, 0.2569, -85.82]; rw3 = [48.13, 1.944, -14.2];
%rw1 = [71.65, -33.72, -44.25]; rw2 = [38.28, 5.041, -86.69]; rw3 = [43.26, 2.642, -37.03];

% both of these result in basically the same normal vector, plane fit

pv1 = [-19.85, -40.5, 4.908]; pv2 = [-30.97, -41.26, 3.173]; pv3 = [-23.75, -52.15, 6.063];
% pv1 = [-3.148, -55.15, 6.202]; pv2 = [-8.711, -46.18, 6.96]; pv3 = [-20.45, -51.89, 8.558];
% pv1 = [-17.94, -42.99, 6.477]; pv2 = [-21.49, -54.52, 4.813]; pv3 = [-5.989, -48.21, 6.589];

vrw1 = rw1-rw2;
vrw2 = rw3-rw2;
vrw = cross(vrw1,vrw2);
vrw = vrw/sqrt(dot(vrw,vrw));
ctd_rw = rw2;

tol = 3;

for loop = 1:2
    % initialize a counter j
    j=1;
    clear rwx rwy rwz;
    drw = dot(vrw,ctd_rw);
    for i=1:length(rv)

        result = dot(vrw,rv(i,:)-rw1);
        if abs(result) <= tol 
            rwx(j) = rv(i,1);
            rwy(j) = rv(i,2);
            rwz(j) = rv(i,3); 
            j=j+1;
        end

    end

    % normal to least square plane [a,b,c]
    [vrw,~,ctd_rw] = affine_fit([rwx',rwy',rwz']);

 end


scatter3(rwx,rwy,rwz,'filled','m','LineWidth',2)

vpv1 = pv1-pv2;
vpv2 = pv3-pv2;
vpv = cross(vpv1,vpv2);
vpv = vpv/sqrt(dot(vpv,vpv));
ctd_pv = pv2;

tol = 1;
j=1;
dpv = dot(vpv,ctd_pv);

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

scatter3(pvx,pvy,pvz,'filled','m','LineWidth',2)

% Plot normals
syms ts
line1 = ctd_rw + ts*vrw';
line2 = ctd_pv + ts*vpv';
fplot3(line1(1),line1(2),line1(3),[-20,20],'LineWidth',2)
fplot3(line2(1),line2(2),line2(3),[-20,20],'LineWidth',2)

% Plot planes
syms xs ys zs
P = [xs ys zs];
plane_function1 = dot(100*vrw, P-ctd_rw);
plane_function2 = dot(100*vpv, P-ctd_pv);
zplane1 = solve(plane_function1,zs); 
zplane2 = solve(plane_function2,zs);
fmesh(zplane1,[-30,70,-60,10])
fmesh(zplane2,[-40,30,-70,-20])
axis([-40,80,-70,20 -100 10])




