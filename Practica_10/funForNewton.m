function r = funForNewton(z)
%Funcio per tirar newton en una variable a la practica 10:
%The input z is a vector of two components, the first one corresponds to
%the launch angle of the particle and the second one to the time that it
%takes to get to the origin

initial = [ 0; 0; sqrt(2).*cos(z(1)); sqrt(2).*sin(z(1))];
steps=20000; %h will be smaller than 0.0001 since we the time to be < 2
if 0<z(2)<2
    h=z(2)/steps;
    sol = RK4(initial, h, @gravFunctionV, steps+1);
    r = sol(1:2, end);
else
    disp('Try another initial guess for the newton')
end
end