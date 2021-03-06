function [XK, conv, it] = test(x0, tol, itmax, fun)
% Com el newtonn, pero assegurant-nos que s'ha trobat una solucio.
% Tambe s'elimina resd
% This code is the newton method for nonlionear systems, is an iterative
% method that allows you to approximate the solution of the system with a
% precision tol

% INPUT:
% x0 = initial guess  --> column vector
% tol = tolerance so that ||x_{k+1} - x_{k} || < tol
% itmax = max number of iterations allowed
% fun = @ ffunction_handler
% OUTPUT:
% XK = matrix where the xk form 0 to the last one are saved (the last
% one is the solution) --> saved as columns
% conv: 1 si ha arribat a la solucio, 0 si no.
% it = Nombre de iteracions que han sigut requerides

xk = [x0];
XK = [x0];
it = 1;
tolk = 1;

while it < itmax && tolk > tol
    J = jaco(fun, xk); % Jacobia en la posicio anterior
    fk = feval(fun, xk);
    [P, L, U] = PLU(J);
    % Si entra un vector fila sha de transposar. Si es columna no
    Dx = pluSolve(L, U, P, (-fk)); %Solucio de la ecuacio J*Dx = -fk
    % Intenta resoldre aquest sistema
    Dx2 = J\(-fk);
    disp(norm(Dx -Dx2));
    xk = xk + Dx;
    XK = [XK, xk];
    
    tolk = norm(XK(:, end) - XK(:, end - 1));
    it = it + 1;
end

% Mirem si de veritat hem trobat una solucio
if(it >= itmax || sum(isnan(XK(:, end))) > 0)
    conv = 0;
else
    conv = 1;
end
