figure
hold on
clc;
clear all;
%% Parametros l�mite contenedores y escenario
l_cont=2.5;
lim_xi=-30+l_cont/2;
lim_xd=0-l_cont/2;
ml_min=2000;
ml_max=50000;
base_x=[-38 0 0];
base_y=[0 0 -30];
barco_x=[5 5 50 50];
barco_y=[15 -20 -20 15];
mar_x1=[0 5];
mar_y1=[-5 -5];
mar_x2=[50 68];
mar_y2=[-5 -5];
carro_x=[-38 68];
carro_y=[45 45];
capacidad_lateral=((barco_x(1,3)-barco_x(1,2))/l_cont);
capacidad_vertical=((25-barco_y(1,2))/l_cont);
%% Escenario aleatorio de contenedores en muelle y barco
capacidad_Total=capacidad_lateral*capacidad_vertical;
ocupacion=floor(0.7*capacidad_Total);
%Creacion de contenedor en muelle
% [cont_x,cont_y]=contenedor(lim_xi+(lim_xd-lim_xi)*rand(),1.25,l_cont);
xo=-10;
cont_muelle_x=xo+l_cont/2;
[cont_x,cont_y]=contenedor(cont_muelle_x,1.25,l_cont);
cont_muelle_x=(30+(cont_muelle_x-1.25))/0.5;
cont_muelle_y=l_cont;
plot(cont_x,cont_y,'k-')
location=zeros(3,ocupacion);
i=1;
while (i<=ocupacion)
    cont_x=randi([1 capacidad_lateral]);
    cont_y=randi([1 capacidad_vertical]);
    cont_masa=ml_min+(ml_max-ml_min)*rand();
    if cont_y==1
        ind_y=0;
    else
        ind_y=cont_y-1;
    end
    if(ind_y==0 && CheckContenedor(cont_x,cont_y,location(1:2,:))==0)
        location(:,i)=[cont_x;cont_y;cont_masa];
        [cont_x,cont_y]=contenedor(5+(cont_x-1)*l_cont+l_cont/2,-20+cont_y*l_cont/2,l_cont);
        plot(cont_x,cont_y,'m-')
        i=i+1;
    elseif(ind_y~=0 && CheckContenedor(cont_x,cont_y,location(1:2,:))==0 && CheckContenedor(cont_x,ind_y,location(1:2,:))==1)
        location(:,i)=[cont_x;cont_y;cont_masa];
        [cont_x,cont_y]=contenedor(5+(cont_x-1)*l_cont+l_cont/2,-20+(cont_y-1)*l_cont+l_cont/2,l_cont);
        plot(cont_x,cont_y,'m-')
        i=i+1;
    else
    end
    
end
%% Graficar
plot(base_x,base_y,'k-',barco_x,barco_y,'g-',mar_x1,mar_y1,'b-',mar_x2,mar_y2,'b-',carro_x,carro_y,'k-');
axis([-30 60 -30 50],'equal')
[temp, order] = sort(location(1,:));
contenedores_ordenados = location(:,order);
barco_contenedores=zeros(18,18);
length(contenedores_ordenados);
for i=1:length(contenedores_ordenados)
    barco_contenedores(contenedores_ordenados(1,i),contenedores_ordenados(2,i))=contenedores_ordenados(3,i);
end
barco_contenedores=barco_contenedores';
barcos_envolvente=zeros(1,18);
for j=1:length(barco_contenedores)
    temp=find(barco_contenedores(:,j)==0);
    if(temp~=0)
        barcos_envolvente(1,j)=temp(1)-1;
    else
        barcos_envolvente(1,j)=18;
    end
end
envolvente=zeros(1,90);
for i=1:length(barcos_envolvente)
    for j=1:6
        envolvente(1,(i-1)*5+j)=barcos_envolvente(i).*2.5-20;
    end
end
x=linspace(-30,50,161);
y=zeros(1,161);
for i=1:67
    y(i)=0;
end
for i=68:70
    y(i)=15;
end

for i=71:length(y)
    y(i)=envolvente(i-70);
end
for i=1:5
    y(cont_muelle_x+i)=cont_muelle_y;
