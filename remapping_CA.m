function [clen, local_x, local_y] = remapping_CA( control_pts, rv ) 
%% Remap the RV along its Bezier curve central axis.

% Algorithm description:

% We extend the Bezier curve as follows to create a curve B(T)
% When T < 0, B(T) = B1(0) + T * unit tangent at B1(0)
% When 0 <= T < 1, t = T, B(T) = B1(t)
% When 1 <= T <= 2, t = T-1,  B(T)= B2(t)
% When T > 2, B(T) = B2(1) + (T - 2) * unit tangent at B2(1)

% (where B1, B2 have internal variable t in [ 0 1 ] )

% let P be a point on the RV. We seek T such that |P-B(T)| is minimal,
% and consequently P-B(T) is normal to dBdT
% We solve this problem using fminsearch for now.

% Get the total number of RV points
num_points = length( rv(:,1) );

% Create holding vectors for clen, local_x and local_y: assign value NaN to
% weed out any bad values at the end
clen = nan(num_points, 1 );
local_x = nan(num_points, 1 );
local_y = nan(num_points, 1 );

% Define epsilon for checking whether B(T)-P is normal to dBdT
epsilon = 1e-3;

% loop over the RV points in parallel
parfor jj = 1 : num_points
    % Get current RV point P
    P = rv( jj, : );
    % Define optimization function as magnitude of B(T)-P
    opt_fun = @(T) norm( calculate_B( T, control_pts ) - P );
    % Calculate T value that minimizes |B(T)-P|, using "middle" of curve
    % (T=1) as start point
    % can improve this method for sure by playing with tolerances and
    % multiple start points.
    T_opt = fminsearch( @(T) opt_fun(T), 1 );
    % Calculate B(T_opt)
    B_Topt = calculate_B( T_opt, control_pts );
    % Calculate the tangent at T_opt
    dBdT_opt =calculate_dBdT( T_opt, control_pts );
    % calculate the unit tangent
    Tan = dBdT_opt / norm( dBdT_opt );
    % let r = P - B(T_opt)
    r = P - B_Topt;
    % Check for normality, just in case.
    if dot( Tan, r) < epsilon
        % Because r is normal to the tangent, r is in the Frenet
        % frame at B(T). Let Nor be the unit normal at B(T) and Bin be the 
        % unit binormal at B(T). 
        % We need a,b such that 
        % r = a*Nor+b*Bin
        % Hence, 
        % r(1) = a*Nor(1) + b*Bin(1)
        % r(2) = a*Nor(2) + b*Bin(2)
        % solve as a linear system:
        ab = [ Nor(1) Bin(1); Nor(2) Bin(2) ]\r';
        % store a and b as local_x and local_y
        local_x(jj) = ab(1);
        local_y(jj) = ab(2);
        % Calculate the length along the curve by integration:
        clen( jj ) = calculate_clen( T_opt, control_pts );
    end % otherwise, left as NaN, tidy up at end
    
end

% Remove any NaNs - these points didn't work and will require debugging
nan_idx = isnan( clen );
clen(nan_idx) = [];
local_x(nan_idx) = [];
local_y(nan_idx) = [];

end
