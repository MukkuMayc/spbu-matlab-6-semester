function y = secant_method(f, x_0, x_1)
    eps = 1e-9;
    x_prev = x_0;
    x_curr = x_1;
    f_delta = f(x_curr) - f(x_prev);
    while (all(abs(f_delta) > [0; 0]) && norm(f(x_curr)) > eps)
        x_temp = x_curr;
        x_curr = x_curr - f(x_curr) .* (x_curr - x_prev) ./ f_delta;
        x_prev = x_temp;
        f_delta = f(x_curr) - f(x_prev);
    end
    y = x_curr;
end