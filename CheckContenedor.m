function existe = CheckContenedor(cont_x,cont_y,location)
%Funcion que verifica si ya hay un contenedor en la ubicación de entrada
[row,col]=ind2sub(size(location(:,:)),find(location(:,:)==[cont_x;cont_y]));
if length(col)==length(unique(col))
    existe=0;
else
    existe=1;
end
end

