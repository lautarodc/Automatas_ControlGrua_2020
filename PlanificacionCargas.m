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
ocupacion=floor(0.5*capacidad_Total);
%Creacion de contenedor en muelle
[cont_x,cont_y]=contenedor(lim_xi+(lim_xd-lim_xi)*rand(),1.25,l_cont);
plot(cont_x,cont_y,'k-')
location=zeros(2,ocupacion);
i=1;
while (i<=ocupacion)
    cont_x=randi([1 capacidad_lateral]);
    cont_y=randi([1 capacidad_vertical]);
    if cont_y==1
        ind_y=0;
    else
        ind_y=cont_y-1;
    end
    if(ind_y==0 && CheckContenedor(cont_x,cont_y,location)==0)
        location(:,i)=[cont_x;cont_y];
        [cont_x,cont_y]=contenedor(5+(cont_x-1)*l_cont+l_cont/2,-20+cont_y*l_cont/2,l_cont);
        plot(cont_x,cont_y,'m-')
        i=i+1;
    elseif(ind_y~=0 && CheckContenedor(cont_x,cont_y,location)==0 && CheckContenedor(cont_x,ind_y,location)==1)
        location(:,i)=[cont_x;cont_y];
        [cont_x,cont_y]=contenedor(5+(cont_x-1)*l_cont+l_cont/2,-20+(cont_y-1)*l_cont+l_cont/2,l_cont);
        plot(cont_x,cont_y,'m-')
        i=i+1;
    else
    end
    
end
%% Graficar
plot(base_x,base_y,'k-',barco_x,barco_y,'g-',mar_x1,mar_y1,'b-',mar_x2,mar_y2,'b-',carro_x,carro_y,'k-');
axis([-30 60 -30 50],'equal')
