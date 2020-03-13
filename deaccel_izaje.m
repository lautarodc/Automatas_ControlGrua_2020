function [delta_v,delta_x,delta_t]=deaccel_izaje(vmax,amax,jerk_accel_izaje,jerk_daccel_izaje)


t0_dacc_izaje=(-amax-0)/jerk_daccel_izaje;
v0_izaje=0.5*jerk_daccel_izaje*(t0_dacc_izaje^2)+vmax;
y0_dacc_izaje=(1/6)*jerk_daccel_izaje*(t0_dacc_izaje^3)+vmax*t0_dacc_izaje;
  
vizaje_aux=-(0.5*jerk_accel_izaje*(((0-(-amax))/(jerk_accel_izaje))^2)+(-amax)*((0-(-amax))/(jerk_accel_izaje))); 
t1_dacc_izaje=(vizaje_aux-v0_izaje)/-amax;
v1_dacc_izaje=vizaje_aux;
y1_dacc_izaje=(-amax)*0.5*(t1_dacc_izaje^2)+v0_izaje*t1_dacc_izaje;

a2_dacc_izaje=0;
t2_dacc_izaje=(a2_dacc_izaje-(-amax))/jerk_accel_izaje;
v2_dacc_izaje=0.5*jerk_accel_izaje*(t2_dacc_izaje^2)+(-amax)*t2_dacc_izaje+v1_dacc_izaje;
y2_dacc_izaje=(1/6)*jerk_accel_izaje*(t2_dacc_izaje^3)+(-amax)*0.5*(t2_dacc_izaje^2)+v1_dacc_izaje*t2_dacc_izaje;

delta_v=v2_dacc_izaje-vmax;
delta_x=y0_dacc_izaje+y1_dacc_izaje+y2_dacc_izaje;
delta_t=t0_dacc_izaje+t1_dacc_izaje+t2_dacc_izaje;

end