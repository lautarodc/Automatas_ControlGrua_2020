function [x_out,v_out,a_out,index_out]=aceleracion_constante(x_in,v_in,a_in,x0,v0,a0,j,xmax,vmax,amax,t,index_in)

i=index_in+1;

x_out=x_in;
v_out=v_in;
a_out=a_in;

while 1
    a_out(1,i)=a0;
    v_out(1,i)=a0*t(1,i-index_in)+v0;
    x_out(1,i)=a0*(t(1,i-index_in)^2)*0.5+v0*t(1,i-index_in)+x0;
    if v_out(1,i)>=vmax
        break;
    end
    i=i+1;
end
index_out=i;

end