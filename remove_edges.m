clc; clear all; close all;
raw_rv = load("RVshape\RVendo_0.txt");

figure()
scatter3(raw_rv(:,1),raw_rv(:,2),raw_rv(:,3),'g')

edge1 = load("RVshape\tv_nodes.txt") + 1;
edge2 = load("RVshape\pv_nodes.txt") + 1;

for ii = 1:length(edge1)
    raw_rv(edge1(ii),:) = [];
end

for jj = 1:length(edge2)
    raw_rv(edge2(jj),:) = [];
end
hold on;
scatter3(raw_rv(:,1),raw_rv(:,2),raw_rv(:,3),'r')
