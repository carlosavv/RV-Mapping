function s = cost_func(t1,t2,p0,p7,n0,n7,segment_ctd,x2,y2,z2,alpha,beta)
% INPUT
%       p0, p7: Control points at the end of Composite Bezier
%       n0, n7: Distance at these end points
%       x2, y2, z2: Coordinates of third control point 'p2'
%       alpha, beta: Length of normals at the the end point
% 
% OUTPUT
%       s: Variance of deviation of Composite Bezier from Centroids

%% Evaluate Bezier control points
alpha = abs(alpha);
beta = abs(beta);
p1 = p0 + alpha*n0;
p2 = [x2 y2 z2];
p6 = p7 - beta*n7;
p3 = p2 + 0.25*(p6-p1);
p4 = p3;
p5 = p2 + 0.5*(p6-p1);

% Evaluate Deviation
s=0;
for i = 1:length(t1)
    s1 = (1-t1(i))^3*p0 + 3*(1-t1(i))^2*t1(i)*p1 + 3*(1-t1(i))*t1(i)^2*p2 + t1(i)^3*p3;
    s = s + dot(s1-segment_ctd(i,:),s1-segment_ctd(i,:));
end

for i = 1:length(t2)
    s2 = (1-t2(i))^3*p4 + 3*(1-t2(i))^2*t2(i)*p5 + 3*(1-t2(i))*t2(i)^2*p6 + t2(i)^3*p7;
    s = s +dot(s2-segment_ctd(length(t1)+i,:),s2-segment_ctd(length(t1)+i,:));
end
end