function val=cal_coil(posy,posz,x)
R=0.1;
mu_0=4*pi*10^(-7);
I=0.5;%励磁电流0.5A
L=2*R;
x1=x(1);%线径
x2=floor(x(2));%厚度层数
x3=floor(x(3));%宽度层数
B1=0;B2=0;
for m=1:x2
    for n=1:x3
        k1=sqrt(4*(R+(m-0.5*x2)*x1)*abs(posz)/((abs(posz)+(R+(m-0.5*x2)*x1))^2+(posz-(0.5*L+(n-0.5*x3)*x1))^2));
        k2=sqrt(4*(R+(m-0.5*x2)*x1)*abs(posz)/((abs(posz)+(R+(m-0.5*x2)*x1))^2+(posz+0.5*L+(n-0.5*x3)*x1)^2));
        [K1,E1]=ellipke(k1);
        [K2,E2]=ellipke(k2);
        B1=B1+(mu_0*I/(2*pi))   /   sqrt((abs(posz)+R+(m-0.5*x2)*x1)^2+(posy-(0.5*L+(n-0.5*x3)*x1))^2)   *(E1*(R^2-(posz)^2-(posy-(0.5*L+(n-0.5*x3)*x1))^2)/((abs(posz)-(R+(m-0.5*x2)*x1))^2+(posy-(0.5*L+(n-0.5*x3)*x1))^2)+K1);
        B2=B2+(mu_0*I/(2*pi))   /   sqrt((abs(posz)+R+(m-0.5*x2)*x1)^2+(posy+(0.5*L+(n-0.5*x3)*x1))^2)   *(E2*(R^2-(posz)^2-(posy+(0.5*L+(n-0.5*x3)*x1))^2)/((abs(posz)-(R+(m-0.5*x2)*x1))^2+(posy+(0.5*L+(n-0.5*x3)*x1))^2)+K2);

    end
end
val=B1+B2;
end