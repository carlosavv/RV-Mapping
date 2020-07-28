function [p0, p1, p2, p3] = guess_CA(vrw, vpv, ctd_rw, ctd_pv, g1, g2)
%% Evaluate the Bezier curve which will be Guess Central Axis (CA)
% INPUT
%       vrw, vpv: Normal to Free wall and Pulmonary Valve
%       ctd_rw, ctd_pv: Centroid of Free wall and Pulmonary Valve
%       g1, g2: Guess parameters that ensures that Bezier Curve is smooth
%       and non-self-intersecting.
% OUTPUT
%       p0, p1, p2, p3: Control points of Bezier Curve

%% Evaluate Bezier with 4 control points

% Define the control points and normals
p0 = ctd_rw; p3 = ctd_pv;
n1 = vrw; n4 = vpv;

% Ax = b equation with x as control coordinates 
A12 = zeros(3,3);

A12(1,:) = [n1(2),-n1(1),0];
A12(2,:) = [n1(3),0,-n1(1)];
A12(3,:) = [1,0,0];
b12 = [n1(2)*p0(1)-n1(1)*p0(2),-n1(1)*p0(3)+n1(3)*p0(1), g1]';

A34 = zeros(3,3);

A34(1,:) = [n4(2),-n4(1),0];
A34(2,:) = [n4(3),0,-n4(1)];
A34(3,:) = [1,0,0];
b34 = [n4(2)*p3(1)-n4(1)*p3(2),-n4(1)*p3(3)+n4(3)*p3(1), g2]';

% Evaluate the control points
p1 = (A12^(-1)*b12)';
p2 = (A34^(-1)*b34)';

end

