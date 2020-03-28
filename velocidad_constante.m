function [x_out,v_out,a_out,index_out]=velocidad_constante(x_in,v_in,a_in,x0,v0,a0,j,xmax,vmax,amax,t,index_in)

i=index_in+1;

x_out=x_in;
v_out=v_in;
a_out=a_in;

while 1
    a_out(1,i)=0;
    v_out(1,i)=v0;
    x_out(1,i)=v0*t(1,i-index_in)+x0;
    if xmax>x0
        if x_out(1,i)>=xmax
            break;
        end
    elseif xmax<x0
        if x_out(1,i)<=xmax
            break;
        end
    end
    i=i+1;
end
index_out=i;

% if x_out(1,index_out)~=xmax
%     index_out=index_out-1;
%     x_out(1,index_out)=xmax;
% end

end