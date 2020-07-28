%% Plotting the local Coordinate axes
syms r
for t = 0:0.1:1
        % Position vector B
        B1pt = (1-t)^3*p0 + 3*(1-t)^2*t*p1 + 3*(1-t)*t^2*p2 + t^3*p3;
        % First derivative of B
        dB1dt = 3*(1-t)^2*(p1-p0) + 6*(1-t)*t*(p2-p1) + 2*t^2*(p3-p2);
        dB1dt_mag = sqrt(dot(dB1dt,dB1dt));
        % Tangent vector
        Tan = dB1dt/dB1dt_mag;
        Mat = [Tan(2),-Tan(1),0; Tan(3),0,-Tan(1);Tan(1),Tan(2),Tan(3)];
        Rhs = [0;0;dot(Tan,B1pt)];
        proj = Mat^-1*Rhs;
        Nor = proj' - B1pt;
        Nor = Nor/sqrt(dot(Nor,Nor));
        Bin = cross(Tan,Nor);
        Bin = Bin/sqrt(dot(Bin,Bin));
        line1 = B1pt + r*Nor;
        line2 = B1pt + r*Bin;
        ezplot3(line1(1),line1(2),line1(3),[0,5]);
        ezplot3(line2(1),line2(2),line2(3),[0,5]);
        
        B2pt = (1-t)^3*p4 + 3*(1-t)^2*t*p5 + 3*(1-t)*t^2*p6 + t^3*p7;
        % First derivative of B
        dB2dt = 3*(1-t)^2*(p5-p4) + 6*(1-t)*t*(p6-p5) + 2*t^2*(p7-p6);
        dB2dt_mag = sqrt(dot(dB2dt,dB2dt));
        % Tangent vector
        Tan = dB2dt/dB2dt_mag;
        Mat = [Tan(2),-Tan(1),0; Tan(3),0,-Tan(1);Tan(1),Tan(2),Tan(3)];
        Rhs = [0;0;dot(Tan,B2pt)];
        proj = Mat^-1*Rhs;
        Nor = proj' - B2pt;
        Nor = Nor/sqrt(dot(Nor,Nor));
        Bin = cross(Tan,Nor);
        Bin = Bin/sqrt(dot(Bin,Bin));
        line1 = B2pt + r*Nor;
        line2 = B2pt + r*Bin;
        ezplot3(line1(1),line1(2),line1(3),[0,5]);
        ezplot3(line2(1),line2(2),line2(3),[0,5]);
end
