f = @(t, x) -10000 * x;

tspan = [0 1];

x_0 = 1;

% backward_euler_steps(f, tspan, x_0);
forward_euler_steps(f, tspan, x_0);

function backward_euler_steps(f, tspan, x_0)
    steps = 2.^linspace(1, 10, 10) .* 10;
    
    hold on
    for i = 1:10
        [t, x] = backward_euler(f, tspan, x_0, steps(i));
        plot(t, x, 'DisplayName', "step=" + num2str(steps(i)));
    end
    legend
    hold off
end

function forward_euler_steps(f, tspan, x_0)
    steps = linspace(5001, 5010, 10);
    
    hold on
    for i = 1:10
        [t, x] = forward_euler(f, tspan, x_0, steps(i));
        plot(t, x, 'DisplayName', "step=" + num2str(steps(i)));
    end
    legend
    hold off
end