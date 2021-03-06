function [P, L, U] = PLUAlvaro(A)
    % PLUAlvaro Funcio copiada tal qual de la pissarra
    [m, n] = size(A); if m ~= n; error = ('not square matrix'); end
    U = A; L = eye(n); P = [1:n]';

    for k = 1:n - 1
        [foo, imax] = max(abs(U(k:end, k)));
        imax = imax + k - 1; i1 = [k, imax]; i2 = [imax, k];
        U(i1, :) = U(i2, :); P(k) = imax;
        L(i1, 1:k - 1) = L(i2, 1:k - 1);

        for j = [k+1:n]
            L(j, k) = U(j, k) / U(k, k);
            U(j, k:n) = U(j, k:n) - L(j, k) * U(k, k:n);
        end

    end

end
