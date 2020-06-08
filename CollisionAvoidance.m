function indice_ok=CollisionAvoidance(h_max,xnuevo,ynuevo,xc_indice,yc_indice,indice_ant,indice_sig,indice)
% Calculo del tramo lineal entre el punto indicado por el indice y el
% objetivo

while (1)
    y_despeje=0;
    
    if yc_indice>=indice
        y_tramo=ynuevo(indice:yc_indice);
    else
        y_tramo=ynuevo(yc_indice:indice);
    end
    m=(ynuevo(yc_indice)-ynuevo(indice))/(xnuevo(xc_indice)-xnuevo(indice));
    b=h_max;
    a=xnuevo(indice);
    
    if xc_indice>=indice
        for i=indice:xc_indice
            y_despeje(i+1-indice)=m*(xnuevo(i)-a)+b;
        end
    else
        for i=xc_indice:indice
            y_despeje(i+1-xc_indice)=m*(xnuevo(i)-a)+b;
        end
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
            indice_ant=indice;
            indice=indice_aux;
        else
            indice_aux=round((indice_ant+indice)/2);
            if indice_aux==indice
                indice_ok=indice;
                break;
            else
                indice_sig=indice;
                indice=indice_aux;
            end
        end
    elseif xnuevo(xc_indice)<xnuevo(indice)
        if colision
            indice_aux=round((indice_sig+indice)/2);
            indice=indice_aux;
            indice_ant=indice;
        else
            indice_aux=round((indice_ant+indice)/2);
            if indice_aux==indice
                indice_ok=indice;
                break;
            else
                indice_sig=indice;
                indice=indice_aux;
            end
        end
    else
        indice_ok=indice;
        break;
    end
end
end