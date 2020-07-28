% CAV 6/7/2019
% generates points that fit a plane at the apex
function [vrw,ctd_rw] = generateApexPoints(rv,ctd_pv)
% rv = load('/Users/RV/Documents/smooth_ZH_22_014Y_MaskLV_3_MS_RVendo.dat');
% zdiff = rv - [1.75,0,0];

% idxx = find(rv == max(rv(:,1)));
% idxz = find(rv == min(rv(:,1)));
testpt = input('Enter a point (x,y,z) located at the free wall: ');
vrw = testpt - ctd_pv;
vrw = vrw/sqrt(dot(vrw,vrw));
ctd_rw = testpt;
tol = 5;



for loop = 1:5
    j = 1;
    clear pvx pvy pvz;
    for i=1:length(rv)
        result = dot(vrw,rv(i,:)-ctd_rw);
        if abs(result) <= tol 
            pvx(j) = rv(i,1);
            pvy(j) = rv(i,2);
            pvz(j) = rv(i,3); 
        j=j+1;
        end
    end
    [vrw, ~, ctd_rw] = affine_fit([pvx',pvy',pvz']);
end



end