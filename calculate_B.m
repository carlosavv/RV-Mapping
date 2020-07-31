function B = calculate_B( T, control_pts )
% Definition of extended Bezier Curve B

% unpack control points
p0 = control_pts(1,:); p1 = control_pts(2,:);
p2 = control_pts(3,:); p3 = control_pts(4,:);
p4 = control_pts(5,:); p5 = control_pts(6,:);
p6 = control_pts(7,:); p7 = control_pts(8,:);

% Check cases
if T >= 0 && T < 1 % If in B1
    t = T;
    % Point on curve B1 using internal variable t.
    B = (1-t)^3*p0 + 3*(1-t)^2*t*p1 + 3*(1-t)*t^2*p2 + t^3*p3;
elseif T >= 1 && T <=2 % If in B2
    t = T-1;
    % Derivative of curve B2 using internal variable t.
    B = (1-t)^3*p4 + 3*(1-t)^2*t*p5 + 3*(1-t)*t^2*p6 + t^3*p7;
elseif T < 0 % Use gradient and point at T = 0
    t = 0;
    % Start point of curve B(0)
    B_0 = (1-t)^3*p0 + 3*(1-t)^2*t*p1 + 3*(1-t)*t^2*p2 + t^3*p3;
    % Calculate tangent to the curve at T = 0
    dBdT_0 = calculate_dBdT( 0, control_pts );
    % calculate unit tangent by normalising with magnitude of tangent.
    dBdT_0_unit= dBdT_0 / sqrt( dot( dBdT_0, dBdT_0 ) );
    % Calculate point on curve by moving in straight line from B(0) along
    % tangent at T=0. Note T is negative so will move in opposite direction
    % of tangent.
    B = B_0 + dBdT_0_unit * T;
else % T > 2, use gradient at T = 2
    t = 1; % t = T-1
    % End point of curve B(2)
    B_2 = (1-t)^3*p4 + 3*(1-t)^2*t*p5 + 3*(1-t)*t^2*p6 + t^3*p7;
    % Calculate the tangent to the curve at T = 2
    dBdT_2 = calculate_dBdT( 2, control_pts );
    % calculate unit tangent by normalising with magnitude of tangent.
    dBdT_2_unit = dBdT_2 / sqrt( dot( dBdT_2, dBdT_2 ) );
    % Calculate point on curve by moving in straight line from B(2) along
    % tangent at T=2. Note T-2 is positive so will move in direction of the
    % tangent.
    B = B_2 * dBdT_2_unit * ( T - 2 );
end

end