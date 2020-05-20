% Решаем уравнение y'' = 16.81y. Получаем, что аналитическое решение:
% y = C_1 * e^(4.1x) + C_2 * e^(-4.1x)

% Принимая в рассмотрение начальные условия y(0) = 1, y'(0) = -4.1,
% получаем y = e^(-4.1x).
% 
% Теперь для применения численных методов представим данное уравнение в виде
% системы:
% y_1' = y_2
% y_2' = 16.81 * y_1
% С начальными условиями y_1(0, y) = 1, y_2(0, y) = -4.1

first_equation();

% y'' = 16.81y
function first_equation()
    f = @(x, y) [0 1; 16.81 0] * y;
    an_sol = @(x) exp(-4.1 * x);
    an_sol_str = 'y(x) = exp(-4.1 * x)';
    tspan = [0 10];
    steps = 100;
    y_0 = [
        1
        -4.1
    ];

    print_solutions(an_sol, an_sol_str, f, tspan, y_0, steps);
end

% y'' + 8.2y' + 16.81y = 0, y(0) = 1, y'(0) = -4.1
% 
% в виде системы:
% y1' = y2
% y2' = -16.81y1 - 8.2y2
% 
% решение: y = e^(-4.1x)
function second_equation()
    f = @(x, y) [0 1; -16.81 -8.2] * y;
    an_sol = @(x) exp(-4.1 * x);
    an_sol_str = 'y(x) = exp(-4.1 * x)';
    tspan = [0 10];
    steps = 100;
    y_0 = [
        1
        -4.1
    ];

    print_solutions(an_sol, an_sol_str, f, tspan, y_0, steps);
end