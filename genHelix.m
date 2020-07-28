%plot the mesh
u=linspace(0,-2*pi/3,50);
v=linspace(0,2*pi,50);
[u,v]=meshgrid(u,v);
x=sin(v)+u/pi;
y=(1.2+0.5*cos(v)).*sin(u);
z=(1.2+0.5*cos(v)).*cos(u);
plot3(x,y,z)
hold on

%plot the 3d line
u = linspace(0,4*pi,40)
x=cos(u);
y=sin(u);
z=u/pi;