end

stairs(x,y,'r')
xnuevo=x;
ynuevo=y;

for i=71:5:length(x)
    if i==71
        if ((y(i-1)-y(i))>2.5 || (y(i+5)-y(i))>2.5)
            aux=max(y(i-1),y(i+5));
            for j=0:4
                ynuevo(i+j)=aux;
            end
        end
        
    else
        
        if i~=length(x) && (y(i-5)-y(i)>2.5 || y(i+5)-y(i)>2.5)
            aux=max(y(i-5),y(i+5));
            for j=0:4
                ynuevo(i+j)=aux;
            end
        else
            if i~=length(x)
                for j=0:4
                    ynuevo(i+j)=y(i);
                end
            else
                ynuevo(i)=y(i);
            end
        end
    end
end
for i=71:length(xnuevo)
    ynuevo(i)=ynuevo(i)+2.5;
end
stairs(x,ynuevo,'b')

%% Generador de trayectoria
columna_consigna=4; %Columna de consigna a elegir
xc=5+2.5*columna_consigna;
index_columna=((30+xc)/0.5)+1;
index_contenedor=((30+xo)/0.5)+1;
h_max=max(ynuevo(index_contenedor:(index_columna-1)));
i=1;
while(ynuevo(i)~=h_max)
    i=i+1;
end
x_max=x(i)+1.25;
vel_max_izaje=2;
vel_max_carro=4;
a_max_izaje=1;
a_max_carro=1;
jerk_izaje=1;
jerk_carro=1;
v_inicial_izaje=0.1;
v_inicial_carro=0;
a_inicial_carro=0;
a_inicial_izaje=0;
%% Calculo de x del carro hasta su velocidad maxima

% Calculo de tiempo, desplazamiento y velocidad para alcanzar la
% aceleraci�n m�xima del carro
t0_carro=a_max_carro/jerk_carro;
a0_carro=a_max_carro;
v0_carro=v_inicial_carro+jerk_carro*0.5*(t0_carro^2);
p0_carro=v_inicial_carro*t0_carro+a_inicial_carro*0.5*(t0_carro^2)+jerk_carro*(1/6)*(t0_carro^3);
% Calculo de tiempo y desplazamiento para alcanzar la velocidad m�xima del
% carro: jerk_carro=0;
jerk_carro=-1;
v1_carro=vel_max_carro-(jerk_carro*0.5*(((0-a0_carro)/jerk_carro)^2)+a0_carro*((0-a0_carro)/jerk_carro));
t1_carro=(v1_carro-v0_carro)/a0_carro;
p1_carro=p0_carro+v0_carro*t1_carro+a0_carro*0.5*(t1_carro^2);
% Calculo de desaceleracion a aceleracion 0 para velocidad maxima del carro
a2_carro=0;
t2_carro=(a2_carro-a0_carro)/jerk_carro;
v2_carro=v1_carro+jerk_carro*0.5*(t2_carro^2)+a0_carro*t2_carro;
p2_carro=p1_carro+v1_carro*t2_carro+a0_carro*0.5*(t2_carro^2)+jerk_carro*(1/6)*(t2_carro^3);

% Perfil de posicion, velocidad y aceleracion del carro hasta el obst�culo m�ximo. 
t=0:0.1:30;
x=linspace(0,0,301);
v=linspace(0,0,301);
a=linspace(0,0,301);
index=0;
jerk_accel_carro=1;
jerk_daccel_carro=-1;
[x,v,a,index]=jerk_constante(x,v,a,xo+l_cont/2,0,0,jerk_accel_carro,x_max,vel_max_carro,a_max_carro,t,index);
[delta_v,delta_x,delta_t]=delta_velocidad(a(index),0,jerk_daccel_carro,1,0);
[x,v,a,index]=aceleracion_constante(x,v,a,x(index),v(index),a(index),0,x_max,vel_max_carro-delta_v,a_max_carro,t,index-1);
[x,v,a,index]=jerk_constante(x,v,a,x(index),v(index),a(index),jerk_daccel_carro,x_max,vel_max_carro,0,t,index-1);
[x,v,a,index]=velocidad_constante(x,v,a,x(index),v(index),a(index),0,x_max,vel_max_carro,0,t,index-1);
% --->Contemplar caso en el que x excede el objetivo final
index_xmax=find(x>=x_max);
tiempo_total_x=t(index_xmax(1));

