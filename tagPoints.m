% script that tags points (in unmapped space) based 
% on their "clen" values
clear all;  close all;

cptstest = load("D:\Workspace\RV-Fitting\cpts_bezier.dat");
tube = load("D:\Workspace\RV-Fitting\RV_tube.dat");
temp = [];
[clen, local_x, local_y,T] = remapping_CA(cptstest, tube);


remapped_data = [local_x,local_y, clen];
diff_z = remapped_data(:,3) - tube(:,3);
figure
plot(tube(:,3),'r')
hold on
plot(remapped_data(:,3),'b')
title('Red = helical tube , Blue = remapped tube')
xlabel('data point')
ylabel(' z-value ')
figure
hold on
plot(diff_z,'LineWidth', 2)
title('Difference in Z-values per data point')
xlabel('data point')

figure
scatter3(remapped_data(:,1),remapped_data(:,2),remapped_data(:,3),'filled')

figure
plot(T,'LineWidth', 2)
title('How T varies per data point')
xlabel('data point')
ylabel('T value')


% clen = unique(clen);
% 
% for j = 1:length(test)
%     
%     for i = 1:6:length(clen)
%         scatter3(test(j,1),test(j,2),test(j,3),'filled'); hold on;
%         scatter3(zeros(1,length(clen(i))),zeros(1,length(clen(i))),clen(i));
%     end
%     
% end

% subplot(2,1,1)
% scatter3(tube(:,1),tube(:,2),tube(:,3),'filled');
% 
% subplot(2,1,2)
% scatter3(tube(:,1),tube(:,2),tube(:,3),[],clen,'filled')
