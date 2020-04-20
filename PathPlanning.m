function [x,v,a,y,vy,ay,ty,index_hmax]=PathPlanning(cargado,xnuevo,ynuevo,xobj,x0,y0,vx0,vy0,vel_max_carro,vel_max_izaje,a_max_carro,a_max_izaje,jerk_accel_carro,jerk_accel_izaje,jerk_daccel_carro,jerk_daccel_izaje)
%% Acondicionamiento de envolvente de acuerdo a la carga
if cargado==1
    ynuevo=ynuevo+2.5;
end
%% Calculo de despeje de obstaculos para tramo inicial
index_columna=round(((30+xobj)/0.5)+1);
index_inicio=round(((30+x0)/0.5)+1);

if index_inicio<index_columna
    h_max=max(ynuevo(index_inicio:(index_columna-1)));
    i=index_inicio;
    while(ynuevo(i)~=h_max)
        i=i+1;
    end
else
    h_max=max(ynuevo(index_columna:(index_inicio-1)));
    i=index_columna;
    while(ynuevo(i)~=h_max)
        i=i+1;
    end
end

yobj=ynuevo(index_columna-1);
x_max=xnuevo(i)+1.25;

%% Calculo de posicion, velocidad y aceleracion del carro.
t=0:0.001:50;
x=linspace(0,0,50001);
v=linspace(0,0,50001);
a=linspace(0,0,50001);
index=1;

x_disp=xobj-x0;

vel_max_carro=VelocidadMaxima(vel_max_carro,x_disp,a_max_carro,jerk_accel_carro,jerk_daccel_carro);

[x,v,a,index]=jerk_constante(x,v,a,x0,0,0,jerk_accel_carro,x_max,vel_max_carro,a_max_carro,t,index-1);
[delta_v,delta_x,delta_t]=delta_velocidad(a(index),0,jerk_daccel_carro,1,0);
[x,v,a,index]=aceleracion_constante(x,v,a,x(index),v(index),a(index),0,x_max,vel_max_carro-delta_v,a_max_carro,t,index-1);
[x,v,a,index]=jerk_constante(x,v,a,x(index),v(index),a(index),jerk_daccel_carro,x_max,vel_max_carro,0,t,index-1);

delta_x=x(index)-x0;

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
ty=0:0.001:50;
y=linspace(0,0,50001);
vy=linspace(0,0,50001);
ay=linspace(0,0,50001);
index=1;

% Aceleracion hasta velocidad maxima
[y,vy,ay,index]=jerk_constante(y,vy,ay,y0,vy0,0,jerk_accel_izaje,h_max,vel_max_izaje,a_max_izaje,ty,index-1);
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
disp(index_xdescenso(1));
disp(index);
for i=index:index_xdescenso(1)
   y(i)=y(index);
   vy(i)=vy(index);
   ay(i)=ay(index);
end
index=index_xdescenso(1);
y_disp=yobj-y(index);
disp(y_disp);

%% Descenso de Izaje de ser necesario
if abs(y_disp)>0.5

% Calculo de velocidad máxima para el tramo de descenso
vel_max_izaje=VelocidadMaxima(vel_max_izaje,y_disp,a_max_izaje,jerk_accel_izaje,jerk_daccel_izaje);
disp(vel_max_izaje);

% Descenso del Izaje
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
end

%% Finalizacion de Trayectoria
index_hmax=index;


end