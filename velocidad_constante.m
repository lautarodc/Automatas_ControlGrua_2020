function [x,v,a,t]=velocidad_constante(x0,v0,xmax,vmax,t)

for i=1:length(t)
    a(i)=0;
    v(i)=v0;
    x(i)=v0*t(i)+x0; 
end

end