%% Aceleracion Izaje a velocidad m�xima
v0_izaje=0.1; %Depende de la velocidad manual final del operador
a0_acc_izaje=0; %Se debe contemplar una aceleraci�n inicial para el movimiento manual pero luego dejarlo a aceleraci�n 0;
y0_izaje=2.5; %Donde se cambia la envolvente a autom�tico;
jerk_izaje=1;
a_acc_izaje=1;
%Tramo aceleraci�n con jerk finito y aceleracion variable
t0_acc_izaje=(a_acc_izaje-a0_acc_izaje)/jerk_izaje;
v0_acc_izaje=0.5*jerk_izaje*(t0_acc_izaje^2)+a0_acc_izaje*t0_acc_izaje+v0_izaje;
y0_acc_izaje=(1/6)*jerk_izaje*(t0_acc_izaje^3)+a0_acc_izaje*(t0_acc_izaje^2)+v0_izaje*t0_acc_izaje+y0_izaje;
v_aux=v0_acc_izaje-v0_izaje;
%Tramo aceleracion constante hasta velocidad de desaceleraci�n
v1_acc_izaje=vel_max_izaje-v_aux;
t1_acc_izaje=(v1_acc_izaje-v0_acc_izaje)/a_acc_izaje;
y1_acc_izaje=0.5*a_acc_izaje*(t1_acc_izaje^2)+v0_acc_izaje*t1_acc_izaje+y0_acc_izaje;
%Tramo de desaceleraci�n y velocidad a velocidad m�xima
jerk_izaje=-1;
a2_acc_izaje=0;
t2_acc_izaje=(a2_acc_izaje-a_acc_izaje)/jerk_izaje;
v2_acc_izaje=0.5*jerk_izaje*(t2_acc_izaje^2)+a_acc_izaje*t2_acc_izaje+v1_acc_izaje;
y2_acc_izaje=(1/6)*jerk_izaje*(t2_acc_izaje^3)+a_acc_izaje*(t2_acc_izaje^2)+v1_acc_izaje*t2_acc_izaje+y1_acc_izaje;
disp('Velocidad luego de aceleracion y desaceleracion: ');
disp(v2_acc_izaje);
%% Desaceleracion Izaje a velocidad m�xima
v0_dacc_izaje=vel_max_izaje;
jerk_izaje=-1;
a0_dacc_izaje=0;
a_dacc_izaje=-1;
t0_dacc_izaje=(a_dacc_izaje-a0_dacc_izaje)/jerk_izaje;
v0_izaje=0.5*jerk_izaje*(t0_dacc_izaje^2)+v0_dacc_izaje;
y0_dacc_izaje=(1/6)*jerk_izaje*(t0_dacc_izaje^3)+v0_dacc_izaje*t0_dacc_izaje;
 
jerk_izaje=1;
vizaje_aux=-(0.5*jerk_izaje*(((0-a_dacc_izaje)/(jerk_izaje))^2)+a_dacc_izaje*((0-a_dacc_izaje)/(jerk_izaje))); %se debe calcular en funcion del jerk
t1_dacc_izaje=(vizaje_aux-v0_izaje)/a_dacc_izaje;
v1_dacc_izaje=vizaje_aux;
y1_dacc_izaje=a_dacc_izaje*0.5*(t1_dacc_izaje^2)+v0_izaje*t1_dacc_izaje;

jerk_izaje=1;
a2_dacc_izaje=0;
t2_dacc_izaje=(a2_dacc_izaje-a_dacc_izaje)/jerk_izaje;
v2_dacc_izaje=0.5*jerk_izaje*(t2_dacc_izaje^2)+a_dacc_izaje*t2_dacc_izaje+v1_dacc_izaje;
y2_dacc_izaje=(1/6)*jerk_izaje*(t2_dacc_izaje^3)+a_dacc_izaje*0.5*(t2_dacc_izaje^2)+v1_dacc_izaje*t2_dacc_izaje;
disp(v2_dacc_izaje);

