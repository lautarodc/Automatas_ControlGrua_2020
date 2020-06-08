%% Variables Carro
rc=15;      %Reducción
Rw=0.5;     %m
Jwc=2;      %kg.m^2
Mc=50000;   %kg
Jmc=10;     %kg.m^2
beq1=30;    %Nm/(rad/s)---bwc+bmc*(rc^2)
bmc=15;      %A definir
bwc=15;      %A definir
Jeq1=Jwc+Jmc*(rc^2);
Mt=Mc+Jeq1*(1/(Rw^2));
%% Variables Izaje
riz=30;
Rd=0.75;    %m
Jd=8;       %kg.m^2
Jmi=30;     %kg.m^2
beq2=18;    %Nm/(rad/s)---bd+bmi*(ri^2)
bmi=0.01;      %A definir
bd=9;       %A definir
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
kcy=1.3e9; %N/m
bcy=500e3;  %N/m/s
bcx=1000e3; %N/m/s
%% Configuracion
x_izq=-30;
x_der=50;
PObjetivo_incremental=0;
PObjetivo_fijo=-30; 
Y_inf_barco=-20;
Y_muelle=0;
Y_t0=45;
Y_max=40;
Y_sb=15;
AlturaInicialMuelle=2.5;
AlturaInicialBarco=2.5;

%% Trayectoria
