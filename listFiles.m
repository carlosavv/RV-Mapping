
close all; clc;

% locrv = ('D:\Workspace\Code (RV Shape)\RV_matlab_update_2_20\N2_RV_dat\');
% loclv = 'D:\Workspace\Code (RV Shape)\RV_matlab_update_2_20\N2_LV_dat\';
% locrv = ('C:\Workspace\Code (RV Shape)\RV_matlab_update_2_20\TOF01_0_1\TOF01_0_0_dat\');
% loclv = ('C:\Workspace\Code (RV Shape)\RV_matlab_update_2_20\TOF01_0_0_LV\MS\TOF01_0_0_LV\');
locrv = ('C:\Workspace\Code (RV Shape)_v1\RV_mapping_code\N2_RV_dat\');
loclv = ('C:\Workspace\Code (RV Shape)_v1\RV_mapping_code\N2_LV_dat\');
% locrv = 'D:\Workspace\Code (RV Shape)_v1\RV_matlab_update_2_20\DMD01_stl\final\dat\';
% loclv = 'D:\Workspace\Code (RV Shape)_v1\RV_matlab_update_2_20\DMD01_LV\';
X = dir2(locrv);
Y = dir2(loclv);

lvconc = [Y(1).name ,Y(2).name,Y(3).name,Y(4).name,Y(5).name];
rvconc = [X(1).name ,X(2).name,X(3).name,X(4).name,X(5).name];
filerv = split(rvconc,'.dat');
file0 = split(rvconc,'.dat');
file1 = split(lvconc,'.dat');
filelv = split(lvconc,'.dat');
% for j = 1:5
%     STLtoData(strcat(loclv,file0{j}));
% end
% for j = 1:5
%     STLtoData(strcat(locrv,file1{j}));
% end

% for i = 2:5
%     main_rw(strcat(locrv,filerv{i},'.dat'),strcat(loclv,filelv{i},'.dat'));
%     pause;
%     close all;
% end
main_rw(strcat(locrv,filerv{1},'.dat'),strcat(loclv,filelv{1},'.dat'));

% 1: [41,-18,-13] , [23.63,35,-20]
% 2: [39,-20,-14] , [31,34,-21]
% 3: [24,-24,-13] , [31,41,-22]
% 4: [24,-24,-10] , [36,48,-28]
% 5: [23,-22,-13.6] , [28,42.78,-35]

% [38, 0.22, -14.5] , [44.9502,-28.58,-13.24]