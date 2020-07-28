function [control_pts] = eval_central_axis(segment_ctd, vrw, vpv)
% Create composite Bezier curve with two segments with enforced end
% conditions

%% Define the control points
p0 = segment_ctd(1,:);
p7 = segment_ctd(end,:);

normalRW = vrw';
normalPV = vpv';

%% Parameterise the points in the range (0-1) using chord length for each section
linear_length1 = 0;
for i = 1:length(segment_ctd)/2-1
    linear_length1 = linear_length1 + sqrt(dot(segment_ctd(i,:)-segment_ctd(i+1,:),segment_ctd(i,:)-segment_ctd(i+1,:)));
end
t1 = zeros(floor(length(segment_ctd)/2),1);
temp_length = 0;
for i = 2:length(segment_ctd)/2
    temp_length = temp_length + sqrt(dot(segment_ctd(i-1,:)-segment_ctd(i,:),segment_ctd(i-1,:)-segment_ctd(i,:)));
    t1(i) = temp_length/linear_length1;
end

linear_length2 = 0;
for i = floor(length(segment_ctd)/2):length(segment_ctd)-1
    linear_length2 = linear_length2 + sqrt(dot(segment_ctd(i,:)-segment_ctd(i+1,:),segment_ctd(i,:)-segment_ctd(i+1,:)));
end
t2 = zeros(ceil(length(segment_ctd)/2),1);
temp_length = 0;
ctr = 1;
for i = floor(length(segment_ctd)/2)+1:length(segment_ctd)
    temp_length = temp_length + sqrt(dot(segment_ctd(i-1,:)-segment_ctd(i,:),segment_ctd(i-1,:)-segment_ctd(i,:)));
    t2(ctr) = temp_length/linear_length2;
    ctr = ctr+1;
end

%% Defining and minimizing variance of distance between CA and Centroids
LB = [-inf,-inf,-inf,0.1,0.1];
UB = [inf,inf,inf,50,50];

% these dont work (p1 goes way out)
% LB = [-inf,-inf,p0(3),0.1,0.1];
% UB = [p0(1),inf,inf,50,50];

res = fminsearchbnd(@(var)cost_func(t1,t2,p0,p7,normalRW,normalPV,segment_ctd,var(1),var(2),var(3),var(4),var(5)),[55,-16,-21,23,16],LB,UB);

p2 = [res(1),res(2),res(3)];
alpha = res(4)
beta = res(5)

% Control points for optimized curve


p1 = p0 + alpha*normalRW;
p6 = p7 - beta*normalPV;
p3 = p2 + 0.25*(p6-p1);
p4 = p3;
p5 = p2 + 0.5*(p6-p1);

clear max
%% Reparameterize the points using least distance
% Max_iter = 4;
% for iter = 1:Max_iter
%     Nmax = 10000; tol = 0.00001;
%     %  Formula for normal and binormal
%     bi = @(t,i) (1-t)^3*p0(i) + 3*(1-t)^2.*t.*p1(i) + 3*(1-t).*t.^2*p2(i) + t.^3*p3(i);
%     dbidt = @(t,i) 3*(1-t)^2*(p1(i)-p0(i)) + 6*(1-t)*t*(p2(i)-p1(i)) +3*t^2*(p3(i)-p2(i));
%     bi2 = @(t,i) (1-t)^3*p4(i) + 3*(1-t)^2.*t.*p5(i) + 3*(1-t).*t.^2*p6(i) + t.^3*p7(i);
%     dbi2dt = @(t,i) 3*(1-t)^2*(p5(i)-p4(i)) + 6*(1-t)*t*(p6(i)-p5(i)) +3*t^2*(p7(i)-p6(i));
%     
%     % Applying bisection method for normal to find closest point
%     for i = 1:length(t1)
%         step = 1;
%         guess_a = max(0,t1(i)-0.1); guess_b = min(1,t1(i)+0.1);
%         while step < Nmax
%             guess = (guess_a+guess_b)/2;
%             rem = (bi(guess,1)-segment_ctd(i,1))*dbidt(guess,1)+ (bi(guess,2)-segment_ctd(i,2))*dbidt(guess,2)+bi(guess,3)*dbidt(guess,3);
%             rem_a = (bi(guess_a,1)-segment_ctd(i,1))*dbidt(guess_a,1)+ (bi(guess_a,2)-segment_ctd(i,2))*dbidt(guess_a,2)+(bi(guess_a,3)-segment_ctd(i,3))*dbidt(guess_a,3);
%             rem_b = (bi(guess_b,1)-segment_ctd(i,1))*dbidt(guess_b,1)+ (bi(guess_b,2)-segment_ctd(i,3))*dbidt(guess_b,2)+(bi(guess_b,3)-segment_ctd(i,3))*dbidt(guess_b,3);
%             if rem==0 || (guess_b-guess_a)/2<=tol
%                 break;
%             elseif (rem>0 && rem_a >0) || (rem<0 && rem_a<0)
%                 guess_a = guess;
%             else
%                 guess_b = guess;
%             end
%             step = step+1;
%         end
%         t1_new(i,1)=guess;
%     end
%     % If not found in segment 1 then search in segment 2
%     for i = 1:length(t2)
%         step = 1;
%         guess_a = max(0,t2(i)-0.1); guess_b = min(1,t2(i)+0.1);
%         const= length(t1);
%         while step < Nmax
%             guess = (guess_a+guess_b)/2;
%             rem = (bi2(guess,1)-segment_ctd(i+const,1))*dbi2dt(guess,1)+ (bi2(guess,2)-segment_ctd(i+const,2))*dbi2dt(guess,2)+bi2(guess,3)*dbi2dt(guess,3);
%             rem_a = (bi2(guess_a,1)-segment_ctd(i+const,1))*dbi2dt(guess_a,1)+ (bi2(guess_a,2)-segment_ctd(i+const,2))*dbi2dt(guess_a,2)+(bi2(guess_a,3)-segment_ctd(i+const,3))*dbi2dt(guess_a,3);
%             rem_b = (bi2(guess_b,1)-segment_ctd(i+const,1))*dbi2dt(guess_b,1)+ (bi2(guess_b,2)-segment_ctd(i+const,3))*dbi2dt(guess_b,2)+(bi2(guess_b,3)-segment_ctd(i+const,3))*dbi2dt(guess_b,3);
%             if (rem==0 || (guess_b-guess_a)/2<=tol)
%                 break;
%             elseif ((rem>0 && rem_a >0) || (rem<0 && rem_a<0))
%                 guess_a = guess;
%             else
%                 guess_b = guess;
%             end
%             step = step+1;
%         end
%         t2_new(i,1)=guess;
%     end
%     t1 = t1_new;
%     t2 = t2_new;
%     % Re-evaluating Bezier curve
%     LB = [-inf,-inf,-inf,0.1,0.1];
%     UB = [inf,inf,inf,50,50];
%     res = fminsearchbnd(@(var)cost_func(t1,t2,p0,p7,normalRW,normalPV,segment_ctd,var(1),var(2),var(3),var(3),var(5)),[1,1,1,1,1],LB,UB);
%     p2 = [res(1),res(2),res(3)];
%     alpha = res(4); beta = res(5);
%     p1 = p0 + alpha*normalRW;
%     p6 = p7 - beta*normalPV;
%     p3 = p2 + 0.25*(p6-p1);
%     p4 = p3;
%     p5 = p2 + 0.5*(p6-p1);
% end

control_pts = [p0; p1; p2; p3; p4; p5; p6; p7];
end