%% Perfil de posicion, velocidad y aceleracion de izaje hasta el obst�culo m�ximo. 
ty=0:0.1:30;
y=linspace(0,0,301);
vy=linspace(0,0,301);
ay=linspace(0,0,301);
index=0;

v0_izaje=0.1; %Depende de la velocidad manual final del operador
y0_izaje=2.5; %Donde se cambia la envolvente a autom�tico;

jerk_accel_izaje=1;
jerk_daccel_izaje=-1;

% Aceleracion hasta velocidad maxima 
[y,vy,ay,index]=jerk_constante(y,vy,ay,y0_izaje,v0_izaje,0,jerk_accel_izaje,h_max,vel_max_izaje,a_max_izaje,ty,index);
[delta_v,delta_y,delta_t]=delta_velocidad(ay(index),0,jerk_daccel_izaje,1,0);
[y,vy,ay,index]=aceleracion_constante(y,vy,ay,y(index),vy(index),ay(index),0,h_max,vel_max_izaje-delta_v,a_max_izaje,ty,index-1);
[y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_daccel_izaje,h_max,vel_max_izaje,0,ty,index-1);
t0=ty(index);
y0=y(index);
%Calculo de deltas para la desaceleracion desde velocidad maxima
[delta_v,delta_y,delta_t]=deaccel_izaje(vel_max_izaje,a_max_izaje,jerk_accel_izaje,jerk_daccel_izaje);
t_disp=tiempo_total_x-t(index)-delta_t;
[deltav,delta_y_velmax,delta_t]=delta_posicion(vel_max_izaje,t_disp);
y_disp=h_max-y(index)-delta_y-delta_y_velmax;
%condicion donde y_disp<0

if y_disp>0
    disp('Entre')
    % Calculo de deltas de velocidad, posicion y tiempo para el caso de una
    % desaceleracion
    [delta_v,delta_y,delta_t]=deaccel_izaje(vel_max_izaje,a_max_izaje,jerk_accel_izaje,jerk_daccel_izaje);    
    disp('delta y')
    delta_y
    t1=delta_t;
    t_disp=tiempo_total_x-delta_t;
    [deltav,delta_y_velmax,delta_t]=delta_posicion(vel_max_izaje,t_disp);
    t2=delta_t;
    y_disp=h_max-y(index)-delta_y-delta_y_velmax;
    disp('y(index)')
    y(index)
    % Tramo a velocidad constante con carro quieto
    [y,vy,ay,index]=velocidad_constante(y,vy,ay,y(index),vy(index),ay(index),0,y(index)+y_disp,vel_max_izaje,0,ty,index-1);
    index_x_inicio=index;
    t3=ty(index)-t0;
    y3=y(index)-y0;
    % Tramo a velocidad constante con carro en movimiento
    [y,vy,ay,index]=velocidad_constante(y,vy,ay,y(index),vy(index),ay(index),0,y(index)+delta_y_velmax,vel_max_izaje,0,ty,index-1);
    t2_ver=ty(index)-t3;
    y2_ver=y(index)-(y3+y0);
    % Tramo de desaceleracion a velocidad de izaje 0
    [y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_daccel_izaje,h_max,vel_max_izaje,-a_max_izaje,ty,index-1);
    [delta_v,delta_y,delta_t]=delta_velocidad(ay(index),0,jerk_accel_izaje,1,0);
    [y,vy,ay,index]=aceleracion_constante(y,vy,ay,y(index),vy(index),ay(index),0,h_max,0-delta_v,-a_max_izaje,ty,index-1);
    [y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_accel_izaje,h_max,vel_max_izaje,0,ty,index-1);
    t1_ver=ty(index)-t2_ver;
    y1_ver=y(index)-(y2_ver+y3+y0);
end

index_hmax=find(y>=h_max);

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

plot(x(1:index_hmax),y(1:index_hmax),'-b')

% plot(x_recta,y_recta,'g');
% plot(x_t,y_t,'r')
