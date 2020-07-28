clear all; close all;
% 
bctrl_pts = load("D:\Workspace\RV-Fitting\cpts_bezier.dat");
tube = load("D:\Workspace\RV-Fitting\RV_tube.dat");
NURBS_cpts = load("D:\Workspace\RV-Fitting\cpts_cyl.dat");
p0 = bctrl_pts(1,:); p1 = bctrl_pts(2,:);
p2 = bctrl_pts(3,:); p3 = bctrl_pts(4,:);
p4 = bctrl_pts(5,:); p5 = bctrl_pts(6,:);
p6 = bctrl_pts(7,:); p7 = bctrl_pts(8,:);

[clen, local_x, local_y,T] = remapping_CA(bctrl_pts, tube);
a = local_x;
b = local_y;
remapped_data = [a,b,clen];
syms f
bp1 = @(f,k) 3*(1-f).^2*(p1(k)-p0(k)) + 6*(1-f).*f.*(p2(k)-p1(k)) + 2*f.^2*(p3(k)-p2(k));
bp2 = @(f,k) 3*(1-f).^2*(p5(k)-p4(k)) + 6*(1-f).*f.*(p6(k)-p5(k)) + 2*f.^2*(p7(k)-p6(k));
s1 = @(f) sqrt(bp1(f,1).^2+bp1(f,2).^2+bp1(f,3).^2);
s2 = @(f) sqrt(bp2(f,1).^2+bp2(f,2).^2+bp2(f,3).^2);
F = @(f) clen(f)  - NURBS_cpts(f,3);
const_len = integral(@(f)s1(f),0,1);
for jj = 1:length(T)
         
         t = T(jj);
         B1pt = (1-t)^3*p0 + 3*(1-t)^2*t*p1 + 3*(1-t)*t^2*p2 + t^3*p3;
         % First derivative of B
         dB1dt = 3*(1-t)^2*(p1-p0) + 6*(1-t)*t*(p2-p1) + 2*t^2*(p3-p2);
         dB1dt_mag = norm(dB1dt);
         % Tangent vector
         Tan = dB1dt/dB1dt_mag;
         Mat = [Tan(2),-Tan(1),0; Tan(3),0,-Tan(1);Tan(1),Tan(2),Tan(3)];
         Rhs = [0;0;dot(Tan,B1pt)];
         proj = Mat^-1*Rhs;
            
         % normal vector
         V = proj' - B1pt;
         V = V/sqrt(dot(V,V));
         V = V';
         % binormal vector 
         W = cross(Tan,V);
         W = W/sqrt(dot(W,W));
         W = W';
         
    for ii = 1:length(NURBS_cpts)
        if NURBS_cpts(ii,3) < const_len
            c = integral(@(f)s1(f),0,t) - NURBS_cpts(ii,3);
            x = NURBS_cpts(ii,1)*V;
            y = NURBS_cpts(ii,2)*W;
            P(ii,:) = x+y+ [0;0;c];
        end
        if NURBS_cpts(ii,3) > const_len
            c = integral(@(f)s1(f),0,t) - (NURBS_cpts(ii,3)-const_len);
            x = NURBS_cpts(ii,1)*V;
            y = NURBS_cpts(ii,2)*W;
            P(ii,:) = x+y+ [0;0;c];
        end
        
    end
    % find T s.t. clen(T) = clen
end
