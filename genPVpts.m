% CAV 6/7/2019
% generates points that fit a plane at the PV
function [vpv,ctd_pv] = genPVpts(rv)
% rv = load('/Users/RV/Documents/smooth_ZH_64_016Y_MaskLV_7_MS_RVendo.dat');


% 
% idxx = find(rv == min(rv(:,1)));
% 

idxz = find(rv(:,3) == min(rv(:,3)));
% vpv = rv(idxx,:)-rv(idxz,:);
testpt = input('Enter a point (x,y,z) located at the PV: ');

vpv = testpt - rv(idxz,:);
vpv = vpv/sqrt(dot(vpv,vpv));
ctd_pv = testpt;

tol = 1;
% pvx = zeros(length(rv),1);
% pvy = zeros(length(rv),2);
% pvz = zeros(length(rv),3);

for loop = 1:5
    j = 1;
    clear pvx pvy pvz;
    for i=1:length(rv)
        
        result = dot(vpv,rv(i,:)-ctd_pv);
        if abs(result) <= tol 
            pvx(j) = rv(i,1);
            pvy(j) = rv(i,2);
            pvz(j) = rv(i,3); 
        j=j+1;
        end
    end
end

[vpv, ~, ctd_pv] = affine_fit([pvx',pvy',pvz']);

syms xs ys zs
P = [xs ys zs];
hold on
plane_function1 = dot(vpv, P-ctd_pv);

zplane1 = solve(plane_function1,zs); 

% fmesh(zplane1,[min(rv(:,1)),max(rv(:,1)),min(rv(:,1)),max(rv(:,1))])
% scatter3(rv(:,1),rv(:,2),rv(:,3))
end

