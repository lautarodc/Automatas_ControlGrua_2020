function [delta_v,delta_x,delta_t]=delta_velocidad(a0,af,j,opcion,v0)
delta_t=(af-a0)/j;
delta_v=j*(delta_t^2)*0.5+a0*delta_t;
if opcion==2
    delta_x=j*(delta_t^3)*(1/6)+a0*(delta_t^2)*0.5+v0*delta_t;
elseif opcion==1
    delta_x=0;
end
end