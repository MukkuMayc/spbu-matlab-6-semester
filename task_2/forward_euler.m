function [t, y] = forward_euler(f, tspan, y_0, steps)
    t = linspace(tspan(1), tspan(2), steps);
    size_y_0 = size(y_0); 
    size_t_0 = size(t);
    y = zeros(size_y_0(1), size_t_0(2));
    y(:, 1) = y_0;
    for i = 2:length(t)
        y(:, i) = y(:, i - 1) + (t(i) - t(i - 1)) * f(t(i - 1), y(:, i - 1));
    end
end