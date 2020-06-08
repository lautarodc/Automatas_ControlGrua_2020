clc;
clear all;
close all;
figure
hold on
%% Parametros límite contenedores y escenario
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
ocupacion=floor(0.3*capacidad_Total);
%Creacion de contenedor en muelle
xo=-20;
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
columna_consigna=12; %Columna de consigna a elegir
xc=5+2.5*columna_consigna;
xobj=xc-1.25;
% xobj=6.25;
cargado=1;
%Parametros cinematicos de diseño
vel_max_izaje=2;
vel_max_carro=4;
a_max_carro=1;
a_max_izaje=1;
jerk_accel_carro=1;
jerk_accel_izaje=1;
jerk_daccel_carro=-1;
jerk_daccel_izaje=-1;
%Parametros que dependen de la ubicacion y el operador
y0=2.5;
vy0=0.2;
a0=0.1;
x0=-18.75;
% y0=ynuevo(round(((30+x0)/0.5)+1));
vx0=0;
ax0=0;
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

[vel_max_carro,~]=VelMaxima(vel_max_carro,x_disp,a_max_carro,jerk_accel_carro,jerk_daccel_carro,ax0,vx0);

if vel_max_carro<0
    
    j1x=jerk_daccel_carro;
    a1x=-a_max_carro;
    j2x=jerk_accel_carro;
    j3x=jerk_accel_carro;
    a3x=a_max_carro;
    j4x=jerk_daccel_carro; 
    
else
    
    j1x=jerk_accel_carro;
    a1x=a_max_carro;
    j2x=jerk_daccel_carro;
    j3x=jerk_daccel_carro;
    a3x=-a_max_carro;
    j4x=jerk_accel_carro;
    
end

[x,v,a,index]=jerk_constante(x,v,a,x0,vx0,ax0,j1x,x_max,vel_max_carro,a1x,t,index-1);
[delta_v,delta_x,delta_t]=delta_velocidad(a(index),0,j2x,1,0);
[x,v,a,index]=aceleracion_constante(x,v,a,x(index),v(index),a(index),0,x_max,vel_max_carro-delta_v,a1x,t,index-1);
[x,v,a,index]=jerk_constante(x,v,a,x(index),v(index),a(index),j2x,x_max,vel_max_carro,0,t,index-1);

delta_x=x(index)-x0;

[x,v,a,index]=velocidad_constante(x,v,a,x(index),v(index),a(index),0,xobj-delta_x,vel_max_carro,0,t,index-1);

[x,v,a,index]=jerk_constante(x,v,a,x(index),v(index),a(index),j3x,x_max,vel_max_carro,a3x,t,index-1);
[delta_v,delta_x,delta_t]=delta_velocidad(a3x,0,j4x,1,0);
[x,v,a,index]=aceleracion_constante(x,v,a,x(index),v(index),a(index),0,x_max,0-delta_v,a3x,t,index-1);
[x,v,a,index]=jerk_constante(x,v,a,x(index),v(index),a(index),j4x,x_max,vel_max_carro,0,t,index-1);

if abs(xobj-x(index))<0.01
    x(index)=xobj;
end

for i=index:length(x)
    x(i)=x(index);
end

if x_disp>=0
    index_xmax=find(x>=x_max);
    tiempo_total_x=t(index_xmax(1));
    index_x_final=find(x>=xobj);
else
    index_xmax=find(x<=x_max);
    tiempo_total_x=t(index_xmax(1));
    index_x_final=find(x<=xobj);    
end

%% Calculo de posicion, velocidad y aceleracion de izaje
ty=0:0.001:50;
y=linspace(0,0,50001);
vy=linspace(0,0,50001);
ay=linspace(0,0,50001);
index=1;

if abs(h_max-y0<0.25)
   h_max=h_max+1; 
end

cond=1;
a_max_izaje_1=a_max_izaje;
while (cond)
    [vel_max_izaje_1,vel_accel]=VelMaxima(vel_max_izaje,h_max-y0,a_max_izaje_1,jerk_accel_izaje,jerk_daccel_izaje,a0,vy0);
    if vel_max_izaje_1>vel_accel
       cond=0; 
       break;
    end
    a_max_izaje_1=a_max_izaje_1-0.01;
end

% Aceleracion hasta velocidad maxima
[y,vy,ay,index]=jerk_constante(y,vy,ay,y0,vy0,a0,jerk_accel_izaje,h_max,vel_max_izaje_1,a_max_izaje_1,ty,index-1);
[delta_v,delta_y,delta_t]=delta_velocidad(ay(index),0,jerk_daccel_izaje,1,0);
[y,vy,ay,index]=aceleracion_constante(y,vy,ay,y(index),vy(index),ay(index),0,h_max,vel_max_izaje_1-delta_v,a_max_izaje_1,ty,index-1);
[y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_daccel_izaje,h_max,vel_max_izaje_1,0,ty,index-1);

