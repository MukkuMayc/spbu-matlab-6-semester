

y_f = 10;
m = 1;
p = 0.1;
tspan = [0, 30];
y_0 = [0; 00];
optimize(y_f, m, p, tspan, y_0); 


% запишем уравнение движения в виде системы
% y_1 = y
% y_1' = y_2
% y_2' = u/m - p*y_2/m = k_1/m(y_1 - y_f) + k_2/m*y_2 - p*y_2/m = 
% = y_1*k_1/m + y_2*(k_2 - p)/m - k_1*y_f/m
% получаем
% y_1' = y_2
% y_2' = y_1*k_1/m + y_2*(k_2 - p)/m - k_1*y_f/m

% это правая часть 
function res = f(~, y, y_f, m, p, K)
    res = [0, 1; K(1)/m, (K(2) - p)/m] * y + [0; -K(1) * y_f/m];
end

function [t, y] = y_sol(y_f, m, p, K, tspan, y_0)
    t0 = tspan(1):0.1:tspan(2);
    [t, y] = ode45((@(t, y) f(t, y, y_f, m, p, K)), t0, y_0);
end

function e = err_in_points(t, y, y_f)
    ub = 1.02 * y_f;
    lb = f_lower_bound(t, y_f);
    
    e_1 = (y < lb) .* (y - lb).^2;
    e_2 = (y > ub) .* (y - ub).^2;
    e = e_1 + e_2;
end

function integral = J(K, y_f, m, p, tspan, y_0)
    [t, y] = y_sol(y_f, m, p, K, tspan, y_0);
    integral = sum(err_in_points(t, y(:, 1), y_f));%err_vec(t, y(:, 1), y_f);
end

function res = f_lower_bound(t, y_f)
    res = (t > 3) * 0.98 * y_f;
end

function optimize(y_f, m, p, tspan, y_0)
    K_0 = [0; 0];
    K = fminsearch(@(K) J(K, y_f, m, p, tspan, y_0), K_0);
    
    clf
    subplot(2, 1, 1);
    hold on
    [t, y] = y_sol(y_f, m, p, K, tspan, y_0);
    plot(t, y(:, 1), 'DisplayName', "K = " + mat2str(K));
    [t, y] = y_sol(y_f, m, p, K_0, tspan, y_0);
    plot(t, y(:, 1), 'DisplayName', "K = " + mat2str(K_0));
%   границы коридора
    plot(t, f_lower_bound(t, y_f));
    plot(t, ones(size(t)) * 1.02 * y_f);
    legend
    disp(K);
    hold off
    subplot(2, 1, 2);
    hold on
    [t, y] = y_sol(y_f, m, p, K, tspan, y_0);
    e = err_in_points(t, y(:, 1), y_f);
    plot(t, e, 'DisplayName' , "K = " + mat2str(K));
    [t, y] = y_sol(y_f, m, p, K_0, tspan, y_0);
    e = err_in_points(t, y(:, 1), y_f);
    plot(t, e, 'DisplayName' , "K = " + mat2str(K_0));
    hold off
end