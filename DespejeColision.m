function indice_ok=DespejeColision(h_max,xnuevo,ynuevo,xc_indice,yc_indice,indice_ant,indice_sig,indice)
% Calculo del tramo lineal entre el punto indicado por el indice y el
% objetivo
y_tramo=ynuevo(indice:yc_indice);
m=(ynuevo(yc_indice)-ynuevo(indice))/(xnuevo(xc_indice)-xnuevo(indice));
b=h_max;
a=xnuevo(indice);
% y_despeje=zeros(length(y_tramo));
for i=indice:xc_indice
    y_despeje(i+1-indice)=m*(xnuevo(i)-a)+b;
end
% Verificacion de colisiones
y_aux=y_despeje-y_tramo;
colisiones=find(y_aux<0);
if any(colisiones)
    colision=1;
else
    colision=0;
end

% Casos dependiendo de la colision y del sentido de la trayectoria
if xnuevo(xc_indice)>xnuevo(indice)
    if colision
        indice_aux=round((indice_sig+indice)/2);
        %         indice_sig=indice_sig;
        indice_ant=indice;
        indice=indice_aux;
        indice_ok=DespejeColision(h_max,xnuevo,ynuevo,xc_indice,yc_indice,indice_ant,indice_sig,indice);
    else
        indice_aux=round((indice_ant+indice)/2);
        if indice_aux==indice
            indice_ok=indice;
        else
            %             indice_ant=indice_ant;
            indice_sig=indice;
            indice=indice_aux;
            indice_ok=DespejeColision(h_max,xnuevo,ynuevo,xc_indice,yc_indice,indice_ant,indice_sig,indice);
        end
    end
elseif xnuevo(xc_indice)<xnuevo(indice)
    if colision
        indice_aux=round((indice_ant+indice)/2);
        %         indice_ant=indice_ant;
        indice_sig=indice;
        indice=indice_aux;
        indice_ok=DespejeColision(h_max,xnuevo,ynuevo,xc_indice,yc_indice,indice_ant,indice_sig,indice);
    else
        indice_aux=round((indice_sig+indice)/2);
        if indice_aux==indice
            indice_ok=indice;
        else
            %             indice_sig=indice_sig;
            indice_ant=indice;
            indice=indice_aux;
            indice_ok=DespejeColision(h_max,xnuevo,ynuevo,xc_indice,yc_indice,indice_ant,indice_sig,indice);
        end
    end
else
    indice_ok=indice;
end