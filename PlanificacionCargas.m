figure
hold on
clc;
clear all;
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
ocupacion=floor(0.5*capacidad_Total);
%Creacion de contenedor en muelle
% [cont_x,cont_y]=contenedor(lim_xi+(lim_xd-lim_xi)*rand(),1.25,l_cont);
cont_muelle_x=-30+0.5*randi(50)+l_cont/2;
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
length(contenedores_ordenados)
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
% ynuevo=spline(x,ynuevo,x);
stairs(x,ynuevo,'b')

% plot(x,ynuevo,'b')