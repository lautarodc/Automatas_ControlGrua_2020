function [x,v,a,y,vy,ay,ty,index_hmax]=Generador_Trayectoria(x0,y0,vy0,x_max,h_max,vel_max_carro,vel_max_izaje,a_max_carro,a_max_izaje,jerk_accel_carro,jerk_accel_izaje,jerk_daccel_carro,jerk_daccel_izaje)
%% Calculo de posicion, velocidad y aceleracion del carro
t=0:0.1:30;
x=linspace(0,0,301);
v=linspace(0,0,301);
a=linspace(0,0,301);
index=0;
[x,v,a,index]=jerk_constante(x,v,a,x0,0,0,jerk_accel_carro,x_max,vel_max_carro,a_max_carro,t,index);
[delta_v,delta_x,delta_t]=delta_velocidad(a(index),0,jerk_daccel_carro,1,0);
[x,v,a,index]=aceleracion_constante(x,v,a,x(index),v(index),a(index),0,x_max,vel_max_carro-delta_v,a_max_carro,t,index-1);
[x,v,a,index]=jerk_constante(x,v,a,x(index),v(index),a(index),jerk_daccel_carro,x_max,vel_max_carro,0,t,index-1);
[x,v,a,index]=velocidad_constante(x,v,a,x(index),v(index),a(index),0,x_max,vel_max_carro,0,t,index-1);
% --->Contemplar caso en el que x excede el objetivo final
index_xmax=find(x>=x_max);
tiempo_total_x=t(index_xmax(1));

%% Calculo de posicion, velocidad y aceleracion de izaje
ty=0:0.1:30;
y=linspace(0,0,301);
vy=linspace(0,0,301);
ay=linspace(0,0,301);
index=0;

% Aceleracion hasta velocidad maxima 
[y,vy,ay,index]=jerk_constante(y,vy,ay,y0,vy0,0,jerk_accel_izaje,h_max,vel_max_izaje,a_max_izaje,ty,index);
[delta_v,delta_y,delta_t]=delta_velocidad(ay(index),0,jerk_daccel_izaje,1,0);
[y,vy,ay,index]=aceleracion_constante(y,vy,ay,y(index),vy(index),ay(index),0,h_max,vel_max_izaje-delta_v,a_max_izaje,ty,index-1);
[y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_daccel_izaje,h_max,vel_max_izaje,0,ty,index-1);
%Calculo de deltas para la desaceleracion desde velocidad maxima
[delta_v,delta_y,delta_t]=deaccel_izaje(vel_max_izaje,a_max_izaje,jerk_accel_izaje,jerk_daccel_izaje);
t_disp=tiempo_total_x-t(index)-delta_t;
[deltav,delta_y_velmax,delta_t]=delta_posicion(vel_max_izaje,t_disp);
y_disp=h_max-y(index)-delta_y-delta_y_velmax;
%condicion donde y_disp<0

if y_disp>0
    [delta_v,delta_y,delta_t]=deaccel_izaje(vel_max_izaje,a_max_izaje,jerk_accel_izaje,jerk_daccel_izaje);    
    t_disp=tiempo_total_x-delta_t;
    [deltav,delta_y_velmax,delta_t]=delta_posicion(vel_max_izaje,t_disp);
    y_disp=h_max-y(index)-delta_y-delta_y_velmax;
    % Tramo a velocidad constante con carro quieto
    [y,vy,ay,index]=velocidad_constante(y,vy,ay,y(index),vy(index),ay(index),0,y(index)+y_disp,vel_max_izaje,0,ty,index-1);
    index_x_inicio=index;
    % Tramo a velocidad constante con carro en movimiento
    [y,vy,ay,index]=velocidad_constante(y,vy,ay,y(index),vy(index),ay(index),0,y(index)+delta_y_velmax,vel_max_izaje,0,ty,index-1);
    % Tramo de desaceleracion a velocidad de izaje 0
    [y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_daccel_izaje,h_max,vel_max_izaje,-a_max_izaje,ty,index-1);
    [delta_v,delta_y,delta_t]=delta_velocidad(ay(index),0,jerk_accel_izaje,1,0);
    [y,vy,ay,index]=aceleracion_constante(y,vy,ay,y(index),vy(index),ay(index),0,h_max,0-delta_v,-a_max_izaje,ty,index-1);
    [y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_accel_izaje,h_max,vel_max_izaje,0,ty,index-1);
end

index_hmax=find(y>=h_max);

%% Conciliacion de indices y tiempos para x e y
xaux=x(1:index_xmax);
vaux=v(1:index_xmax);
aaux=a(1:index_xmax);
x(1:index_x_inicio)=xaux(1);
v(1:index_x_inicio)=0;
a(1:index_x_inicio)=0;

if index_x_inicio+index_xmax>index_hmax
x((index_x_inicio):index_hmax)=xaux;
v((index_x_inicio):index_hmax)=vaux;
a((index_x_inicio):index_hmax)=aaux;
else
x((index_x_inicio+1):index_hmax)=xaux;
v((index_x_inicio+1):index_hmax)=vaux;
a((index_x_inicio+1):index_hmax)=aaux;    
end

end