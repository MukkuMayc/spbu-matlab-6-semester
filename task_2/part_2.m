% y = theta
% линейные случаи:
% f1: y'' + y = 0
% y1' = y2
% y2' = -y1
% | 0  1|   |y1|
% |-1  0| * |y2|
% f2: y'' + vy' + y = 0
% y1' = y2
% y2' = -y1 - vy2
% | 0   1|   |y1|
% |-1  -v| * |y2|

% нелинейные случаи:
% f1: y'' + sin(y) = 0
% y1' = y2
% y2' = -sin(y1)
% |0  1|   |y1|   | 0      |
% |0  0| * |y2| + |-sin(y1)|
% f2: y'' + vy' + sin(y) = 0
% y1' = y2
% y2' = -vy2 - sin(y1)
% |0   1|   |y1|   | 0      |
% |0  -v| * |y2| + |-sin(y1)|

clf

% y'' + y = 0
% Стоит отметить, что решение y = 0 является устойчивым.
% Решения лежат в окрестности y = 0, но не сходятся к нему.
f = @(t, y, nu) [0 1; -1 0] * y;
tspan = [0 50];
y_0_0 = [5; 0]; y_n_0 = [0; 1];
nu_0 = 0; nu_n = 0;
steps = 5;
plot_pos = [2, 2, 1];
plot_title = "Линейная модель без трения";
vary_func(f, y_0_0, y_n_0, nu_0, nu_n, tspan, steps, plot_pos, plot_title);

% y'' + nu*y' + y = 0.
% Варьируем nu - коэффициент трения. y(0) = 0, y'(0) = 1
% Здесь любое решение сходится к нулю при nu > 0, поэтому y = 0 является
% асимптотически устойчивым.
f = @(t, y, nu) [0 1; -1 -nu] * y;
y_0_0 = [pi; 0]; y_n_0 = [pi; 0];
nu_0 = 0; nu_n = 1;
plot_pos = [2, 2, 2];
plot_title = "Линейная модель c трением";
vary_func(f, y_0_0, y_n_0, nu_0, nu_n, tspan, steps, plot_pos, plot_title);

% y'' + sin(y) = 0
% на графиках можем видеть, что при Th(0) = pi решения не являются
% устойчивыми
f = @(t, y, nu) [0 1; 0 0] * y + [0; -1] .* sin(flip(y));
y_0_0 = [pi; 0]; y_n_0 = [pi; 1];
nu_0 = 0; nu_n = 0;
plot_pos = [2, 2, 3];
plot_title = "Нелинейная модель без трения";
vary_func(f, y_0_0, y_n_0, nu_0, nu_n, tspan, steps, plot_pos, plot_title);

% y'' + nu*y' + sin(y) = 0
% на графиках можем видеть, что при Th(0) = pi решения являются
% асимптотически устойчивыми, если nu > 0
tspan = [0 200];
f = @(t, y, nu) [0 1; 0 -nu] * y + [0; -1] .* sin(flip(y));
y_0_0 = [pi; 0]; y_n_0 = [pi; 0];
nu_0 = 0; nu_n = 1;
plot_pos = [2, 2, 4];
plot_title = "Нелинейная модель c трением";
vary_func(f, y_0_0, y_n_0, nu_0, nu_n, tspan, steps, plot_pos, plot_title);

% в этой функции мы варьируем y_0 и nu, при этом выводя получившиеся
% графики
% f - функция f(t, y, nu)
% y_0_0, y_0_n - границы изменения y_0
% nu_0, nu_n - границы изменения nu
% tspan - область, на которой ищем решение
% steps - количество шагов, сколько будет графиков
% plot_pos - позиция графика как подграфика
% plot_title - название графика
function vary_func(f, y_0_0, y_0_n, nu_0, nu_n, tspan, steps, plot_pos, plot_title)
    nu = linspace(nu_0, nu_n, steps);
    y_0 = [linspace(y_0_0(1), y_0_n(1), steps); linspace(y_0_0(2), y_0_n(2), steps)];
    subplot(plot_pos(1), plot_pos(2), plot_pos(3));
    
    if (nu_0 == nu_n)
        nu_legend = @(nu) "";
    else
        nu_legend = @(nu) sprintf("\\nu = %.2f;", nu);
    end
    if (all(y_0_0 == y_0_n))
        y_0_legend = @(y_0) "";
    else
        y_0_legend = @(y_0) sprintf("\\theta_0 = %s;", mat2str(y_0, 3));
    end
    
    hold on
    for i = 1:steps
        nu_curr = nu(i);
        f_curr = @(t, y) f(t, y, nu_curr);
        [t, y] = ode45(f_curr, tspan, y_0(:, i));
        plot(t, y(:, 1), 'DisplayName', '$' + y_0_legend(y_0(:, i)) + nu_legend(nu_curr) + '$');
    end
%     xtickformat("%.2f");
%     ytickformat("%.2f");
    legend('Interpreter','latex')
    title(plot_title);
    hold off
end