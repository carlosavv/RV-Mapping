function [clen, local_x, local_y,T] = remapping_CA(control_pts, rv)
% Parameterize the RV point cloud using the Second Bezier Curve
% The coordinates would include clen: curvature length
% and polar coordinates phi : polar angle, rad : polar radius
% or alternately, local_x and local_y in each plane

%% The control points are stored as p0 p1 p2 p3 p4 p5 p6 and p7
p0 = control_pts(1,:); p1 = control_pts(2,:);
p2 = control_pts(3,:); p3 = control_pts(4,:);
p4 = control_pts(5,:); p5 = control_pts(6,:);
p6 = control_pts(7,:); p7 = control_pts(8,:);

% Point cloud
x = rv(:,1); y = rv(:,2); z = rv(:,3);

%  Using them we create the parameterization.
planar_tol = 0.1;

% Define the function for curve length
syms f
bp1 = @(f,k) 3*(1-f).^2*(p1(k)-p0(k)) + 6*(1-f).*f.*(p2(k)-p1(k)) + 2*f.^2*(p3(k)-p2(k));
bp2 = @(f,k) 3*(1-f).^2*(p5(k)-p4(k)) + 6*(1-f).*f.*(p6(k)-p5(k)) + 2*f.^2*(p7(k)-p6(k));
s1 = @(f) sqrt(bp1(f,1).^2+bp1(f,2).^2+bp1(f,3).^2);
s2 = @(f) sqrt(bp2(f,1).^2+bp2(f,2).^2+bp2(f,3).^2);

% Defining the storage space
clen = -1*ones(length(x),1);
local_x = -1*ones(length(x),1);
local_y = zeros(length(x),1);
const_len = integral(@(f)s1(f),0,1);
parfor j = 1:length(x) 
    sample_pt = [x(j),y(j),z(j)];
    for t = 0:0.001:1
        % Position vector B
        B1pt = (1-t)^3*p0 + 3*(1-t)^2*t*p1 + 3*(1-t)*t^2*p2 + t^3*p3;
        % First derivative of B
        dB1dt = 3*(1-t)^2*(p1-p0) + 6*(1-t)*t*(p2-p1) + 2*t^2*(p3-p2);
        dB1dt_mag = norm(dB1dt);
        % Tangent vector
        Tan = dB1dt/dB1dt_mag;
        flag = 0;
        if abs(dot(Tan,(B1pt-sample_pt))) < planar_tol
            flag = 1;
            clen(j) = integral(@(f)s1(f),0,t)
%             disp(clen(j))
            % Projecting the origin vector 
            Mat = [Tan(2),-Tan(1),0; Tan(3),0,-Tan(1);Tan(1),Tan(2),Tan(3)];
            Rhs = [0;0;dot(Tan,B1pt)];
            proj = Mat^-1*Rhs;
            Nor = proj' - B1pt;
            Nor = Nor/sqrt(dot(Nor,Nor));
            Bin = cross(Tan,Nor);
            Bin = Bin/sqrt(dot(Bin,Bin));
            
            [local_x(j),local_y(j)] = proj_on_plane(Tan,Nor,Bin,B1pt,[x(j),y(j),z(j)]);
            T(j) = t
        break;
        end
        % Position vector B
        B2pt = (1-t)^3*p4 + 3*(1-t)^2*t*p5 + 3*(1-t)*t^2*p6 + t^3*p7;
        % First derivative of B
        dB2dt = 3*(1-t)^2*(p5-p4) + 6*(1-t)*t*(p6-p5) + 2*t^2*(p7-p6);
        dB2dt_mag = sqrt(dot(dB2dt,dB2dt));
        % Tangent vector
        Tan = dB2dt/dB2dt_mag;
        if (flag == 0 && abs(dot(Tan,(B2pt-sample_pt))) < planar_tol) 
            clen(j) = integral(@(f)s2(f),0,t) + const_len;
            % Projecting the origin vector 
            Mat = [Tan(2),-Tan(1),0; Tan(3),0,-Tan(1);Tan(1),Tan(2),Tan(3)];
            Rhs = [0;0;dot(Tan,B2pt)];
            proj = Mat^-1*Rhs;
            Nor = proj' - B2pt;
            Nor = Nor/sqrt(dot(Nor,Nor));
            Bin = cross(Tan,Nor);
            Bin = Bin/sqrt(dot(Bin,Bin));
            [local_x(j),local_y(j)] = proj_on_plane(Tan,Nor,Bin,B2pt,[x(j),y(j),z(j)]);
            T(j) = t
        break;
        end
    end
end

end
