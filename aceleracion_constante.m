function [x,v,a,t]=aceleracion_constante(x0,v0,a0,j,xmax,vmax,amax,t)

for i=1:length(t)
    a(i)=a0;
    v(i)=a0*t(i)+v0;
    x(i)=a0*(t(i)^2)*0.5+v0*t(i)+x0; 
end

end