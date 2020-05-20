function [t, y] = runge_kutta(f, tspan, y_0, steps)
    t = linspace(tspan(1), tspan(2), steps);
    size_y_0 = size(y_0); 
    size_t_0 = size(t);
    y = zeros(size_y_0(1), size_t_0(2));
    y(:, 1) = y_0;
    for i = 2:length(t)
        h = t(i) - t(i - 1);
        k1 = f(t(i - 1), y(:, i - 1));
        k2 = f(t(i - 1) + h/2, y(:, i - 1) + h/2 * k1);
        k3 = f(t(i - 1) + h/2, y(:, i - 1) + h/2 * k2);
        k4 = f(t(i - 1) + h, y(:, i - 1) + h * k3);
        y(:, i) = y(:, i - 1) + h / 6 * (k1 + 2 * k2 + 2 * k3 + k4);
    end
end