%Calculo de deltas para la desaceleracion desde velocidad maxima
[delta_v,delta_y,delta_t]=deaccel_izaje(vel_max_izaje_1,a_max_izaje_1,jerk_accel_izaje,jerk_daccel_izaje);
y_velmax=h_max-y(index)-delta_y;

% Tramo a velocidad constante
[y,vy,ay,index]=velocidad_constante(y,vy,ay,y(index),vy(index),ay(index),0,y(index)+y_velmax,vel_max_izaje_1,0,ty,index-1);

% Tramo de desaceleracion a velocidad de izaje 0
[y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_daccel_izaje,h_max,vel_max_izaje_1,-a_max_izaje_1,ty,index-1);
[delta_v,delta_y,delta_t]=delta_velocidad(ay(index),0,jerk_accel_izaje,1,0);
[y,vy,ay,index]=aceleracion_constante(y,vy,ay,y(index),vy(index),ay(index),0,h_max,0-delta_v,-a_max_izaje_1,ty,index-1);
[y,vy,ay,index]=jerk_constante(y,vy,ay,y(index),vy(index),ay(index),jerk_accel_izaje,h_max,vel_max_izaje_1,0,ty,index-1);

% index_hmax=find(y>=h_max);
index_x_inicio=index-index_xmax(1);

%% Conciliacion de indices y tiempos para x e y
if index_x_inicio>0
    
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
    
end

%% Evaluacion de colisiones para el calculo del punto de inicio de descenso de izaje
indice_ant=round(((30+x_max)/0.5)+1);
indice=round(((30+x_max)/0.5)+1);
indice_sig=round(((30+xobj)/0.5)+1);
if indice_ant~=indice_sig
    indice_prueba=CollisionAvoidance(h_max,xnuevo,ynuevo,indice_sig,indice_sig,indice_ant,indice_sig,indice);
    indice_ok=DespejeColision(h_max,xnuevo,ynuevo,indice_sig,indice_sig,indice_ant,indice_sig,indice);
    m=(ynuevo(indice_sig)-ynuevo(indice_ok))/(xnuevo(indice_sig)-xnuevo(indice_ok));
    
    if m==0 && xnuevo(indice_ok)>0
        x_descenso=xobj;
    else
        x_descenso=xnuevo(indice_ok);
    end
    
    if x_descenso>0
        index_xdescenso=find(x>=x_descenso);
        index_x_final=find(x>=xobj);
    else
        index_xdescenso=find(x<=x_descenso);
        index_x_final=find(x<=xobj);
    end
    
    y_descenso=yobj-y(index);
    
    tiempo_izaje=TiempoDescenso(y_descenso,vel_max_izaje,a_max_izaje,jerk_accel_izaje,jerk_daccel_izaje);
    
    tiempo_final=ty(index_x_final(1));
    tiempo_colision=ty(index_xdescenso(1));
    
    if (tiempo_final-tiempo_colision)>tiempo_izaje
       tiempo_auxiliar=tiempo_final-tiempo_izaje;
       index_xdescenso=find(ty>=tiempo_auxiliar);
    end
    
    
    for i=index:index_xdescenso(1)
        y(i)=y(index);
        vy(i)=vy(index);
        ay(i)=ay(index);
    end
    index=index_xdescenso(1);

end

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
if index_x_final(1)>index
    index_hmax=index_x_final(1);
    y(index:index_x_final(1))=y(index);
else
    index_hmax=index;
end

plot(x(1:index_hmax),y(1:index_hmax),'-b')

figure(3)

subplot(3,1,1)
plot(t(1:index_hmax),y(1:index_hmax),'-g')
title('Posición de Izaje')

subplot(3,1,2)
plot(t(1:index_hmax),vy(1:index_hmax),'-r')
title('Velocidad de Izaje')

subplot(3,1,3)
plot(t(1:index_hmax),ay(1:index_hmax),'-r')
title('Aceleracion de Izaje')

figure(4)

subplot(3,1,1)
plot(t(1:index_hmax),x(1:index_hmax),'-g')
title('Posición del Carro')

subplot(3,1,2)
plot(t(1:index_hmax),v(1:index_hmax),'-r')
title('Velocidad del Carro')

subplot(3,1,3)
plot(t(1:index_hmax),a(1:index_hmax),'-r')
title('Aceleracion del Carro')
