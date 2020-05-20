% в этом методе y_k+1 находим по следующей формуле:
% y_k+1 = y_k + h * f(t_k+1, y_k+1)
% это уравнение решаем относительно y_k+1 методом хорд.
function [t, y] = backward_euler(f, tspan, y_0, steps)
    t = linspace(tspan(1), tspan(2), steps);
    size_y_0 = size(y_0); 
    size_t_0 = size(t);
    y = zeros(size_y_0(1), size_t_0(2));
%   здесь за y_1 берём y_0, а за y_2 сначала берём значение, предсказанное методом
%   Эйлера, потом изменяем его при помощи метода хорд.
    y(:, 1) = y_0;
    y(:, 2) = y(:, 1) + (t(2) - t(1)) * f(t(1), y(:, 1));
    y(:, 2) = predict_with_secant_method(f, t(2), t(1), y(:, 2), y(:, 1));
    for i = 3:length(t)
        y(:, i) = predict_with_secant_method(f, t(i), t(i - 1), y(:, i - 1), y(:, i - 2)); 
    end
end

% на вход подаётся f(x, y), два предыдущих значения y, предыдущее t и то, 
% для которого предсказываем.
% Здесь мы приводим уравнение для нахождения сделующий y к виду F(y) = 0,
% после чего решаем его методом хорд.
function y = predict_with_secant_method(f, t_curr, t_prev, y_prev1, y_prev2)
    h = t_curr - t_prev;
%   здесь мы преобразуем уравнение для нахождения y к виду F(y_i) = 0
    func = @(y) y - y_prev1 - h * f(t_curr, y);
%   и применяем метод хорд для нахождения y
    y = secant_method(func, y_prev1, y_prev2);
end