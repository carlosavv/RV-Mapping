function xyz = reverse_remapping_CA( remapped_points, control_points )
%REVERSE_REMAPPING_CA reverses the mapping in remapping_CA.m
% remapped_points is points in the space produced by straightening the
% Bezier curve RV central axis.

% Split remapped_points into its constituents
local_x = remapped_points( :, 1);
local_y = remapped_points( :, 2);
clen = remapped_points( :, 3);

% create storage for (x,y,z) co-ordinates of reverse-remappd points
num_points = length( local_x );
xyz = zeros( num_points, 3 );

% Algorithm description:
% for each point, find T such that clen(T) = clen
% Find B(T).
% Find unit normal Nor and unit binormal Bin at B(T)
% Reversed remapping is then P = B(T) + local_x * Nor + local_y * Bin

% Loop over all the remapped points
parfor jj = 1 : num_points
    % calculate T from current value of clen
    T = calculate_TfromClen( clen( jj ), control_points )
    % calculate B(T) - corresponding point on extended Bezier curve B
    B_T = calculate_B( T, control_points )
    % Calculate the tangent (for computation of unit normal / binormal)
    dBdT = calculate_dBdT( T, control_points )
    Tan = dBdT / sqrt( dot( dBdT, dBdT) );
    % calculate the unit normal and unit binormal at B(T)
    [ Nor, Bin ] = calculate_NormalBinormal( Tan, B_T )
    % calculate the reverse-remapped points, B(T) + local_x * Nor + local_y * Bin
    xyz( jj, : ) = B_T + local_x( jj ) * Nor + local_y( jj ) * Bin
end

end

