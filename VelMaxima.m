function [velmax_out,vel_accel] = VelMaxima(velmax_in,xdisp,amax,jerkaccel,jerkdaccel,a0,v0)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if xdisp>0
    j1=jerkaccel;
    j3=jerkdaccel;
    j4=jerkdaccel;
    j6=jerkaccel;
    amax_1=amax;
    amax_2=-amax;
else
    j1=jerkdaccel;
    j3=jerkaccel;
    j4=jerkaccel;
    j6=jerkdaccel;
    amax_1=-amax;
    amax_2=amax;
    velmax_in=-velmax_in;
end

% Primer tramo de la trayectoria.

[delta_v1,delta_x1,~]=delta_velocidad(a0,amax_1,j1,2,v0);
v1=v0+delta_v1;
[delta_v3,~,delta_t3]=delta_velocidad(amax_1,0,j3,1,0);
a_1=1/(2*amax_1);
b_1=delta_t3-((2*delta_v3)/(2*amax_1));
c_1=delta_x1+(delta_v3^2)/(2*amax_1)-(v1^2)/(2*amax_1)+(1/6)*j3*(delta_t3^3)+(1/2)*amax_1*(delta_t3^2)-delta_v3*delta_t3;

% Segundo tramo de la trayectoria
[delta_v4,~,delta_t4]=delta_velocidad(0,amax_2,j4,1,0);
[delta_v6,~,~]=delta_velocidad(amax_2,0,j6,1,0);
[delta_v6,delta_x6,~]=delta_velocidad(amax_2,0,j6,2,(0-delta_v6));
a_2=(-1/(2*amax_2));
b_2=(delta_t4-(2*delta_v4)/(2*amax_2));
c_2=(1/6)*j4*(delta_t4^3)+(1/(2*abs(amax_2)))*(delta_v6^2-delta_v4^2)+delta_x6;

% Coeficientes de la ecuacion de 2do grado
a=a_1+a_2;
b=b_1+b_2;
c=-xdisp+c_1+c_2;
coef=[a b c];
r=roots(coef);

% Comparacion de la velocidad maxima con la calculada
if abs(r(2))>=abs(velmax_in)
    velmax_out=velmax_in;
else
    velmax_out=r(2);
end

vel_accel=v1+delta_v3;


end

