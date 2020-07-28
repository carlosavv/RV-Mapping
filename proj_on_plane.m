function [a,b] = proj_on_plane(normal,vec1,vec2,r,p)
% normal: 1x3 normal to plane
% vec1 and vec2 : 1x3 inplane orthogonal vectors
% r: 1x3 a point on the plane
% p: 1x3 point to be projected
% q: 1x3 projection of p
% [a,b]: coordinates of q in vec1-vec2 system
alpha = dot((r-p),normal)/dot(normal,normal);
q = p + alpha*normal;
b = (vec1(1,1)*(q(1,2)-r(1,2)) - vec1(1,2)*(q(1,1)-r(1,1)))/(vec1(1,1)*vec2(1,2)-vec1(1,2)*vec2(1,1));
a = (q(1,1)-r(1,1) -b*vec2(1,1))/vec1(1,1);