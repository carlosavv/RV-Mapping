function plot_bezier(p0, p1, p2, p3, color)
%% Plot the  Bezier Curve (FBC)
%  INPUT
%       p0, p1, p2, p3: Control Points
t = (0:0.005:1);
B = zeros(length(t),3);
for i = 1:length(t)
    B(i,:) = (1-t(i)).^3*p0 + 3*(1-t(i))^2.*t(i).*p1 + 3*(1-t(i)).*t(i).^2*p2 + t(i).^3*p3;
end
plot3(B(:,1),B(:,2),B(:,3),'linewidth',3, 'Color', color); 
end