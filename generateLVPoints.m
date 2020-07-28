%% CAV 6/5/2019
% finds points within the vicinty of the maximum in the z component then
% stores the x and y points into a vector (with z-max)

function [p1,p2,p3] = generateLVPoints(lv)

zmax = max(lv(:,3));
[x,y] =find(lv==max(lv(:,3)));
for i = x
    [mx] = [lv(i,1),lv(i,2)];
    A = mx;
    msize = numel(A);

    foo1 = A(randperm(msize, 2));
    foo2 = A(randperm(msize, 2));
    foo3 = A(randperm(msize, 2));

    if length(mx) <= 2
        %%TODO implement selection of points where it picks random points
        %%in x y and has the max of the LV present in all 3D points
        p1 = [(ceil(numel(lv(:,1))*rand(1,1))),(ceil(numel(lv(:,2))*rand(1,1))),zmax];
        p2 = [(ceil(numel(lv(:,1))*rand(1,1))),(ceil(numel(lv(:,2))*rand(1,1))),zmax];
        p3 = [(ceil(numel(lv(:,1))*rand(1,1))),(ceil(numel(lv(:,2))*rand(1,1))),zmax];
    else
        p1 = [foo1(1),foo1(2),zmax]
        p2 = [foo2(1),foo2(2),zmax]
        p3 = [foo3(1),foo3(2),zmax]
    end
end


scatter3(lv(:,1),lv(:,2),lv(:,3))


 end

