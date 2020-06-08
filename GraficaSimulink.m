function M = GraficaSimulink(grafica_xl,grafica_yl,grafica_envolvente,grafica_xt)
%GRAFICASIMULINK Summary of this function goes here
%   Detailed explanation goes here
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
% plot(base_x,base_y,'k-',barco_x,barco_y,'g-',mar_x1,mar_y1,'b-',mar_x2,mar_y2,'b-',carro_x,carro_y,'k-');
% axis([-30 60 -30 50],'equal')
ind_muelle=((30+0)/0.5)+1;
ind_barco=((30+5)/0.5)+1;
% hold on
% stairs(grafica_envolvente(1,(1:ind_muelle)),grafica_envolvente(2,(1:ind_muelle)),'k-')
% for i=ind_barco:5:length(grafica_envolvente(1,:))-1
%     cant_col=(grafica_envolvente(2,i)-(-20))/2.5;
%     if cant_col~=0
%         for j=1:cant_col
%             [cont_x,cont_y]=contenedor(grafica_envolvente(1,i)+1.25,-20+2.5*(j-1)+1.25,2.5);
%             plot(cont_x,cont_y,'m-')
%         end
%     end
% end
for i=1:length(grafica_xl(1,:))
    plot(base_x,base_y,'k-',barco_x,barco_y,'g-',mar_x1,mar_y1,'b-',mar_x2,mar_y2,'b-',carro_x,carro_y,'k-');
    axis([-30 60 -30 50],'equal')
    hold on
    stairs(grafica_envolvente(1,(1:ind_muelle)),grafica_envolvente(2,(1:ind_muelle)),'k-')
    for k=ind_barco:5:length(grafica_envolvente(1,:))-1
        cant_col=(grafica_envolvente(2,k)-(-20))/2.5;
        if cant_col~=0
            for j=1:cant_col
                [cont_x,cont_y]=contenedor(grafica_envolvente(1,k)+1.25,-20+2.5*(j-1)+1.25,2.5);
                plot(cont_x,cont_y,'m-')
            end
        end
    end
    plot([grafica_xt(i) grafica_xl(i)],[45 grafica_yl(i)],'k-');
    plot(grafica_xl(i),grafica_yl(i))
    M(i)=getframe(gcf);
end
% v = VideoWriter('Automatas.avi');
% open(v)
% writeVideo(v,M);
% plot([grafica_xt grafica_xl],[grafica_yt0 grafica_yl],'k-');
% plot([(grafica_xt-2) (grafica_xt-2) (grafica_xt+2) (grafica_xt+2)],[grafica_yt0 grafica_yt1 grafica_yt1 grafica_yt0],'k-');

end

