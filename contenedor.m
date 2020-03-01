function [cont_x,cont_y]=contenedor(x,y,l_cont)
x1=x+l_cont/2;
y1=y+l_cont/2;
x=x-l_cont/2;
y=y-l_cont/2;
cont_x=[x x x1 x1];
cont_y=[y y1 y1 y];
end