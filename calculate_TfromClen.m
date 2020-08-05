function T_current = calculate_TfromClen( clen, control_points )
%CALCULATE_TFROMCLEN Calculates Bezier curve variable T from a length along
%the curve.

% To calculate T from clen, we need to find T such that int_0^T ds = clen

% Calculate the length of the curved portion of B
const_len_B = calculate_clen( 2,control_points );

if clen <= 0 % straight line along tangent at B(0)
    T_current = clen; % By definition, because B = T * dBdT(0)
elseif clen < const_len_B % solve using optimiser for now, could also use Newton-Raphson
    opt_fun = @( T ) calculate_clen( T, control_points ) - clen; % minimum where clen(T) = clen
    T_current = fminbnd( opt_fun, 0, 2 );
else % straight line along tangent at B(2)
    T_current = clen - const_len_B + 2;
end

end

