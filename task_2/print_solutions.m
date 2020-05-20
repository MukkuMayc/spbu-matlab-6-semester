% an_sol - точное решение системы
% an_sol_str - точное решение в виде строки, нужно для названия графика
% f - правая часть системы
% y_0 - y(0)
% steps - количество шагов
function print_solutions(an_sol, an_sol_str, f, tspan, y_0, steps)
    hold on
    
    t = linspace(tspan(1), tspan(2), steps);
    plot(t, an_sol(t), 'DisplayName', an_sol_str);
    
    [t, y] = forward_euler(f, tspan, y_0, steps);
    plot(t, y(1, :), 'DisplayName', 'forward euler');
    
    [t, y] = backward_euler(f, tspan, y_0, steps);
    plot(t, y(1, :), 'DisplayName', 'backward euler');
    
    [t, y] = runge_kutta(f, tspan, y_0, steps);
    plot(t, y(1, :), 'DisplayName', 'runge kutta');
    
    legend
    
    title_str = sprintf("%s, [%d, %d], steps = %d", an_sol_str, tspan(1), tspan(2), steps);
    title(title_str);
    
    hold off
end