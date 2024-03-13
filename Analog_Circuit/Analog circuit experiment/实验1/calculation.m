clear
beta=100;
Vbe_on=0.6;
Vce=1.5;
Vcc=5;
P=0.001;
RE=6600;
RC=15000;
Ci=0.1*10^(-6);
C1=2*10^(-9);
RB1=50*1000;
RB2=20*1000;
RBB=RB1*RB2/(RB1+RB2);
VBB=Vcc*RB2/(RB1+RB2);
IC=(VBB-Vbe_on)/((1+beta)*RE+RBB)*beta;
gm=IC/0.026;
Av=gm*RC;
Avdb=20*log10(Av);
fH=1/(2*pi*RC*C1);
fL=1/(2*pi*RBB*Ci);
IC 
Avdb
fH
fL
% syms IC RE1 RE2 RC RB1 RB2;
% RBB=RB1*RB2/(RB1+RB2);
% VBB=Vcc*RB2/(RB1+RB2);
% eqn1=IC*(RC+RE1+RE2)+Vce==Vcc;
% eqn2=RC/RE2==80;
% eqn3=(VBB-Vbe_on)/(RBB+(RE1+RE2)*(1+beta))*beta==IC;
% eqn4=Vcc*IC+Vcc^2/(RB1+RB2)==P;
% eqn5=(RC*RE2)==4000;
% eqn6=IC*RE2==0.2*Vcc;
% eqns=[eqn1 eqn2 eqn3 eqn4 eqn5 eqn6 ];
% vars=[IC RE1 RC RB1 RB2 RE2];
% [IC0, RE10, RC0, RB10, RB20, RE20]=vpasolve(eqns,vars);
% IC0=vpa(IC0,4)
% RE0=vpa(RE10,4)
% RC0=vpa(RC0,4)
% RB10=vpa(RB10,4)
% RB20=vpa(RB20,4)
% RE20=vpa(RE20,4)
% syms IC RC RE;
% RB1=50*1000;
% RB2=20*1000;
% RBB=RB1*RB2/(RB1+RB2);
% VBB=Vcc*RB2/(RB1+RB2);
% eqn1=IC*(RC+RE)+Vce==Vcc;
% VBB
% RBB
% eqn2=(VBB-Vbe_on)/(RBB+RE*(1+beta))*beta==IC;
% eqn3=beta*RC/RBB==80;
% eqns=[eqn1 eqn2 eqn3];
% vars=[IC RE RC];
% [IC0, RE10, RC0]=vpasolve(eqns,vars);
% IC0=vpa(IC0,4)
% RE0=vpa(RE10,4)
% RC0=vpa(RC0,4)