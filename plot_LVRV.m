%% Plotting Biventricular system with LV Long Axis
figure(1);
scatter3(lv(:,1),lv(:,2),lv(:,3),5,'filled','r'); hold on
scatter3(rv(:,1),rv(:,2),rv(:,3),5,'filled','k'); 
plot3([mvcentre(1);apex(1)],[mvcentre(2);apex(2)],[mvcentre(3);apex(3)],'g','linewidth',3);
% scatter3(mvcentre(1),mvcentre(2),mvcentre(3),'g',20,'filled'); 
% axis equal;
grid off;
xlabel('x');
ylabel('y');
zlabel('z');
hold off;

%% Plotting the RV point cloud
figure(2);
scatter3(rv(:,1),rv(:,2),rv(:,3),10,'filled','k'); 
% axis equal;
xlabel('x');
ylabel('y');
zlabel('z');
hold on;