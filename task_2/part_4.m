% x'' + 100000.001x' + 100x = 0
% 
% x1 = x
% x1' = x2
% x' = -100x1 - 100000.001x2
% 
% общее решение: x = c1 e^(-0.001t) + c2 e^(-100000t)
% пусть c1 = c2 = 1
% пусть
% x(0) = 0
% x'(0) = 1
% тогда
% с1 примерно равно -1e-5
% c2 = -c1 = 1e-5
% 
% У этого уравнения высокий коэффициент жёсткости - 10^8. Явный метод
% Эйлера начинает сходиться только при h < 1/50000. А вот неявный сходится
% при любом шаге.
f = @(t, x) [0 1; -100 -100000.001] * x;

tspan = [0 1];

x_0 = [0; 1];

% backward_euler_steps(f, tspan, x_0);
forward_euler_steps(f, tspan, x_0);

function backward_euler_steps(f, tspan, x_0)
    steps = 2.^linspace(1, 10, 10) .* 10;
    
    hold on
    for i = 1:10
        [t, x] = backward_euler(f, tspan, x_0, steps(i));
        plot(t, x(1, :), 'DisplayName', "step=" + num2str(steps(i)));
    end
    legend
    hold off
end

function forward_euler_steps(f, tspan, x_0)
    steps = linspace(50001, 50010, 10);
    
    hold on
    for i = 1:10
        [t, x] = forward_euler(f, tspan, x_0, steps(i));
        plot(t, x(1, :), 'DisplayName', "step=" + num2str(steps(i)));
    end
    legend
    hold off
end