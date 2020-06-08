global m;
m = 1;
global g;
g = 10;
global b;
b = 1;

optimize_integral();


% эта функция решает уравнение z'' + k_d*z' + k_p(z-z*) = 0
% h - это z*
% K = [k_d; k_p]
% на выходе получаем t, z и z'
function [t, z] = z_sol(K, z_0, h, tspan)
%   система такая:
%   z1' = z2
%   z2' = - k_p/m*z1 - k_d/m*z2 + k_p/m*h
    global m;
    k_d = K(1); k_p = K(2);
    f = @(t, z) [0, 1; -k_p/m, -k_d/m] * z + [0; k_p/m * h];
    [t, z] = ode45(f, tspan, z_0);
    t = transpose(t);
    z = transpose(z);
end

% эта функция вычисляет T, пользуясь z, z', k_d, k_p, z*
% считаем, что T_0 = mg
% z_der - z'
% h - z*
function res = T(z, z_der, K, h)
    global m; global g;
    k_d = K(1); k_p = K(2);
    res = k_p * (z - h) + k_d * z_der + m * g;
end

% эта функция методом трапеций вычисляет интеграл J(T)
% по заданным k_d, k_p, h
function integral = J(K, z_0, h, tspan)
    global m; global g;
    [t, z] = z_sol(K, z_0, h, tspan);
    z_der = z(2, :);
    z = z(1, :);
    
    T_1 = T(z, z_der, K, h);
%   проверим ограничения на T, если они не выполняются, то возвращаем nan
    if any(T_1 < 0) || any(T_1 > 4 * m * g)
        integral = nan;
        return;
    end

%   считаем значения подынтегральной функции в точках
%   будем использовать их для нахождения интеграла
    f = (z - h).^2 + z_der.^2 + T_1.^2;
    
%   вычислим интеграл методом трапеций
    integral = trapz(t, f);
end

% здесь мы минимизируем значение интеграла, изменяя параметры k_d и k_p
function optimize_integral()
    h = 10; % высота, на которую мы хотим подняться
    tspan = [0, 50];
    K_0 = [0; 0]; % изначальные коэффициенты
    z_0 = [0; 0];
    K = fminsearch(@(K) J(K, z_0, h, tspan), K_0);
    
%   выводим график z при изначальном K и при оптимальном
    clf
    hold on
    [t, z] = z_sol(K_0, z_0, h, tspan);
    K_0_legend = sprintf("k_d = %f, k_p = %f, J(T) = %f", K_0(1), K_0(2), J(K_0, z_0, h, tspan));
    plot(t, z(1, :), 'DisplayName', K_0_legend);
    
    [t, z] = z_sol(K, z_0, h, tspan);
    K_legend = sprintf("k_d = %f, k_p = %f, J(T) = %f", K(1), K(2), J(K, z_0, h, tspan));
    plot(t, z(1, :), 'DisplayName', K_legend);
    
    legend
    hold off
end