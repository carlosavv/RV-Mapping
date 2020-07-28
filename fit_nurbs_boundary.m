% function fit_nurbs_boundary(num_sec, ncp_sect, clen, local_x, local_y)
%%

% Loop over 
num_sec = 50;
deg = 2; ncp_sect = 10;
max_clen = max(clen);
min_clen = min(clen);
delc = (max_clen-min_clen)/num_sec;
for i = num_sec
    ctr = 1;
    if i~= 1
        clear section;
    end
    % Find all points lying in single section
    if clen(i) <= delc * i
        if clen(i) > delc * (i-1)
            section(ctr,:) = [local_x(i),local_y(i), delc*i];
            ctr = ctr +1;
        end
    end
    
    % Compute boundary of the section eg. using Convex hull
    hull_index = convhull(section(:,1), section(:,2), section(:,3));
    
    
    % Fit NURBS curve to the boundary of the section
    [cp, ~] = fitNURBS(section(hull_index,:), deg, );
    
end
    