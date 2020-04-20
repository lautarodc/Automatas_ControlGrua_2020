function velmax_out = VelocidadMaxima(velmax_in,xdisp,amax,jerkaccel,jerkdaccel)

if xdisp>0
    amax=-amax;
else
    velmax_in=-velmax_in;
end

if amax<0
    j1=jerkdaccel;
    j3=jerkaccel;
    [delta_v1,~,delta_t1]=delta_velocidad(0,amax,j1,1,0);
    [delta_v3,~,~]=delta_velocidad(amax,0,j3,1,0);
    [delta_v3,delta_x3,~]=delta_velocidad(amax,0,j3,2,(0-delta_v3));
    c=-xdisp+2*((1/6)*j1*(delta_t1^3)+(1/(2*-amax))*(delta_v3^2-delta_v1^2)+delta_x3);
else
    j1=jerkaccel;
    j3=jerkdaccel;
    [delta_v1,~,delta_t1]=delta_velocidad(0,amax,j1,1,0);
    [delta_v3,~,~]=delta_velocidad(amax,0,j3,1,0);
    [delta_v3,delta_x3,~]=delta_velocidad(amax,0,j3,2,(0-delta_v3));
    c=-xdisp+2*((1/6)*j1*(delta_t1^3)+(1/(2*amax))*(delta_v3^2-delta_v1^2)+delta_x3);
end

a=2*(-1/(2*amax));
b=2*(delta_t1-(2*delta_v1)/(2*amax));
coef=[a b c];
r=roots(coef);
if abs(r(2))>=abs(velmax_in)
    velmax_out=velmax_in;
else
    velmax_out=r(2);
end

end

