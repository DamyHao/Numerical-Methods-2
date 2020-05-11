%% Practica_19_Casas_Mercade

%% Section A

% x = (v,r)
% fun: (v,r) --> (dr/dt, dv/dt)
format long g;
close all;
clc;
clear all;

h = 1e-2;
time = 2;
points = time / h+1;
initial = [0, 0, 1, 1]';

%With RK4 we get the addition steps for the AB4
solutionRK = RK4(initial, h, @gravFunctionV, points);
aditionalSteps=solutionRK(:, 1:4);

%With AB4 we get the the positions and velocities of m during the first two
%seconds since its launch
solutionAB = AB4(aditionalSteps, h, @gravFunctionV, points);
figure;
plot(solutionAB(1, :), solutionAB(2, :));
title('TRAJECTORY OF THE PARTICLE')
xlabel('x')
ylabel('y')

% To calucate the error we first calculate the exact solution, which we
% will consider that is the one obtained for h=1e-4
hext = 1e-4;
points = time / hext +1;
exactSolutionRK = RK4(initial, hext, @gravFunctionV, points);
rext = exactSolutionRK(1:2, end);

%Now we find the position at t=2 for values of h bigger than hext=1e-4, and
%calculate the diffrence with the exact solution. We do this with RK4 and
%AB4 to see the order of the error obtained with each method.

errorsRK = [];
errorsAB = [];
hs = [];
haches = 1e-3:0.0001:0.1;

for h = haches
    points = time / h + 1;
    %RK i AB gives us the n+1 point so in order to obatin the one
    %corresponding to t=2 we have to add this plus one
    
    % TODO: millorar
    if floor(points) == points
        % The number of points must be a natural number and for some values
        %of h it is a decimal one, we one use those values that gives a
        %natural number of points
        hs = [hs h];
        solutionRK = RK4(initial, h, @gravFunctionV, points);
        r = solutionRK(1:2, end);
        errorsRK = [errorsRK norm(r - rext)];
        
        %As done before, we use the first three steps provided by RK plus
        %the intial condition
        solutionAB = AB4(solutionRK(:, 1:4), h, @gravFunctionV, points);
        r2 = solutionAB(1:2, end);
        errorsAB = [errorsAB norm(r2 - rext)];
        
    end

end

figure;
loglog(hs, errorsRK)
hold on
loglog(hs, errorsAB)
hold off
title('Error dependence of h')
xlabel('h')
ylabel('\epsilon (h)')
legend('RK','AB')

%% CAL RESPONDRE LA TEORIA
% Com en el grafic logaritmic, amb el ab4 aconseguim precisio de 10-4 amb 
% h = 0.008 i abs amb 0.025

% RK4 sera 4 vegades mes costos que el AB4

%% Section B)
%Since for theta=pi/4 it was seen that the time taken was less than t=2 we 
%keep the angle but reduce the time for the inital guess
z0=[pi/4,1.8]';
[XK, resd, it] = newtonn(z0, 1e-8, 100, @funForNewton);
disp('The inital angle is')
disp(XK(1,end))
disp('The time of arrival is')
disp(XK(2,end))

%{
function r = funForNewton(z)
%Funcio per tirar newton en una variable a la practica 10:
%The input z is a vector of two components, the first one corresponds to
%the launch angle of the particle and the second one to the time that it
%takes to get to the origin

initial = [ 0; 0; sqrt(2).*cos(z(1)); sqrt(2).*sin(z(1))];
steps=20000;%h will be smaller than 0.0001 since we want the time to be <2
if z(2)<2
    h=z(2)/steps;
    sol = RK4(initial, h, @gravFunctionV, steps+1);
    r = sol(1:2, end);
else
    disp('Try another initial guess for the newton')
end
end
%}

%{
function [XK, resd, it] = newtonn(x0, tol, itmax, fun)
    % This code is the newton method for nonlionear systems, is an 
    % iterative method that allows you to approximate the solution of the
    % system with a precision tol
    
    % [XK, resd, it] = newtonn(x0, tol, itmax, fun)
    
    % INPUTS:
    % x0 = initial guess  --> column or file vector (specify later)
    % tol = tolerance so that ||x_{k+1} - x_{k} | < tol
    % itmax = max number of iterations allowed
    % fun = @ function's name
    % OUTPUT:
    % XK = matrix where the xk form 0 to the last one are saved (the last
    % one is the solution) --> saved as columns
    % Resd = resulting residuals of iteration: ||F_k||, we want it to be 0,
    % as we are looking for f(x)=0
    % it = number of required iterations to satisfy tolerance
    %Utilitzara la funcio que estigui cirdad la ultima
    %En aquet cas les prioritaries seran les de la practica2.
    
    
    % Atencio, pirmer comprobara a a la carpeta actual si hi son

    xk = [x0]; 
    XK = [x0]; 
    resd = [norm(feval(fun, xk))]; 
    it = 1; 
    tolk = 1;

    while it < itmax && tolk > tol
        J = jaco(fun, xk); % Jacobia en la posicio anterior
        fk = feval(fun, xk); 
        [P, L, U] = PLU(J);
       
        Dx = pluSolve(L, U, P, (-fk)'); %Solucio de la ecuacio J*Dx = -fk

        %Dx = J\(-fk)';
        xk = xk + Dx;
        XK = [XK, xk];
        resd = [resd, norm(fk)];
        tolk = norm(XK(:, end) - XK(:, end - 1));
        it = it + 1;
        
    end
end
%}



%% Section C

h = 1e-3;
v=sqrt(2);

thetas=[pi/2,0,-pi/2];
figure;

for i=thetas
    %The intial theta guess is based on the problem's symmetry
    z0=[pi/4+i,1.8]';
    %We use newton to find which is the launch angle and the tiem required
    %to get to the origin again
    [XK, resd, it] = newtonn(z0, 1e-8, 100, @funForNewton); 
    %Once it has been obatined we use those results to know how many steps
    %are required and the components of the inital velocity, and with this
    %information we can proced as in section A in order to do the plot of
    %the tragectory followed by the particle
    points = floor(XK(2,end) / h)+2;
    initial = [0, 0, v*cos(XK(1,end)), v*sin(XK(1,end))]';
    solutionRK = RK4(initial, h, @gravFunctionV, points);
    plot(solutionRK(1, :), solutionRK(2, :),'LineWidth',2)
    grid on
    hold on
end
massPositions=[0,1;1,0;0,-1];
plot(massPositions(1:2,1),massPositions(1:2,2),'o','MarkerEdgeColor','k','MarkerFaceColor','k')
plot(massPositions(3,1),massPositions(3,2),'o','LineWidth',7,'MarkerEdgeColor','k','MarkerFaceColor','k')
text(massPositions(1,1),massPositions(1,2), '\leftarrow mas1', 'FontSize', 12)
text(massPositions(3,1),massPositions(3,2), '\leftarrow mas2', 'FontSize', 12)
text(massPositions(2,1),massPositions(2,2), '\leftarrow mas3', 'FontSize', 12)




