function [ Nor, Bin ] = calculate_NormalBinormal( Tan, point )
% Calculation of normal and binormal from tangent and point on curve.

% Normal always points towards the LV central axis, i.e. the z-axis of the
% current plot. Find normal by projection onto z-axis
Mat = [Tan(2),-Tan(1),0; Tan(3),0,-Tan(1);Tan(1),Tan(2),Tan(3)];
Rhs = [0;0;dot(Tan,point)];
proj = Mat^-1*Rhs;
Nor = proj' - point;
% Normalise the normal
Nor = Nor/sqrt(dot(Nor,Nor));
% Calculate the binormal - cross product of the tangent and normal
Bin = cross(Tan,Nor);
Bin = Bin/sqrt(dot(Bin,Bin));

end