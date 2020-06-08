global m;
m = 1;
global g;
g = 10;
global b;
b = 1;

optimize_integral();


% эта функция решает уравнение z'' + k_d*z' + k_p(z-z*) = 0
% при начальных условиях z(0) = 0, z'(0) = 0
% z_n - это z*
% K = [k_d, k_p]
% на выходе получаем t, z и z'
function [t, z] = z_sol(K, z_n, tspan)
%   система такая:
%   z1' = z2
%   z2' = - k_p/m*z1 - k_d/m*z2 + k_p/m*z_n
    global m;
    k_d = K(1); k_p = K(2);
    f = @(t, z) [0, 1; -k_p/m, -k_d/m] * z + [0; k_p/m * z_n];
    z_0 = [0; 0];
    [t, z] = ode45(f, tspan, z_0);
    t = transpose(t);
    z = transpose(z);
end

% эта функция вычисляет T, пользуясь z, z', k_d, k_p, z*
% считаем, что T_0 = mg
% z_der - z'
% z_n - z*
function res = T(z, z_der, K, z_n)
    global m; global g;
    k_d = K(1); k_p = K(2);
    res = k_p * (z - z_n) + k_d * z_der + m * g;
end

% эта функция методом трапеций вычисляет интеграл J(T)
% по заданным k_d, k_p, z_n
function res = J(K, z_n, tspan)
    global m; global g;
    [t, z] = z_sol(K, z_n, tspan);
    z_der = z(2, :);
    z = z(1, :);
    
    T_1 = T(z, z_der, K, z_n);
%   проверим ограничения на T, если они не выполняются, то возвращаем nan
    if any(T_1 < 0) || any(T_1 > 4 * m * g)
        res = nan;
        return;
    end

%   считаем значения подынтегральной функции в точках
%   будем использовать их для нахождения интеграла
    f = (z - z_n).^2 + z_der.^2 + T(z, z_der, K, z_n).^2;
    
%   на отрезках посчитаем значения интеграла методом трапеций
    integrals = (f(1:end-1) + f(2:end)) .* (t(2:end) - t(1:end-1)) ./ 2;
    
%   и теперь сложим эти значения
    res = sum(integrals);
end

% здесь мы минимизируем значение интеграла, изменяя параметры k_d и k_p
function optimize_integral()
    z_n = 10; % высота, на которую мы хотим подняться
    tspan = [0, 50];
    K_0 = [0; 0]; % изначальные коэффициенты
    K = fminsearch(@(K) J(K, z_n, tspan), K_0);
    
%   выводим график z при изначальном K и при оптимальном
    clf
    hold on
    [t, z] = z_sol(K_0, z_n, tspan);
    K_0_legend = sprintf("k_d = %f, k_p = %f, J(T) = %f", K_0(1), K_0(2), J(K_0, z_n, tspan));
    plot(t, z(1, :), 'DisplayName', K_0_legend);
    
    [t, z] = z_sol(K, z_n, tspan);
    K_legend = sprintf("k_d = %f, k_p = %f, J(T) = %f", K(1), K(2), J(K, z_n, tspan));
    plot(t, z(1, :), 'DisplayName', K_legend);
    
    legend
    hold off
end