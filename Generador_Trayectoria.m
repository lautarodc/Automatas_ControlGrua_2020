function [x,v,a,y,vy,ay,ty,index_hmax]=Generador_Trayectoria(cargado,xnuevo,ynuevo,xobj,yobj,x0,y0,vy0,x_max,h_max,vel_max_carro,vel_max_izaje,a_max_carro,a_max_izaje,jerk_accel_carro,jerk_accel_izaje,jerk_daccel_carro,jerk_daccel_izaje)
%% Acondicionamiento de envolvente de acuerdo a la carga
if cargado==1
    for i=1:length(ynuevo)
        ynuevo(i)=ynuevo(i)+2.5;
    end
end

%% Calculo de posicion, velocidad y aceleracion del carro.
t=0:0.1:50;
x=linspace(0,0,501);
v=linspace(0,0,501);
a=linspace(0,0,501);
index=0;


[x,v,a,index]=jerk_constante(x,v,a,x0,0,0,jerk_accel_carro,x_max,vel_max_carro,a_max_carro,t,index);
[delta_v,delta_x,delta_t]=delta_velocidad(a(index),0,jerk_daccel_carro,1,0);
[x,v,a,index]=aceleracion_constante(x,v,a,x(index),v(index),a(index),0,x_max,vel_max_carro-delta_v,a_max_carro,t,index-1);
[x,v,a,index]=jerk_constante(x,v,a,x(index),v(index),a(index),jerk_daccel_carro,x_max,vel_max_carro,0,t,index-1);

% Calcular el delta X de la etapa de desaceleracion 
j1=jerk_daccel_carro;
[delta_v1,delta_x1,delta_t1]=delta_velocidad(0,-a_max_carro,j1,2,vel_max_carro);
j3=jerk_accel_carro;
[delta_v3,delta_x3,delta_t3]=delta_velocidad(-a_max_carro,0,j3,1,0);
[delta_v3,delta_x3,delta_t3]=delta_velocidad(-a_max_carro,0,j3,2,(0-delta_v3));
delta_x2=((0-delta_v3)^2-(vel_max_carro+delta_v1)^2)/(2*-a_max_carro);
delta_x=delta_x1+delta_x2+delta_x3;


[x,v,a,index]=velocidad_constante(x,v,a,x(index),v(index),a(index),0,xobj-delta_x,vel_max_carro,0,t,index-1);
[x,v,a,index]=jerk_constante(x,v,a,x(index),v(index),a(index),jerk_daccel_carro,x_max,vel_max_carro,-a_max_carro,t,index-1);
[delta_v,delta_x,delta_t]=delta_velocidad(-a_max_carro,0,jerk_accel_carro,1,0);
[x,v,a,index]=aceleracion_constante(x,v,a,x(index),v(index),a(index),0,x_max,0-delta_v,-a_max_carro,t,index-1);
[x,v,a,index]=jerk_constante(x,v,a,x(index),v(index),a(index),jerk_accel_carro,x_max,vel_max_carro,0,t,index-1);
if abs(xobj-x(index))<0.01
    x(index)=xobj;
end

for i=index:length(x)
    x(i)=x(index);
end

index_xmax=find(x>=x_max);
tiempo_total_x=t(index_xmax(1));
%% Calculo de posicion, velocidad y aceleracion de izaje
ty=0:0.1:50;
y=linspace(0,0,501);
vy=linspace(0,0,501);
ay=linspace(0,0,501);
index=0;

% Aceleracion hasta velocidad maxima
[y,vy,ay,index]=jerk_constante(y,vy,ay,y0,vy0,0,jerk_accel_izaje,h_max,vel_max_izaje,a_max_izaje,ty,index);
[delta_v,delta_y,delta_t]=delta_velocidad(ay(index),0,jerk_daccel_izaje,1,0);
[y,vy,ay,index]=aceleracion_constante(y,vy,ay,y(index),vy(index),ay(index),0,h_max,vel_max_izaje-delta_v,a_max_izaje,ty,index-1);
[y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_daccel_izaje,h_max,vel_max_izaje,0,ty,index-1);

%Calculo de deltas para la desaceleracion desde velocidad maxima
[delta_v,delta_y,delta_t]=deaccel_izaje(vel_max_izaje,a_max_izaje,jerk_accel_izaje,jerk_daccel_izaje);
y_velmax=h_max-y(index)-delta_y;
% Tramo a velocidad constante
[y,vy,ay,index]=velocidad_constante(y,vy,ay,y(index),vy(index),ay(index),0,y(index)+y_velmax,vel_max_izaje,0,ty,index-1);

