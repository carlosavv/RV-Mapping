raw_rv = [x,y,z];

figure()
scatter3(raw_rv(:,1),raw_rv(:,2),raw_rv(:,3),'g')

edge1 = load("RVshape\rv_edge1.txt");
edge2 = load("RVshape\rv_edge2.txt");
radius1 = norm(mean(raw_rv(edge1,1)),mean(raw_rv(edge1,2)));
radius2 = norm(mean(raw_rv(edge2,1)),mean(raw_rv(edge2,2)));


%     for ii = 1:length(edge1)
%         raw_rv(edge1(ii),:) = [];
%     end
% hold on;
% scatter3(raw_rv(:,1),raw_rv(:,2),raw_rv(:,3),'r')
edge2(1) = [];
edge2(end) = [];
xnew = mean(raw_rv(edge1,1));%,raw_rv(edge1,2),raw_rv(edge1,3))
ynew = mean(raw_rv(edge1,2));%,raw_rv(edge1,2),raw_rv(edge1,3))
znew = mean(raw_rv(edge1,3));%,raw_rv(edge1,2),raw_rv(edge1,3))
pv_centroid = [xnew,ynew,znew]
% for jj = 1:length(edge2)
%     raw_rv(edge2(jj),:) = [];
% end
hold on
scatter3(xnew,ynew,znew)

