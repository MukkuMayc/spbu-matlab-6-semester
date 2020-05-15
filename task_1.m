plot_tspan = [5 3];

% y' = sqrt(1 - y^2)
% Если мы подставим sin(x) в уравнение, то получим решение только на
% [0, pi/2], поскольку sqrt(1 - sin(x)^2) > 0, а (sin(x))' < 0 при x >
% pi/2. Поэтому sin(x) является решением только на [0, pi/2]. 
subplot(5,1,1);
check_sin_x();

% Стоит отметить, что у уравнения y' = sqrt(1 - y^2) есть 2 решения: 
% y = sin(x + c) и y = 1.
f1 = @(x, y) sqrt(1 - y.^2);
tspan = [0 3];
test_methods(f1, tspan, 0, plot_tspan, 1);

% y' = y^2 + 1
% аналитическим решением является y = tg(x), оно уходит в бесконечность при
% x -> pi/2, поэтому вычисления прерываются при pi/2.
f2 = @(x, y) y.^2 + 1.;
tspan = [0 pi() / 2 - 0.01];
test_methods(f2, tspan, 0, plot_tspan, 2);

% y' = y^(1/3)
% Здесь не выполняется условие Липшица, поэтому получаемое решение не
% единственное.
f3 = @(x, y) y.^(1/3);
tspan = [0 5];
test_methods(f3, tspan, 0, plot_tspan, 3);
% Вообще, решениями тут являются y = (2/3x + 2/3c)^(3/2) и y = 0.
% И если отойти от y = 0, то условие Липшица уже будет выполняться.
% Этот случай рассмотрен ниже.

% Здесь мы отступили от точки y = 0 на 0.01, то есть y_0 = 0.01.
tspan = [0 5];
test_methods(f3, tspan, 0.01, plot_tspan, 4);

% эта функция выводит графики решений, получаемых 3-мя различными способами:
% 1) методом Рунге-Кутты
% 2) методом Эйлера
% 3) встроенным методом Рунге-Кутты
% переменные:
% f - f(x, y), правая часть уравнения
% tspan - область, на которой ищем решение
% y_0 - значение y(x) в самой левой точке
% plot_tspan - размеры таблицы, в которой расположены графики
% f_ind - номер функции, чтобы разместить графики правильно среди остальных
function test_methods(f, tspan, y_0, plot_tspan, f_ind)
    subplot(plot_tspan(1), plot_tspan(2), 1 + f_ind * 3);
    [t, y] = runge_kutta(f, tspan, y_0);
    plot(t, y);

    subplot(plot_tspan(1), plot_tspan(2), 2 + f_ind * 3);
    [t, y] = euler_sol(f, tspan, y_0);
    plot(t, y);

    subplot(plot_tspan(1), plot_tspan(2), 3 + f_ind * 3);
    [t, y] = ode45(f, tspan, y_0);
    plot(t, y);
end

% эта функция проверяет решение sin(x)
% для проверки мы в выражение y' = sqrt(1 - y^2) подставим sin(x) =>
% => cos(x) = sqrt(1 - sin(x)^2), а теперь перенесём всё в левую часть
% и будем сравнивать её с нулём
% cos(x) - sqrt(1 - sin(x)^2) = 0
function check_sin_x()
    func = @(x) cos(x) - sqrt(1 - (sin(x)).^2);
    x_vec = linspace(0, pi, 1000);
    plot(x_vec, func(x_vec));
end

function [t, y] = euler_sol(f, tspan, y_0)
    t = linspace(tspan(1), tspan(2), 1e3);
    y = zeros(size(t));
    y(1) = y_0;
    for i = 2:length(t)
        y(i) = y(i - 1) + (t(i) - t(i - 1)) * f(t(i - 1), y(i - 1));
    end
end

function [t, y] = runge_kutta(f, tspan, y_0)
    t = linspace(tspan(1), tspan(2), 1e3);
    y = zeros(size(t));
    y(1) = y_0;
    for i = 2:length(t)
        h = t(i) - t(i - 1);
        k1 = f(t(i - 1), y(i - 1));
        k2 = f(t(i - 1) + h/2, y(i - 1) + h/2 * k1);
        k3 = f(t(i - 1) + h/2, y(i - 1) + h/2 * k2);
        k4 = f(t(i - 1) + h, y(i - 1) + h * k3);
        y(i) = y(i - 1) + h / 6 * (k1 + 2 * k2 + 2 * k3 + k4);
    end
end