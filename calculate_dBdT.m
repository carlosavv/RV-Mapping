function dBdT = calculate_dBdT( T, control_pts )
% Definition of gradient dBdT of extended Bezier curve B

% unpack control points
p0 = control_pts(1,:); p1 = control_pts(2,:);
p2 = control_pts(3,:); p3 = control_pts(4,:);
p4 = control_pts(5,:); p5 = control_pts(6,:);
p6 = control_pts(7,:); p7 = control_pts(8,:);

% Check cases
if T >= 0 && T < 1 % If in B1
    t = T;
    % Derivative of curve B1 using internal variable t.
    dBdT = 3*(1-t)^2*(p1-p0) + 6*(1-t)*t*(p2-p1) + 2*t^2*(p3-p2);
elseif T >= 1 && T <=2 % If in B2
    t = T-1;
    % Derivative of curve B2 using internal variable t.
    dBdT = 3*(1-t)^2*(p5-p4) + 6*(1-t)*t*(p6-p5) + 2*t^2*(p7-p6);
elseif T < 0 % Use gradient at T = 0 in B1
    t = 0;
    dBdT = 3*(1-t)^2*(p1-p0) + 6*(1-t)*t*(p2-p1) + 2*t^2*(p3-p2);
else % T > 2, use gradient at T = 2 in B2
    t = 1;
    dBdT = 3*(1-t)^2*(p5-p4) + 6*(1-t)*t*(p6-p5) + 2*t^2*(p7-p6);
end

end