% Tramo de desaceleracion a velocidad de izaje 0
[y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_daccel_izaje,h_max,vel_max_izaje,-a_max_izaje,ty,index-1);
[delta_v,delta_y,delta_t]=delta_velocidad(ay(index),0,jerk_accel_izaje,1,0);
[y,vy,ay,index]=aceleracion_constante(y,vy,ay,y(index),vy(index),ay(index),0,h_max,0-delta_v,-a_max_izaje,ty,index-1);
[y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_accel_izaje,h_max,vel_max_izaje,0,ty,index-1);

% index_hmax=find(y>=h_max);
index_x_inicio=index-index_xmax(1);

%% Conciliacion de indices y tiempos para x e y
indice_final=length(x)-index_x_inicio;

xaux=x(1:indice_final);
vaux=v(1:indice_final);
aaux=a(1:indice_final);
x(1:index_x_inicio)=xaux(1);
v(1:index_x_inicio)=0;
a(1:index_x_inicio)=0;


if index_x_inicio+index_xmax(1)>index
    x((index_x_inicio):length(x))=xaux;
    v((index_x_inicio):length(x))=vaux;
    a((index_x_inicio):length(x))=aaux;
else
    x((index_x_inicio+1):length(x))=xaux;
    v((index_x_inicio+1):length(x))=vaux;
    a((index_x_inicio+1):length(x))=aaux;
end


%% Evaluacion de colisiones para el calculo del punto de inicio de descenso de izaje
indice_ant=round(((30+x_max)/0.5)+1);
indice=round(((30+x_max)/0.5)+1);
indice_sig=round(((30+xobj)/0.5)+1);
indice_ok=DespejeColision(h_max,xnuevo,ynuevo,indice_sig,indice_sig,indice_ant,indice_sig,indice);
m=(ynuevo(indice_sig)-ynuevo(indice_ok))/(xnuevo(indice_sig)-xnuevo(indice_ok));
if m==0
    x_descenso=xobj;
else
    x_descenso=xnuevo(indice_ok);
end

index_xdescenso=find(x>=x_descenso);
for i=index:index_xdescenso(1)
   y(i)=y(index);
   vy(i)=vy(index);
   ay(i)=ay(index);
end
index=index_xdescenso(1);
y_disp=yobj-y(index);

%% Calculo de velocidad máxima para el tramo de descenso
j1=jerk_accel_izaje;
[delta_v1,delta_y1,delta_t1]=delta_velocidad(0,a_max_izaje,j1,1,0);
j3=jerk_daccel_izaje;
[delta_v3,delta_y3,delta_t3]=delta_velocidad(a_max_izaje,0,j3,1,0);
[delta_v3,delta_y3,delta_t3]=delta_velocidad(a_max_izaje,0,j3,2,(0-delta_v3));
a1=2*(-1/(2*a_max_izaje));
b1=2*(delta_t1-(2*delta_v1)/(2*a_max_izaje));
c1=-y_disp+2*((1/6)*j1*(delta_t1^3)+(1/(2*a_max_izaje))*(delta_v3^2-delta_v1^2)+delta_y3);
coef=[a1 b1 c1];
r=roots(coef);
if abs(r(2))>=abs(vel_max_izaje)
    vel_max_izaje=vel_max_izaje*-1;
else
    vel_max_izaje=r(2);
end
disp(vel_max_izaje);
%% Descenso del Izaje
y0_aux=y(index);
[y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_daccel_izaje,yobj,vel_max_izaje,-a_max_izaje,ty,index-1);
[delta_v,delta_y,delta_t]=delta_velocidad(ay(index),0,jerk_accel_izaje,1,0);
[y,vy,ay,index]=aceleracion_constante(y,vy,ay,y(index),vy(index),ay(index),0,h_max,vel_max_izaje-delta_v,-a_max_izaje,ty,index-1);
[y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_accel_izaje,h_max,vel_max_izaje,0,ty,index-1);
y1_aux=y(index);

%Calculo de deltas para la desaceleracion desde velocidad maxima
delta_y=y1_aux-y0_aux;
y_velmax=yobj-delta_y;
% Tramo a velocidad constante
[y,vy,ay,index]=velocidad_constante(y,vy,ay,y(index),vy(index),ay(index),0,y_velmax,vel_max_izaje,0,ty,index-1);

% Tramo de desaceleracion a velocidad de izaje 0
[y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_accel_izaje,h_max,vel_max_izaje,a_max_izaje,ty,index-1);
[delta_v,delta_y,delta_t]=delta_velocidad(ay(index),0,jerk_daccel_izaje,1,0);
[y,vy,ay,index]=aceleracion_constante(y,vy,ay,y(index),vy(index),ay(index),0,h_max,0-delta_v,a_max_izaje,ty,index-1);
[y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_daccel_izaje,h_max,vel_max_izaje,0,ty,index-1);

index_hmax=index;


end