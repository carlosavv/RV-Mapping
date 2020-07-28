function plot_endPlanes(vrw, vpv, ctd_rw, ctd_pv,rv)
% INPUT
%       vrw, vpv: normal vectors to free wall and pulmonary valve
%       ctd_rw, ctd_pv: centroid of free wall and pulmonary valve

% syms xs ys zs
% P = [xs ys zs];
% hold on;
% plane_function1 = dot(100*vrw, P-ctd_rw);
% plane_function2 = dot(100*vpv, P-ctd_pv);
% zplane1 = solve(plane_function1,zs); 
% zplane2 = solve(plane_function2,zs);
% ezmesh(zplane1,[-45,-10,-60,-10])
% ezmesh(zplane2,[20,60,-35,-0])


% Plot planes
syms xs ys zs
P = [xs ys zs];
hold on
plane_function1 = dot(100*vrw, P-ctd_rw);
plane_function2 = dot(100*vpv, P-ctd_pv);
zplane1 = solve(plane_function1,zs); 
zplane2 = solve(plane_function2,zs);
fmesh(zplane1,[-100,100,-100,100])
fmesh(zplane2,[-100,100,-100,100])
axis([-40,80,-70,60 -120 10])





% Plotting normal vectors
% syms ts
% line1 = ctd_rw + ts*vrw';
% line2 = ctd_pv + ts*vpv';
% ezplot3(line1(1),line1(2),line1(3),[-20,20])
% ezplot3(line2(1),line2(2),line2(3),[-20,20])
% 
% xlim([-50 60])
% ylim([-80 0])
% zlim([-100 30])
% title(''); 


% Plot normals
syms ts
line1 = ctd_rw + ts*vrw';
line2 = ctd_pv + ts*vpv';
fplot3(line1(1),line1(2),line1(3),[-20,20],'LineWidth',2)
fplot3(line2(1),line2(2),line2(3),[-20,20],'LineWidth',2)






end