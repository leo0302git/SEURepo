clear 
a = 5;
b = 10;
c = 10;
l = 12;
k1 = 1;
k2 = 2;
k3 = 3;
k4 = 10;
syms x
% x = [x,y1,y2]
f = @(x)k1*x(2)+k2*sqrt((x(1))^2+(a-x(2))^2)+k3*sqrt((c-x(1))^2+(x(3)-x(2))^2)+k4*sqrt((l-c)^2+(b-x(3))^2);
x0 = [1,1,1];
A = [1,0,0;0,1,0;0,0,1];
bneq = [c;a;b];
lb = [0,0,0];
ub = [c,a,b];
[x1,val] = fmincon(f,x0,[],[],[],[],lb,ub);
plot(0,a,'.r',x(1),x(2),'.g',c,x(3),'.g',l,b,'.r');
line([0,a],[x(1),x(2)]);
line([x(1),0],[x(1),x(2)]);
line([x(1),x(2)],[c,x(3)]);
line([c,x(3)],[l,b]);
figure;