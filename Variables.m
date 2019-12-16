%% Variables Carro
rc=15;      %Reducción
Rw=0.5;     %m
Jwc=2;      %kg.m^2
Mt=50000;   %kg
Jmc=10;     %kg.m^2
beq1=30;    %Nm/(rad/s)---bwc+bmc*(rc^2)
bmc=0;      %A definir
bwc=0;      %A definir
Jeq1=Jwc+Jmc*(rc^2);
bt=0;
%% Variables Izaje
Mh=0;       %A definir
riz=30;
Rd=0.75;    %m
Jd=8;       %kg.m^2
Jmi=30;     %kg.m^2
beq2=18;    %Nm/(rad/s)---bd+bmi*(ri^2)
bmi=0;      %A definir
bd=0;       %A definir
bh=0;
Jeq2=Jd+Jmi*(riz^2);
%% Variables péndulo
Kw=1800e3;  %N/m
bw=30000;   %N/(m/s)
ml_0=15000; %kg
ml_n=65000; %kg
ml_min=17000;
%% Variables estructurales
Y_t0=45;
g=9.81;     %m/s^2

