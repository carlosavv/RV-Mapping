%CAV 6/7/2019
% generates points that fit a plane at the apex

function [rw] = generatePVPoints(rv)

zdiff = rv + [0,0,1.75];

t = find(rv <  min(zdiff));

for j = t-(length(rv)*2)
    rw = [rv(j,1),rv(j,2),rv(j,3)]';
end

end