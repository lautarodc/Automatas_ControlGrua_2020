function tiempo = TiempoDescenso(y_descenso,vel_max_izaje,a_max_izaje,jerk_accel_izaje,jerk_daccel_izaje)
%Calculo del tiempo total de descenso
%   Se tiene como argumento de entrada el desplazamiento total, y se cacula
%   mediante la velocidad máxima, aceleración máxima y jerk conocidos
%   el tiempo total del descenso para su posterior comparación con el 
%   tiempo disponible (obtenido de la trayectoria en x)

t_1=-a_max_izaje/jerk_daccel_izaje;
v_1=jerk_daccel_izaje*(1/2)*(t_1^2);
y_1=jerk_daccel_izaje*(1/6)*(t_1^3);

vel_max_izaje=VelocidadMaxima(vel_max_izaje,y_descenso,a_max_izaje,jerk_accel_izaje,jerk_daccel_izaje);
vel_max_izaje=real(vel_max_izaje);

v_2=vel_max_izaje-v_1;
t_2=(v_2-v_1)/-a_max_izaje;
y_2=-a_max_izaje*(1/2)*(t_2^2)+v_1*t_2;

t_3=(0-(-a_max_izaje))/jerk_accel_izaje;
y_3=jerk_accel_izaje*(1/6)*(t_3^3)+(-a_max_izaje)*(1/2)*(t_3^2)+v_2*t_3;

t_a=t_1+t_2+t_3;
y_a=y_1+y_2+y_3;

y_b=y_descenso-2*y_a;
t_b=y_b/vel_max_izaje;
tiempo=t_b+2*t_a;

end

