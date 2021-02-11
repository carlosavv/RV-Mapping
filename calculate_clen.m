function clen = calculate_clen( T, control_pts )
% Calculation of clen along the extended Bezier curve B

% unpack control points
p0 = control_pts(1,:); p1 = control_pts(2,:);
p2 = control_pts(3,:); p3 = control_pts(4,:);
p4 = control_pts(5,:); p5 = control_pts(6,:);
p6 = control_pts(7,:); p7 = control_pts(8,:);

% Define the functions for the Bezier curve and curve length
syms f
% Bezier curves B1 and B2
bp1 = @(f,k) 3*(1-f).^2*(p1(k)-p0(k)) + 6*(1-f).*f.*(p2(k)-p1(k)) + 2*f.^2*(p3(k)-p2(k));
bp2 = @(f,k) 3*(1-f).^2*(p5(k)-p4(k)) + 6*(1-f).*f.*(p6(k)-p5(k)) + 2*f.^2*(p7(k)-p6(k));
% curvatures - integrate these for curve length
s1 = @(f) sqrt(bp1(f,1).^2+bp1(f,2).^2+bp1(f,3).^2);
s2 = @(f) sqrt(bp2(f,1).^2+bp2(f,2).^2+bp2(f,3).^2);

% Calculate length constants:
% length of first curve
const_len_B1 = integral(@(f)s1(f),0,1);
% length of second curve
const_len_B2 = integral(@(f)s2(f),0,1);
% total length of curved section
const_len_B = const_len_B1 + const_len_B2;

% Check cases:
if T < 0 % By definition, distance along curve is equal to T and is negative because in this case B(T) is extended to be T * unit tangent at T=0
    clen = T;
elseif T <= 1 % integrate along curve B1 only, t = T
    clen = integral(@(f)s1(f),0,T);
elseif T <=2 % integrate along entirety of B1 and appropriate amount of B2, t = T-1
    clen = const_len_B1 + integral(@(f)s2(f),0, T-1 );
else % integrate along all of B, then along unit tangent, T > 2
    clen = const_len_B + T - 2;
end

end